import 'package:flutter/material.dart';
import 'package:cuetbus/core/routing/app_routes.dart';
import 'package:share_plus/share_plus.dart';

class BookingConfirmationScreen extends StatefulWidget {
  final String busName;
  final String route;
  final String date;
  final String time;
  final String selectedSeats;

  const BookingConfirmationScreen({
    super.key,
    required this.busName,
    required this.route,
    required this.date,
    required this.time,
    required this.selectedSeats,
  });

  @override
  State<BookingConfirmationScreen> createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Booking Confirmation",
          style: TextStyle(
            color: Theme.of(context).appBarTheme.foregroundColor,
            fontWeight: FontWeight.bold,
          ),
        ),
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
        // backgroundColor: AppColors.primary,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.92,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.shadow,
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor.withOpacity(0.95),
                            Theme.of(context).primaryColor.withOpacity(0.85),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(22),
                          topRight: Radius.circular(22),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            "Trip Summary",
                            style: theme.textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onPrimary,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "Free for Students",
                              style: TextStyle(
                                color: theme.colorScheme.onSurface.withOpacity(
                                  0.9,
                                ),

                                // color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          LayoutBuilder(
                            builder: (context, constraints) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: List.generate(
                                  (constraints.maxWidth / 12).floor(),
                                  (index) => Container(
                                    width: 5,
                                    height: 2,
                                    color: theme.brightness == Brightness.dark
                                        ? Colors.white38
                                        : Colors.grey.shade400,
                                  ),
                                ),
                              );
                            },
                          ),
                          Positioned(
                            left: -12,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).scaffoldBackgroundColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Positioned(
                            right: -12,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).scaffoldBackgroundColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(22),
                          bottomRight: Radius.circular(22),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _summaryRow(
                            Icons.directions_bus,
                            "Bus",
                            widget.busName,
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).textTheme.bodyLarge?.color ??
                                Colors.black,
                          ),
                          _summaryRow(
                            Icons.route,
                            "Route",
                            widget.route,
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).textTheme.bodyLarge?.color ??
                                Colors.black,
                          ),
                          _summaryRow(
                            Icons.calendar_today,
                            "Date",
                            widget.date,
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).textTheme.bodyLarge?.color ??
                                Colors.black,
                          ),
                          _summaryRow(
                            Icons.access_time,
                            "Time",
                            widget.time,
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).textTheme.bodyLarge?.color ??
                                Colors.black,
                          ),
                          _summaryRow(
                            Icons.event_seat,
                            "Seats",
                            widget.selectedSeats,
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).textTheme.bodyLarge?.color ??
                                Colors.black,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Please arrive at the bus stop 5 minutes early.",
                            style: theme.textTheme.bodyMedium!.copyWith(
                              color:
                                  Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.color ??
                                  Colors.black54,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 35),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(
                  Icons.share,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                label: Text(
                  "Share Booking Pass",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  Share.share(
                    "Bus: ${widget.busName}\nRoute: ${widget.route}\nDate: ${widget.date}\nSeats: ${widget.selectedSeats}",
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.mainNavBar,
                    (route) => false,
                  );
                },
                child: Text(
                  "Done",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary, // dynamic
                    // color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(
    IconData icon,
    String label,
    String value,
    Color iconColor,
    Color textColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 22, color: iconColor),
          const SizedBox(width: 12),
          Text(
            "$label: ",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.copyWith(color: textColor, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
