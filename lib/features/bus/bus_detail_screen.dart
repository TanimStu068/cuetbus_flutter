import 'package:cuetbus/core/services/bus_schedule_service.dart';
import 'package:cuetbus/core/theme/theme.dart';
import 'package:cuetbus/features/booking/seat_selection_screen.dart';
import 'package:flutter/material.dart';

class BusDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> bus;
  const BusDetailsScreen({super.key, required this.bus});

  @override
  State<BusDetailsScreen> createState() => _BusDetailsScreenState();
}

class _BusDetailsScreenState extends State<BusDetailsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  List<dynamic> schedules = [];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _controller.forward();
    loadSchedules();
  }

  Future<void> loadSchedules() async {
    try {
      schedules = await BusScheduleService.getBusSchedules(widget.bus['busNo']);
      setState(() {}); // refresh UI after loading
    } catch (e) {
      print("Error loading schedules: $e");
    }
  }

  Map<String, dynamic>? getNextSchedule() {
    if (schedules.isEmpty) return null;

    final now = DateTime.now();
    final isWeekend =
        now.weekday == DateTime.saturday || now.weekday == DateTime.sunday;

    final filtered = schedules
        .where(
          (s) =>
              (isWeekend && s['day_type'] == 'weekend') ||
              (!isWeekend && s['day_type'] == 'weekday'),
        )
        .toList();

    List<Map<String, dynamic>> parsed = [];
    for (var item in filtered) {
      DateTime? dt = parseTimeToToday(item['time']);
      if (dt != null) {
        parsed.add({
          'datetime': dt,
          'time': item['time'],
          'route': item['route'],
          'type': item['type'],
        });
      }
    }

    if (parsed.isEmpty) return null;

    parsed.sort((a, b) => a['datetime'].compareTo(b['datetime']));

    return parsed.firstWhere(
      (s) => s['datetime'].isAfter(now),
      orElse: () => parsed.first,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // helper: parse "4:45 PM" to today DateTime
  DateTime? parseTimeToToday(String timeStr) {
    try {
      final now = DateTime.now();
      final format = TimeOfDay(
        hour:
            int.parse(timeStr.split(':')[0]) +
            (timeStr.toLowerCase().contains('pm') && !timeStr.startsWith('12')
                ? 12
                : 0),
        minute: int.parse(timeStr.split(':')[1].split(' ')[0]),
      );
      return DateTime(now.year, now.month, now.day, format.hour, format.minute);
    } catch (e) {
      return null;
    }
  }

  Color statusColor(BuildContext context, String status) {
    final colors = Theme.of(context).colorScheme;
    switch (status) {
      case "On Time":
        return colors.success;
      case "Delayed":
        return colors.warning;
      case "Full":
        return colors.danger;
      default:
        return colors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bus = widget.bus;
    final double percent = bus["available"] / bus["capacity"];

    final nextSchedule = getNextSchedule();

    // final trips = bus["trips"] ?? {};

    final amenities = bus["amenities"] is List ? bus["amenities"] : [];
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color(0xFF1B7743),
        foregroundColor: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: nextSchedule == null
            ? null
            : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SeatSelectionScreen(
                      busNo: widget.bus['busNo'] ?? 'Unknown Bus',
                      time: nextSchedule['time'] ?? 'Unknown Time',
                      route: nextSchedule['route'] ?? 'Unknown Route',
                    ),
                  ),
                );
              },
        label: const Text(
          "Reserve Seat",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        icon: Icon(Icons.event_seat, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: FadeTransition(
        opacity: _fade,
        child: CustomScrollView(
          slivers: [
            // ============================ HEADER ============================
            SliverAppBar(
              pinned: true,
              expandedHeight: 220,
              backgroundColor: theme.scaffoldBackgroundColor,
              foregroundColor: theme.textTheme.bodyLarge?.color,
              elevation: 0.6,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white, // dynamic
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary.withOpacity(0.95),
                        Theme.of(context).colorScheme.primary.withOpacity(0.75),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -20,
                        top: 40,
                        child: Opacity(
                          opacity: 0.15,
                          child: Icon(
                            Icons.directions_bus_filled_rounded,
                            size: 160,
                            color: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.color?.withOpacity(0.1),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        bottom: 30,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bus["busNo"],
                              style: theme.textTheme.titleMedium!.copyWith(
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            SizedBox(
                              width:
                                  MediaQuery.of(context).size.width -
                                  40, // explicitly define width

                              child: Text(
                                bus["route"],
                                style: theme.textTheme.bodyMedium!.copyWith(
                                  fontSize: 16,
                                  color: Colors
                                      .white, // ensures color adapts to light/dark
                                ),
                                maxLines: 3,
                                overflow: TextOverflow
                                    .ellipsis, // show "..." if still too long
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ===================== STATUS BADGE =====================
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: statusColor(
                              context,
                              bus["status"],
                            ).withOpacity(0.15),
                          ),
                          child: Text(
                            bus["status"],
                            style: TextStyle(
                              color: statusColor(context, bus["status"]),
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ===================== NEXT DEPARTURE =====================
                    Text(
                      "Next Departure",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_filled_rounded,
                          color: Theme.of(context).iconTheme.color,
                          // color: Colors.black,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          nextSchedule != null
                              ? nextSchedule['time'] ?? ""
                              : "N/A",

                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium!.copyWith(fontSize: 16),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),
                    Divider(color: Theme.of(context).dividerColor),

                    const SizedBox(height: 14),

                    // ===================== SEAT AVAILABILITY =====================
                    Text(
                      "Seat Availability",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 10),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: percent,
                        minHeight: 14,
                        backgroundColor: Theme.of(
                          context,
                        ).dividerColor.withOpacity(0.2), // dynamic background
                        color: percent > 0.6
                            ? Theme.of(context).colorScheme.success
                            : percent > 0.3
                            ? Theme.of(context).colorScheme.warning
                            : Theme.of(context).colorScheme.danger,
                      ),
                    ),

                    const SizedBox(height: 6),
                    Text(
                      "${bus["available"]}/${bus["capacity"]} seats available",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ===================== BUS INFORMATION CARD =====================
                    Container(
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.shadow.withOpacity(0.05),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Bus Information",
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 14),

                          infoRow(
                            "Route",
                            nextSchedule != null
                                ? nextSchedule['route'] ?? ""
                                : "N/A",
                          ),
                          infoRow(
                            "Departure Time",
                            nextSchedule != null
                                ? nextSchedule['time'] ?? ""
                                : "N/A",
                          ),
                          infoRow("Bus Number", bus["busNo"]),
                          infoRow("Capacity", "${bus["capacity"]} seats"),

                          const SizedBox(height: 14),
                          Divider(color: Theme.of(context).dividerColor),

                          // Divider(color: Colors.grey.shade300),
                          const SizedBox(height: 14),

                          Text(
                            "Driver Details",
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 12),

                          Row(
                            children: [
                              CircleAvatar(
                                radius: 26,
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.surfaceVariant, // adapts to theme
                                // backgroundColor: Colors.grey.shade300,
                                backgroundImage: const AssetImage(
                                  "assets/images/driver.png",
                                ),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    bus["driver_name"] ?? "N/A",
                                    style: theme.textTheme.bodyMedium!.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.phone,
                                        size: 22,
                                        color: Theme.of(
                                          context,
                                        ).iconTheme.color, // dynamic color
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        bus["driver_phone"] ?? "N/A",
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary, // dynamic color
                                        size: 18,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "4.8",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ===================== AMENITIES =====================
                    Text("Amenities", style: theme.textTheme.titleMedium),
                    const SizedBox(height: 14),

                    Wrap(
                      spacing: 17,
                      runSpacing: 14,
                      children: amenities.map<Widget>((a) {
                        IconData icon;
                        switch (a.toString().toLowerCase()) {
                          case 'wifi':
                            icon = Icons.wifi;
                            break;
                          case 'ac':
                            icon = Icons.ac_unit;
                            break;
                          case 'charging':
                            icon = Icons.charging_station;
                            break;
                          case 'comfort':
                            icon = Icons.airline_seat_recline_normal;
                            break;
                          default:
                            icon = Icons.check_circle_outline;
                        }
                        return amenity(icon, a.toString());
                      }).toList(),
                    ),

                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget amenity(IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) => Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium!.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 12),
                Text(
                  _amenityDescription(label),
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 28,
              color: Theme.of(
                context,
              ).iconTheme.color, // dynamic color based on theme
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall, // also dynamic
          ),
        ],
      ),
    );
  }

  Widget scheduleTile(String time) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Center(
        child: Text(
          time,
          style: theme.textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  String _amenityDescription(String label) {
    switch (label.toLowerCase()) {
      case 'wifi':
        return 'Free Wi-Fi is available on this bus.';
      case 'ac':
        return 'Air-conditioned for a comfortable ride.';
      case 'charging':
        return 'Charging ports are available for your devices.';
      case 'comfort':
        return 'Extra comfortable seating for long trips.';
      default:
        return 'This amenity is available on the bus.';
    }
  }
}
