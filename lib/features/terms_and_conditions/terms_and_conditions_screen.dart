import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

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
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "Terms & Conditions",
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.appBarTheme.foregroundColor,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ----------------- HEADER ----------------- //
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primary.withOpacity(0.85),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withOpacity(0.08),
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
                    Icons.description_rounded,
                    size: 48,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Terms & Conditions",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge!.copyWith(
                    // color: Colors.white,
                    color: Theme.of(
                      context,
                    ).colorScheme.onPrimary, // dynamic color

                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Please read our terms carefully before using the CUETBus app.",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall!.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onPrimary.withOpacity(0.7), // dynamic
                    // color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // ----------------- CONTENT ----------------- //
          _termsSection(
            context,
            "1. Acceptance of Terms",
            "By using CUETBus, you agree to comply with these terms and conditions. Please read them carefully.",
          ),
          _termsSection(
            context,
            "2. Service Usage",
            "CUETBus is designed exclusively for CUET students to book bus seats and receive notifications. Misuse of the service is prohibited.",
          ),
          _termsSection(
            context,
            "3. User Accounts",
            "You are responsible for maintaining the confidentiality of your login credentials and for all activities performed under your account.",
          ),
          _termsSection(
            context,
            "4. Privacy",
            "We collect and manage personal data according to our Privacy Policy. By using the app, you consent to data collection and usage.",
          ),
          _termsSection(
            context,
            "5. Limitation of Liability",
            "CUETBus is provided 'as is'. We are not responsible for delays, errors, or damages resulting from app usage.",
          ),
          _termsSection(
            context,
            "6. Modifications",
            "We may update these terms periodically. Continued use of the app after changes implies acceptance of the revised terms.",
          ),
          _termsSection(
            context,
            "7. Contact",
            "For any questions regarding these terms, contact us at support@cuetbus.com.",
          ),

          const SizedBox(height: 28),

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

  // -------------------- REUSABLE TERMS SECTION -------------------- //
  Widget _termsSection(BuildContext context, String title, String content) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(
              theme.brightness == Brightness.dark ? 0.15 : 0.05,
            ),
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
            style: theme.textTheme.bodyMedium!.copyWith(
              color: theme.textTheme.bodyLarge!.color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: theme.textTheme.bodySmall!.copyWith(
              color: theme.textTheme.bodyMedium!.color!.withOpacity(0.85),
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}
