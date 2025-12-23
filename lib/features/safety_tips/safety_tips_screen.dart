import 'package:flutter/material.dart';

class SafetyTipsScreen extends StatelessWidget {
  const SafetyTipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Safety Tips",
          style: TextStyle(
            color: Theme.of(context).appBarTheme.foregroundColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,

        // backgroundColor: const Color(0xFF2E8B57), // Your theme color
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Text(
              "Travel Safe. Stay Alert.",
              style: TextStyle(
                fontSize: 22,
                color: Theme.of(context).textTheme.bodyMedium!.color,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Your safety is our top priority. Please follow these essential tips while traveling on CUET buses.",
              style: TextStyle(
                color: Theme.of(
                  context,
                ).textTheme.bodyMedium!.color!.withOpacity(0.7),

                // color: Colors.grey.shade700,
                fontSize: 15,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 25),

            _tipCard(
              context: context,
              icon: Icons.shield_moon_rounded,
              title: "Follow Bus Rules",
              description:
                  "Always follow the instructions provided by the bus supervisor and drivers for a safe journey.",
            ),

            _tipCard(
              context: context,
              icon: Icons.directions_bus_filled_rounded,
              title: "Board Carefully",
              description:
                  "Wait until the bus fully stops before boarding or getting off. Avoid rushing.",
            ),

            _tipCard(
              context: context,
              icon: Icons.chair_alt_rounded,
              title: "Stay Seated",
              description:
                  "Remain seated while the bus is moving, especially on highways or uneven roads.",
            ),

            _tipCard(
              context: context,
              icon: Icons.lock_outline,
              title: "Secure Your Belongings",
              description:
                  "Keep your bags close, zip your pockets, and avoid displaying valuable items openly.",
            ),

            _tipCard(
              context: context,
              icon: Icons.report_gmailerrorred_rounded,
              title: "Report Suspicious Activity",
              description:
                  "If you notice anything unusual, inform the bus supervisor or report through the app immediately.",
            ),

            _tipCard(
              context: context,
              icon: Icons.health_and_safety_rounded,
              title: "Emergency Awareness",
              description:
                  "Know the location of emergency exits and keep the pathways clear at all times.",
            ),

            _tipCard(
              context: context,
              icon: Icons.phone_in_talk_rounded,
              title: "Stay Connected",
              description:
                  "Always keep your phone charged. In case of emergency, you can quickly call for help.",
            ),

            const SizedBox(height: 35),

            Text(
              "Emergency Contacts",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(
                  context,
                ).textTheme.titleMedium!.color, // dynamic color
              ),
              // style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),

            _contactRow(context, "CUET Bus Helpdesk", "+8801XXXXXXXXX"),
            _contactRow(context, "Transport Office", "+8803XXXXXXXXX"),
            _contactRow(context, "Emergency Hotline", "999"),

            const SizedBox(height: 35),

            Text(
              "Note",
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(
                  context,
                ).textTheme.titleSmall!.color, // dynamic color
              ),
              // style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              "Your safety is a shared responsibility. Stay mindful and help create a safe travel experience for everyone.",
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(
                  context,
                ).textTheme.bodyMedium!.color!.withOpacity(0.7),

                // color: Colors.grey.shade700,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // -----------------------------
  // Reusable Widgets
  // -----------------------------

  Widget _tipCard({
    required IconData icon,
    required String title,
    required String description,
    required BuildContext context,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,

        // color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withOpacity(0.05)
                : Colors.black.withOpacity(0.08),

            // color: Colors.black.withOpacity(.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primary.withOpacity(0.15), // dynamic background
              // color: const Color(0xFF2E8B57).withOpacity(.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Theme.of(
                context,
              ).colorScheme.primary, // dynamic icon color
              size: 26,
            ),
          ),
          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: Theme.of(
                      context,
                    ).textTheme.bodyMedium!.color!.withOpacity(0.7),

                    // color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _contactRow(BuildContext context, String title, String number) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(Icons.phone, color: Theme.of(context).primaryColor),
          const SizedBox(width: 10),
          Text("$title: ", style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(
            child: Text(
              number,
              style: TextStyle(
                color: Theme.of(
                  context,
                ).textTheme.bodyMedium!.color!.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
