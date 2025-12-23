import 'package:cuetbus/core/routing/app_routes.dart';
import 'package:cuetbus/data/models/booking_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class SeatSelectionScreen extends StatefulWidget {
  final String busNo;
  final String time;
  final String route;

  const SeatSelectionScreen({
    super.key,
    required this.busNo,
    required this.time,
    required this.route,
  });

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  List<int> selectedSeats = [];
  List<int> bookedSeats = [];

  bool isSelected(int s) => selectedSeats.contains(s);
  bool isBooked(int s) => bookedSeats.contains(s);

  // void selectSeat(int seat) {
  //   if (isBooked(seat)) return;
  //   setState(() {
  //     if (isSelected(seat)) {
  //       selectedSeats.remove(seat);
  //     } else {
  //       selectedSeats.add(seat);
  //     }
  //   });
  // }

  void selectSeat(int seat) {
    if (isBooked(seat)) return;

    setState(() {
      selectedSeats.clear(); // <-- remove any previously selected seat
      selectedSeats.add(seat); // <-- add the new seat
    });
  }

  @override
  void initState() {
    super.initState();
    loadBookedSeats();
  }

  void loadBookedSeats() {
    final box = Hive.box<Booking>('bookings');

    bookedSeats.clear();

    for (var b in box.values) {
      if (b.busNo == widget.busNo &&
          b.route == widget.route &&
          b.tripTime.trim().toLowerCase() == widget.time.trim().toLowerCase()) {
        bookedSeats.addAll(b.seats);
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final today = DateFormat('EEEE, dd MMM yyyy').format(DateTime.now());

    final screenWidth = MediaQuery.of(context).size.width;
    final parentPadding = 18 * 2; // left + right padding from parent Padding
    final gap = 3.0;
    final aisle = 18.0;
    final totalGaps = gap * 4 + aisle;
    final seatSize = (screenWidth - parentPadding - totalGaps) / 5 * 0.90;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Select Seat",
          style: TextStyle(color: theme.appBarTheme.foregroundColor),
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
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
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            // Text(
            //   widget.time,
            //   style: TextStyle(fontSize: 30, color: Colors.black),
            // ),

            // Header Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.shadow.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.8),
                            Theme.of(context).colorScheme.primary,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.directions_bus_filled_rounded,
                        color: Theme.of(context).colorScheme.onPrimary,
                        // color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.busNo,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(
                                  context,
                                ).textTheme.titleMedium?.color,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.place,
                              size: 14,
                              color: Theme.of(
                                context,
                              ).iconTheme.color?.withOpacity(0.6),
                              // color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.route,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color
                                        ?.withOpacity(0.7),
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: Theme.of(
                                context,
                              ).iconTheme.color?.withOpacity(0.6),
                              // color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.time,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color
                                        ?.withOpacity(0.6),
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            // Legends
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  legendItem(
                    Theme.of(context).disabledColor.withOpacity(0.6),
                    "Booked",
                  ),
                  legendItem(Theme.of(context).colorScheme.primary, "Selected"),
                  legendItem(
                    Theme.of(context).disabledColor.withOpacity(0.2),
                    "Available",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Bus Seats Layout
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.shadow.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Driver
                    Container(
                      width: double.infinity,
                      height: 36,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.error, // dynamic red
                        // color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(
                              context,
                            ).colorScheme.error.withOpacity(0.3),

                            // color: Colors.redAccent.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        "Driver",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onError, // dynamic text color
                          // color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // Seats grid using Wrap
                    const SizedBox(height: 12),
                    Column(
                      children: List.generate(6, (rowIndex) {
                        // Left side: 2 seats
                        int left1 = rowIndex * 5 + 1;
                        int left2 = rowIndex * 5 + 2;

                        // Right side: 3 seats
                        int right1 = rowIndex * 5 + 3;
                        int right2 = rowIndex * 5 + 4;
                        int right3 = rowIndex * 5 + 5;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              seatBox(left1, seatSize),
                              SizedBox(width: gap),
                              seatBox(left2, seatSize),

                              SizedBox(width: aisle), // aisle

                              seatBox(right1, seatSize),
                              SizedBox(width: gap),

                              seatBox(right2, seatSize),
                              SizedBox(width: gap),

                              seatBox(right3, seatSize),
                            ],
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            // Footer with total & button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).colorScheme.shadow.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${selectedSeats.length} seats selected",
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.color,
                              ),
                        ),
                      ],
                    ),

                    const Spacer(),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: selectedSeats.isEmpty
                            ? null
                            : () async {
                                // 1. Create a booking record
                                final booking = Booking(
                                  busNo: widget.busNo,
                                  route: widget.route,
                                  tripTime: widget
                                      .time, // you can adjust if you have morning/noon/evening
                                  seats: selectedSeats,
                                  bookingDate: DateTime.now(),
                                );

                                // 2. Save booking to Hive
                                var box = Hive.box<Booking>('bookings');
                                await box.add(booking);
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.bookingList,
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary, // adapt to theme
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.onPrimary, // text/icon color
                          // backgroundColor: Colors.green,
                        ),
                        child: Text(
                          "Continue",
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Seat Box Widget with scale animation
  Widget seatBox(int seat, double size) {
    bool booked = isBooked(seat);
    bool selected = isSelected(seat);
    final theme = Theme.of(context);

    Color seatColor = theme.colorScheme.surface; // available
    if (booked)
      seatColor = theme.colorScheme.onSurface.withOpacity(0.3); // booked
    if (selected) seatColor = theme.colorScheme.primary; // selected

    return GestureDetector(
      onTap: () => selectSeat(seat),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: size,
        height: size,
        transform: Matrix4.identity()..scale(selected ? 1.05 : 1.0),
        decoration: BoxDecoration(
          color: seatColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? theme.colorScheme.primary : theme.dividerColor,
            width: selected ? 2 : 1,
          ),
          boxShadow: [
            if (selected)
              theme.shadowColor.withOpacity(0.2) != null
                  ? BoxShadow(
                      color: theme.colorScheme.primary.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    )
                  : const BoxShadow(),
          ],
        ),
        child: Center(
          child: Text(
            "$seat",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: booked
                  ? theme.colorScheme.onSurface.withOpacity(0.5)
                  : selected
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // Legend Widget
  Widget legendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Theme.of(context).dividerColor),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(
              context,
            ).textTheme.bodySmall?.color?.withOpacity(0.7),
          ),
          // style: AppTextStyles.bodySmall.copyWith(color: Colors.grey.shade700),
        ),
      ],
    );
  }
}
