import 'package:cuetbus/core/routing/app_routes.dart';
import 'package:cuetbus/features/change_password/change_password_screen.dart';
import 'package:cuetbus/features/delect_account/account_deletion_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cuetbus/core/theme/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  final String studentId; // add this

  const SettingsScreen({super.key, required this.studentId});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool vibrationEnabled = true;

  @override
  void initState() {
    super.initState();
    // darkModeEnabled = Theme.of(context).brightness == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      //backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,

        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
          onPressed: () {
            Navigator.pop(context); // goes back to previous screen
          },
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          // -------- Account Section -------- //
          sectionTitle("Account"),
          // settingsTile(
          //   icon: Icons.person_rounded,
          //   title: "Edit Profile",
          //   onTap: () {},
          // ),
          settingsTile(
            icon: Icons.security_rounded,
            title: "Change Password",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ChangePasswordScreen(studentId: widget.studentId),
                ),
              );
            },
          ),
          settingsTile(
            icon: Icons.delete_forever_rounded,
            title: "Delete Account",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AccountDeletionScreen(studentId: widget.studentId),
                ),
              );
            },
          ),

          const SizedBox(height: 22),

          // -------- App Preferences -------- //
          sectionTitle("Preferences"),
          switchTile(
            icon: Icons.notifications_active_rounded,
            title: "Enable Notifications",
            value: notificationsEnabled,
            onToggle: (val) {
              setState(() => notificationsEnabled = val);
            },
          ),
          switchTile(
            icon: Icons.dark_mode_rounded,
            title: "Dark Mode",
            value: themeProvider.isDarkMode,
            onToggle: (val) {
              themeProvider.setDarkMode(val);
            },
          ),
          switchTile(
            icon: Icons.vibration_rounded,
            title: "Vibration",
            value: vibrationEnabled,
            onToggle: (val) {
              setState(() => vibrationEnabled = val);
            },
          ),

          const SizedBox(height: 22),

          // -------- About Section -------- //
          sectionTitle("About"),
          settingsTile(
            icon: Icons.info_outline_rounded,
            title: "About CUETBus",
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.aboutApp);
            },
          ),
          settingsTile(
            icon: Icons.policy_rounded,
            title: "Privacy Policy",
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.privacyPolicy);
            },
          ),
          settingsTile(
            icon: Icons.description_rounded,
            title: "Terms & Conditions",
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.termsConditions);
            },
          ),

          const SizedBox(height: 28),

          // -------- App Version -------- //
          Center(
            child: Text(
              "CUETBus v1.0.0",
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context).textTheme.bodySmall!.color,
              ),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // ----------------------------------------------- //
  // SECTION TITLE
  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: Theme.of(context).textTheme.bodyMedium!.color,
        ),
      ),
    );
  }

  // ----------------------------------------------- //
  // REGULAR SETTINGS TILE
  Widget settingsTile({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.05),
            blurRadius: 7,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            // color: Theme.of(context).brightness == Brightness.dark
            //     ? Colors.white12
            //     : AppColors.primary.withOpacity(0.1),
            color: Theme.of(context).cardColor.withOpacity(0.05),

            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Theme.of(context).primaryColor),
        ),
        title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
      ),
    );
  }

  // ----------------------------------------------- //
  // SWITCH TILE
  Widget switchTile({
    required IconData icon,
    required String title,
    required bool value,
    required Function(bool) onToggle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white10
                : Colors.black.withOpacity(0.05),

            blurRadius: 7,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            // color: AppTheme..withOpacity(0.1),
            color: Theme.of(context).cardColor.withOpacity(0.1),

            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Theme.of(context).primaryColor),
        ),
        title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
        trailing: Switch(
          activeColor: Theme.of(context).primaryColor,
          value: value,
          onChanged: onToggle,
        ),
      ),
    );
  }
}
