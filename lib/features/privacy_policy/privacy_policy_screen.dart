import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: theme.appBarTheme.foregroundColor,
          ),
          onPressed: () {
            Navigator.pop(context); // goes back to previous screen
          },
        ),
        centerTitle: true,
        title: Text(
          "Privacy Policy",
          style: TextStyle(color: theme.appBarTheme.foregroundColor),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ----------------- HEADER SECTION ----------------- //
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primary.withOpacity(0.8),
                  // AppColors.primary,
                  // AppColors.primary.withOpacity(0.85),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.privacy_tip_rounded,
                    size: 48,
                    color: theme.primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Your Privacy Matters",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge!.copyWith(
                    color: Colors.white,
                    // color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "CUETBus app collects and manages your data responsibly. Read our privacy policy carefully.",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall!.copyWith(
                    color: theme.textTheme.bodySmall!.color!.withOpacity(0.7),
                    // color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // ----------------- PRIVACY POLICY CONTENT ----------------- //
          Text(
            "Privacy Policy",
            style: theme.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),

          _policySection(
            context,
            "Information Collection",
            "We collect personal information such as student ID, email, and booking history to provide seamless bus booking services and notifications.",
          ),
          _policySection(
            context,
            "Information Usage",
            "Your information is used solely for providing app functionality, notifications about bus schedules, and digital passes. We do not share your data with third parties without consent.",
          ),
          _policySection(
            context,
            "Data Security",
            "We implement industry-standard security measures to protect your data, including encryption, secure storage, and restricted access.",
          ),
          _policySection(
            context,
            "Cookies & Analytics",
            "The app uses minimal analytics and local storage to improve user experience and optimize app performance.",
          ),
          _policySection(
            context,
            "User Rights",
            "You have the right to access, modify, or request deletion of your personal data. Contact support for any privacy-related inquiries.",
          ),

          const SizedBox(height: 28),

          // ----------------- CONTACT ----------------- //
          Text(
            "Contact Us",
            style: theme.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.shadow.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _contactRow(context, "Email", "support@cuetbus.com"),
                const Divider(),
                _contactRow(
                  context,
                  "Institution",
                  "Chittagong University of Engineering and Technology",
                ),
              ],
            ),
          ),

          const SizedBox(height: 38),

          Center(
            child: Text(
              "© 2025 CUET Transport Service",
              style: theme.textTheme.bodySmall!.copyWith(
                color: theme.textTheme.bodySmall!.color!.withOpacity(0.6),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // --------------------------- POLICY SECTION --------------------------- //
  Widget _policySection(BuildContext context, String title, String content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              height: 1.45,
              color: Theme.of(context).textTheme.bodySmall!.color,

              // color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------- CONTACT ROW --------------------------- //
  Widget _contactRow(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(
                  context,
                ).textTheme.bodySmall!.color!.withOpacity(0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
