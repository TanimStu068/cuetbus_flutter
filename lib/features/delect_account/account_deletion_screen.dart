import 'package:cuetbus/features/auth/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:cuetbus/core/services/account_detete_service.dart';
import 'package:hive/hive.dart';

class AccountDeletionScreen extends StatelessWidget {
  final String studentId;

  const AccountDeletionScreen({super.key, required this.studentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Delete Account",
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Text(
                    "Important Information",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 12),

                  // -------- Card 1: What will be deleted --------
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.only(bottom: 12),
                    color: Theme.of(context).cardColor,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "What will be deleted:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.color, // dynamic color
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "- Your profile information\n"
                            "- Booking history\n"
                            "- Notifications and preferences\n"
                            "- Any saved settings\n"
                            "- Any other personal data stored in the app",
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.color, // dynamic color
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // -------- Card 2: Consequences --------
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.only(bottom: 12),
                    color: Theme.of(context).cardColor,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Consequences:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.color,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Deleting your account is permanent and cannot be undone. "
                            "All your data will be permanently removed from our system. "
                            "You will not be able to access past bookings or notifications.",
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // -------- Card 3: Recreating Account --------
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.only(bottom: 12),
                    color: Theme.of(context).cardColor,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Recreating Account:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.color,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "You can create a new account anytime using your student ID. "
                            "Once you delete this account, a new account will start fresh "
                            "with no previous booking history or settings.",
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // -------- Card 4: Recommendations --------
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.only(bottom: 12),
                    color: Theme.of(context).cardColor,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Recommendations:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.color,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "- Make sure to save any important information before deleting your account.\n"
                            "- Consider logging out if you only want to take a break.\n"
                            "- Deleting is permanent and cannot be undone.",
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // -------- Delete Account Button --------
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  // backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Delete Account",
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onError, // dynamic color
                    // color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text(
                        "Confirm Account Deletion",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      content: Text(
                        "Are you sure you want to delete your account? This action cannot be undone.",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: Text(
                            "Cancel",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: Text(
                            "Delete",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),

                            // style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    final response = await AccountDeleteService.deleteAccount(
                      studentId: studentId,
                    );
                    final message =
                        response["message"] ?? "Something went wrong";

                    // 2️⃣ Delete user data from Hive
                    final box = Hive.box('userBox');
                    await box.clear();

                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(message)));

                    if (message == "Account deleted successfully") {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => SignUpScreen()),
                        (route) => false,
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
