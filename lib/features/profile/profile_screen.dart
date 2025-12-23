import 'package:cuetbus/core/routing/app_routes.dart';
// import 'package:cuetbus/core/services/user_service.dart';
import 'package:cuetbus/features/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // final UserService _userService = UserService();
  String studentName = "";
  String studentId = "";
  String email = "";
  String? profileImagePath; // new
  bool isLoading = true;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // _fetchUser();
    _fetchUserFromHive(); // fetch directly from Hive
  }

  void _fetchUserFromHive() {
    final box = Hive.box(
      'userBox',
    ); // make sure 'userBox' is the same you used for signup

    setState(() {
      studentName = box.get('name') ?? 'Guest';
      studentId = box.get('studentId') ?? 'Unknown ID';
      email = box.get('email') ?? 'Unknown Email';
      profileImagePath = box.get('profileImage'); // fetch stored image
      isLoading = false;
    });
  }

  // Pick image from gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      // Save image to app directory
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = pickedFile.name;
      final savedImage = await File(
        pickedFile.path,
      ).copy('${appDir.path}/$fileName');

      // Store path in Hive
      final box = Hive.box('userBox');
      box.put('profileImage', savedImage.path);

      setState(() {
        profileImagePath = savedImage.path;
      });
    }
  }

  // Show picker options
  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pushNamed(context, AppRoutes.mainNavBar),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          // Top Header
          Container(
            height: 235,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: theme.brightness == Brightness.dark
                    ? [
                        theme.primaryColor.withOpacity(0.7),
                        theme.primaryColor.withOpacity(0.5),
                      ]
                    : [
                        theme.primaryColor,
                        theme.primaryColor.withOpacity(0.85),
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(32),
              ),
            ),
            padding: const EdgeInsets.only(top: 70),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                // Avatar
                GestureDetector(
                  onTap: _showImageSourceSheet,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: theme.brightness == Brightness.dark
                            ? Colors.grey[800]
                            : Colors.white,
                        backgroundImage:
                            profileImagePath != null &&
                                File(profileImagePath!).existsSync()
                            ? FileImage(File(profileImagePath!))
                            : null,
                        child: profileImagePath == null
                            ? Icon(
                                Icons.person_rounded,
                                size: 55,
                                color: theme.primaryColor,
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 24,
                          width: 24,
                          decoration: BoxDecoration(
                            color: theme.primaryColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.scaffoldBackgroundColor,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),
                Text(
                  studentName,
                  style: theme.textTheme.titleMedium!.copyWith(
                    // color: Colors.white,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "ID: $studentId",
                  style: theme.textTheme.bodySmall!.copyWith(
                    // color: Colors.white70,
                    color: const Color.fromARGB(255, 233, 231, 231),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Profile Info Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: theme.brightness == Brightness.dark
                        ? Colors.white12
                        : Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: infoRow("Email", email),
            ),
          ),

          const SizedBox(height: 26),

          // Action Buttons
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                actionTile(Icons.history_rounded, "My Bookings", () {
                  Navigator.pushNamed(context, AppRoutes.bookingList);
                }),
                actionTile(
                  Icons.notifications_active_rounded,
                  "Notifications",
                  () {
                    Navigator.pushNamed(context, AppRoutes.notification);
                  },
                ),
                actionTile(Icons.settings_rounded, "Settings", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SettingsScreen(studentId: studentId),
                    ),
                  );
                }),
                actionTile(Icons.help_outline_rounded, "Help & Support", () {
                  Navigator.pushNamed(context, AppRoutes.helpSupport);
                }),
                const SizedBox(height: 20),
                logoutButton(context),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget infoRow(String title, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: theme.textTheme.bodyMedium!.color,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontSize: 14,
                color: theme.textTheme.bodySmall!.color,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget actionTile(IconData icon, String title, VoidCallback onTap) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        tileColor: theme.cardColor,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: theme.brightness == Brightness.dark
                ? Colors.white12
                : theme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: theme.primaryColor),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        title: Text(
          title,
          style: theme.textTheme.bodyMedium!.copyWith(
            color: theme.textTheme.bodyMedium!.color,
          ),
        ),
      ),
    );
  }

  Widget logoutButton(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => _showLogoutDialog(context),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: theme.colorScheme.error,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.error.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: Text(
            "Logout",
            style: theme.textTheme.bodyMedium!.copyWith(
              color: theme.colorScheme.onPrimary, // dynamic based on theme
              // color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 10,
          backgroundColor: theme.cardColor,
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.error.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.logout_rounded,
                    size: 40,
                    color: theme.colorScheme.error,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Confirm Logout",
                  style: theme.textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Are you sure you want to logout? You will need to login again to access your account.",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall!.copyWith(
                    color: theme.textTheme.bodySmall!.color?.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: theme.primaryColor,
                          side: BorderSide(color: theme.primaryColor),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);

                          // Clear the Hive box
                          // final box = Hive.box('userBox');
                          // await box.clear(); // removes all stored data
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.error,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("Yes, Logout"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
