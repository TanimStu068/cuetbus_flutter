import 'package:cuetbus/core/routing/app_routes.dart';
import 'package:cuetbus/data/models/booking_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

class BookingDetailsScreen extends StatefulWidget {
  final String busName;
  final String route;
  final String time;
  final String seat;
  final String date;

  const BookingDetailsScreen({
    super.key,
    required this.busName,
    required this.route,
    required this.time,
    required this.seat,
    required this.date,
  });

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late List<String> stops = [];

  @override
  void initState() {
    super.initState();

    final routeText = widget.route;

    stops = routeText
        .split(RegExp(r"→|->|—|–|-|>"))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    if (stops.length < 2) {
      stops = ["Start", "Destination"];
    }
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _controller.forward();
  }

  Future<void> _cancelBooking() async {
    // Open the Hive box
    final box = Hive.box<Booking>('bookings');

    // Find the booking object in Hive that matches the current screen
    final bookingToDelete = box.values.cast<Booking?>().firstWhere(
      (booking) =>
          booking!.busNo == widget.busName &&
          booking.route == widget.route &&
          booking.tripTime == widget.time &&
          booking.seats.join(', ') == widget.seat &&
          DateFormat('yyyy-MM-dd').format(booking.bookingDate) ==
              DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.date)),
      orElse: () => null,
    );

    if (bookingToDelete == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Booking not found")));
      return;
    }

    // Show confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cancel Booking"),
        content: const Text("Are you sure you want to cancel this ride?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("No"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Yes, Cancel"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    // Delete the booking
    await bookingToDelete.delete();

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Booking cancelled successfully")),
    );

    // Navigate back to previous screen
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.bgColor,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        // backgroundColor: AppColors.primary,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,

        title: Text(
          "Booking Details",
          style: TextStyle(
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
        ),
        centerTitle: true,
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

      body: FadeTransition(
        opacity: _fade,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _topInfoCard(),
              const SizedBox(height: 20),
              _routeTimelineCard(),
              const SizedBox(height: 20),
              _driverBusInfoCard(),
              const SizedBox(height: 20),
              _mapPreviewCard(),
              const SizedBox(height: 30),
              _actionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------------------
  // 🟩 TOP INFO CARD
  // -------------------------------
  Widget _topInfoCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.95),
            Theme.of(context).colorScheme.primary.withOpacity(0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.25),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.busName,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.route,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Icon(
                Icons.access_time,
                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
                size: 20,
              ),
              const SizedBox(width: 6),
              Text(
                widget.time,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Icon(
                Icons.event_seat,
                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
                size: 20,
              ),
              const SizedBox(width: 6),
              Text(
                "Seat ${widget.seat}",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Icon(
                Icons.calendar_month,
                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
                size: 20,
              ),
              const SizedBox(width: 6),
              Text(
                widget.date,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // -------------------------------
  // 🟦 ROUTE TIMELINE CARD
  Widget _routeTimelineCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,

        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Route Details", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TIMELINE SIDE
              Column(
                children: List.generate(stops.length, (index) {
                  final isFirst = index == 0;
                  final isLast = index == stops.length - 1;

                  return Column(
                    children: [
                      _timelineDot(isFirst),
                      if (!isLast) _timelineLine(),
                    ],
                  );
                }),
              ),

              const SizedBox(width: 14),

              // STOP NAMES SIDE
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(stops.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stops[index],
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        if (index == 0)
                          Text(
                            "Starting Point",
                            style: Theme.of(context).textTheme.labelSmall!
                                .copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .color, // or any dynamic color
                                ),
                          ),

                        // Text("Starting Point", style: Theme.of(context).textTheme.caption),
                        if (index == stops.length - 1)
                          Text(
                            "Destination",
                            style: Theme.of(context).textTheme.labelSmall!
                                .copyWith(
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium!.color,
                                ),
                          ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _timelineDot(bool filled) {
    return Container(
      height: 18,
      width: 18,
      decoration: BoxDecoration(
        color: filled
            ? Theme.of(context).primaryColor
            : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).primaryColor, width: 2),
      ),
    );
  }

  Widget _timelineLine() {
    return Container(
      height: 40,
      width: 3,
      color: Theme.of(context).primaryColor.withOpacity(0.4),
    );
  }

  // -------------------------------
  // 🟧 BUS + DRIVER INFO
  // -------------------------------
  Widget _driverBusInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Bus image
          // Container(
          //   height: 70,
          //   width: 90,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(14),
          //     image: const DecorationImage(
          //       image: AssetImage("assets/images/bus.png"),
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
          Icon(
            Icons.directions_bus,
            size: 50,
            color: Theme.of(context).primaryColor,
          ),

          const SizedBox(width: 16),

          // Driver & Bus info with icons
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: 18,
                      color: Theme.of(
                        context,
                      ).iconTheme.color?.withOpacity(0.7),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Driver: Abdul Karim",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.people_alt,
                      size: 18,
                      color: Theme.of(
                        context,
                      ).iconTheme.color?.withOpacity(0.7),

                      // color: Colors.black54,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Assistant: Farhad",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.directions_bus,
                      size: 18,
                      color: Theme.of(context).primaryColor,

                      // color: Colors.black54,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      widget.busName,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.confirmation_number,
                      size: 18,
                      color: Theme.of(
                        context,
                      ).iconTheme.color?.withOpacity(0.7), // dynamic color
                      // color: Colors.black54,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Registration: CTG-4567",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------
  // 🟪 MAP PREVIEW CARD
  // -------------------------------

  Widget _mapPreviewCard() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        image: const DecorationImage(
          image: AssetImage(
            "assets/images/map_image.png",
          ), // Your placeholder image
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow,
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
    );
  }

  // -------------------------------
  // 🟥 ACTION BUTTONS
  // -------------------------------
  Widget _actionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: Icon(
              Icons.qr_code,
              color: Theme.of(context).colorScheme.onPrimary, // dynamic
            ),
            label: Text(
              "Digital Pass",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary, // dynamic
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.digitalPass,
                arguments: {
                  'busNumber': widget.busName,
                  'route': widget.route,
                  'seat': widget.seat,
                  'date': widget.date,
                  'time': widget.time,
                },
              );
            },
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: ElevatedButton.icon(
            icon: Icon(
              Icons.cancel_outlined,
              color: Theme.of(context).colorScheme.error, // dynamic
            ),
            label: Text(
              "Cancel Ride",
              style: TextStyle(
                color: Theme.of(context).colorScheme.error, // dynamic
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).brightness == Brightness.light
                  ? Colors.white
                  : Theme.of(
                      context,
                    ).cardColor, // dynamic background for dark mode
              foregroundColor: Theme.of(
                context,
              ).colorScheme.error, // dynamic text/icon c
              // backgroundColor: Colors.white,
              // foregroundColor: Colors.red,
              side: BorderSide(color: Theme.of(context).colorScheme.error),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: _cancelBooking,
          ),
        ),
      ],
    );
  }
}
