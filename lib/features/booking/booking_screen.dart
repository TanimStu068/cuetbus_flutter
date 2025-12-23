import 'package:cuetbus/core/routing/app_routes.dart';
import 'package:cuetbus/data/models/booking_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<Booking>> _bookingsFuture;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _bookingsFuture = Future.value(
      Hive.box<Booking>('bookings').values.toList()
        ..sort((a, b) => a.bookingDate.compareTo(b.bookingDate)),
    );

    super.initState();
  }

  Future<void> _cancelBooking(Booking booking) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cancel Booking?"),
        content: const Text("Are you sure you want to cancel this trip?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("No"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Yes, Cancel"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    // DELETE FROM HIVE
    await booking.delete();

    // REFRESH UI
    setState(() {
      _bookingsFuture = Future.value(
        Hive.box<Booking>('bookings').values.toList()
          ..sort((a, b) => a.bookingDate.compareTo(b.bookingDate)),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Booking cancelled successfully")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
          onPressed: () {
            Navigator.pop(context); // goes back to previous screen
          },
        ),
        title: Text(
          "My Bookings",
          style: TextStyle(
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Booking>>(
        future: _bookingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No bookings found'));
          }

          final bookings = snapshot.data!;
          final upcomingBookings = bookings.where((b) => b.isUpcoming).toList();
          final pastBookings = bookings.where((b) => !b.isUpcoming).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              if (upcomingBookings.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _upcomingBookingCard(
                    upcomingBookings.reduce(
                      (a, b) => a.bookingDate.isBefore(b.bookingDate) ? a : b,
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: Theme.of(context).primaryColor,
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .color!
                      .withOpacity(0.6), // dynamic wi,
                  labelStyle: Theme.of(
                    context,
                  ).textTheme.bodyMedium, // dynamic,
                  tabs: [
                    Tab(
                      child: Text(
                        "Upcoming",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Past",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _bookingsList(upcomingBookings, isUpcoming: true),
                    _bookingsList(pastBookings, isUpcoming: false),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// -----------------------------------------------------------
  /// 🟢 FEATURE 1: NEXT UPCOMING BOOKING CARD (Premium UI)
  /// -----------------------------------------------------------
  Widget _upcomingBookingCard(Booking booking) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.95),
            Theme.of(context).colorScheme.primary.withOpacity(0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Your Next Ride",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "${booking.busNo} — ${booking.route}",
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                Icons.access_time,
                color: Theme.of(context).appBarTheme.foregroundColor,
                size: 20,
              ),
              const SizedBox(width: 6),
              Text(
                booking.tripTime,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                Icons.event_seat,
                color: Theme.of(context).appBarTheme.foregroundColor,
                size: 20,
              ),
              const SizedBox(width: 6),
              Text(
                booking.seats.join(', '),
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bookingsList(List<Booking> bookings, {required bool isUpcoming}) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return _bookingTile(
          booking: booking,

          // bus: booking.busNo,
          // route: booking.route,
          // time: booking.tripTime,
          // seat: booking.seats.join(', '),
          // date: booking.bookingDate.toString().split(' ')[0],
          // isUpcoming: booking.isUpcoming,
        );
      },
    );
  }

  /// -----------------------------------------------------------
  /// 🔶 COMPONENT: BOOKING TILE
  /// -----------------------------------------------------------
  Widget _bookingTile({required Booking booking}) {
    final bus = booking.busNo;
    final route = booking.route;
    final time = booking.tripTime;
    final seat = booking.seats.join(', ');
    final date = DateFormat('yyyy-MM-dd').format(booking.bookingDate);

    // final date = booking.bookingDate.toString().split(' ')[0];
    final isUpcoming = booking.isUpcoming;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.bookingDetails,
          arguments: {
            'busName': bus,
            'route': route,
            'time': time,
            'seat': seat,
            'date': date,
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  bus,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: isUpcoming
                        ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                        : Theme.of(context).disabledColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    isUpcoming ? "Upcoming" : "Completed",
                    style: TextStyle(
                      color: isUpcoming
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).textTheme.bodyMedium!.color,
                      // color: isUpcoming ? AppColors.primary : Colors.grey[700],
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),
            Text(route, style: Theme.of(context).textTheme.bodyMedium),

            const SizedBox(height: 10),

            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 18,
                  color: Theme.of(context).iconTheme.color?.withOpacity(0.7),
                ),
                const SizedBox(width: 6),
                Text(time, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(width: 15),
                Icon(
                  Icons.event_seat,
                  size: 18,
                  color: Theme.of(context).iconTheme.color?.withOpacity(0.7),
                ),
                const SizedBox(width: 6),
                Text(seat, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),

            const SizedBox(height: 10),
            Text("Date: $date", style: Theme.of(context).textTheme.bodySmall),

            if (isUpcoming) ...[
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: _actionBtn("View Details", Icons.remove_red_eye, () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.bookingDetails,
                        arguments: {
                          'busName': bus,
                          'route': route,
                          'time': time,
                          'seat': seat,
                          'date': date,
                        },
                      );
                    }, isPrimary: true),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _actionBtn(
                      "Cancel",
                      Icons.close,
                      () => _cancelBooking(booking),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _actionBtn(
    String title,
    IconData icon,
    VoidCallback onTap, {
    bool isPrimary = false,
  }) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isPrimary
                ? theme.colorScheme.primary.withOpacity(0.5)
                : theme.colorScheme.primary.withOpacity(0.5),
          ),
          borderRadius: BorderRadius.circular(10),
          gradient: isPrimary
              ? LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withOpacity(0.95),
                    theme.colorScheme.primary.withOpacity(0.85),
                  ],
                )
              : null,
          color: isPrimary ? null : theme.cardColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isPrimary
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.primary,
              // color: isPrimary ? Colors.white : AppColors.primary,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: theme.textTheme.bodyMedium!.copyWith(
                color: isPrimary
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
