import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Help & Support",
          style: TextStyle(
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          // --------------------- Header --------------------- //
          Text(
            "How can we help you?",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            "Find answers, contact support, or report a problem.",
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white70
                  : Colors.black54,
            ),
          ),
          const SizedBox(height: 20),

          // --------------------- Support Categories --------------------- //
          Text(
            "Support Categories",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 14),

          supportCategoryCard(
            context: context,
            title: "General Questions",
            icon: Icons.help_center_rounded,
            onTap: () {},
          ),
          supportCategoryCard(
            context: context,
            title: "Booking Issues",
            icon: Icons.event_seat_rounded,
            onTap: () {},
          ),
          supportCategoryCard(
            context: context,
            title: "Payment & Refunds",
            icon: Icons.payment_rounded,
            onTap: () {},
          ),
          supportCategoryCard(
            context: context,
            title: "Bus / Schedule Problems",
            icon: Icons.directions_bus_rounded,
            onTap: () {},
          ),

          const SizedBox(height: 28),

          // --------------------- FAQ Section --------------------- //
          Text(
            "Frequently Asked Questions",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 14),

          faqTile(
            context: context,
            question: "How do I book a seat?",
            answer:
                "Select your bus → open seat map → choose seat → confirm booking.",
          ),
          faqTile(
            context: context,
            question: "How can I cancel my booking?",
            answer:
                "Go to 'My Bookings' → select your trip → press cancel button.",
          ),
          faqTile(
            context: context,
            question: "Why is my bus not showing?",
            answer:
                "Check your internet connection or refresh the schedule screen.",
          ),

          const SizedBox(height: 30),

          // --------------------- Contact Cards --------------------- //
          Text("Contact Us", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 14),

          contactCard(
            context: context,
            icon: Icons.mail_rounded,
            title: "Email Support",
            subtitle: "support@cuetbus.com",
            onTap: () {},
          ),
          contactCard(
            context: context,
            icon: Icons.phone_rounded,
            title: "Phone Support",
            subtitle: "+880 1700 000000",
            onTap: () {},
          ),

          const SizedBox(height: 30),

          // --------------------- Report a Problem --------------------- //
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: () {},
            child: Text(
              "Report a Problem",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // --------------------- Live Chat --------------------- //
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              side: BorderSide(
                color: Theme.of(
                  context,
                ).colorScheme.primary, // <- DYNAMIC BORDER
                width: 1.5,
              ),
            ),
            onPressed: () {},
            child: Text(
              "Live Chat with Support",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------- //
  // SUPPORT CATEGORY CARD
  Widget supportCategoryCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: Theme.of(context).primaryColor, size: 26),
        ),
        title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
      ),
    );
  }

  // ---------------------------------------------------------------------- //
  // FAQ TILE
  Widget faqTile({
    required BuildContext context,
    required String question,
    required String answer,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        collapsedIconColor: Theme.of(context).primaryColor,
        iconColor: Theme.of(context).primaryColor,
        title: Text(question, style: Theme.of(context).textTheme.bodyMedium),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              answer,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------- //
  // CONTACT CARD
  Widget contactCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
        ),
        title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
      ),
    );
  }
}
