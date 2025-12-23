import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.bgColor,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        // backgroundColor: AppColors.primary,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,

        // foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
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
        centerTitle: true,
        title: Text(
          "About App",
          style: TextStyle(
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
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
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(0.85),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.shadow.withOpacity(0.08),
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
                    // color: Colors.white,
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.directions_bus_rounded,
                    size: 48,
                    // color: AppColors.primary,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "CUET Bus Seat Booking App",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Colors.white, // for text
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Version 1.0.0",
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    // color: Colors.white70,
                    color: Theme.of(context).textTheme.bodySmall!.color,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // ----------------- APP DESCRIPTION ----------------- //
          Text(
            "About",
            style: Theme.of(
              context,
            ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor, // for card backgrounds
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.shadow.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              "The CUET Bus Seat Booking App is a digital solution designed to "
              "make daily transportation easier for CUET students. It allows users "
              "to check available buses, select seats, manage bookings, access "
              "digital passes, and receive notifications about bus schedules in real time.\n\n"
              "Our mission is to improve campus mobility with a smooth, modern, "
              "and reliable transportation experience.",
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                height: 1.45,
                // color: Colors.black87,
                color: Theme.of(context).textTheme.bodySmall!.color,
              ),
            ),
          ),

          const SizedBox(height: 28),

          // ----------------- FEATURES ----------------- //
          Text(
            "Key Features",
            style: Theme.of(
              context,
            ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),

          featureTile(
            context,
            Icons.event_seat_rounded,
            "Seat Selection System",
          ),
          featureTile(
            context,
            Icons.directions_bus_filled_rounded,
            "Real-time Bus Information",
          ),
          featureTile(context, Icons.history_rounded, "Booking History"),
          featureTile(context, Icons.qr_code_rounded, "Digital Bus Pass"),
          featureTile(
            context,
            Icons.notifications_active_rounded,
            "Instant Alerts & Notifications",
          ),
          featureTile(context, Icons.support_agent_rounded, "Help & Support"),

          const SizedBox(height: 28),

          // ----------------- DEVELOPER SECTION ----------------- //
          Text(
            "Developed By",
            style: Theme.of(
              context,
            ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              // color: Colors.white,
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                devRow(context, "Designed & Developed By", "CUET CSE Students"),
                const Divider(),
                devRow(
                  context,
                  "Institution",
                  "Chittagong University of Engineering and Technology",
                ),
                const Divider(),
                devRow(context, "Contact Email", "support@cuetbus.com"),
              ],
            ),
          ),

          const SizedBox(height: 38),

          Center(
            child: Text(
              "© 2025 CUET Transport Service",
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context).textTheme.bodySmall!.color,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // --------------------------- Feature Tile --------------------------- //
  Widget featureTile(BuildContext context, IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        // color: Colors.white,
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 26, color: Theme.of(context).primaryColor),
          const SizedBox(width: 12),
          Text(title, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  // --------------------------- Developer Row --------------------------- //
  Widget devRow(BuildContext context, String title, String value) {
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
                ).textTheme.bodySmall!.color?.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
