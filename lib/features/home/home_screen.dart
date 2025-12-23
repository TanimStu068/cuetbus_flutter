import 'dart:io';
import 'package:cuetbus/core/services/bus_schedule_service.dart';
import 'package:cuetbus/features/booking/seat_selection_screen.dart';
import 'package:cuetbus/features/lost_and_found/lost_and_found_screen.dart';
import 'package:cuetbus/features/safety_tips/safety_tips_screen.dart';
import 'package:cuetbus/features/service_updates/service_updates_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cuetbus/core/routing/app_routes.dart';
import 'package:hive/hive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  Map<String, dynamic>? nextBus;
  String countdown = "";
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> schedules = []; // all schedules
  List<Map<String, dynamic>> filteredSchedules = []; // filtered by search
  bool isSearching = false;

  String userName = "Tanim";

  // Dummy overview cards
  final List<Map<String, dynamic>> overviewCards = [
    {
      "title": "Service Updates",
      "icon": Icons.notifications_active_rounded,
      "color": Colors.purple,
    },

    {
      "title": "Lost & Found",
      "icon": Icons.search_rounded,
      "color": Colors.indigo,
    },
    {
      "title": "Safety Tips",
      "icon": Icons.shield_rounded,
      "color": Colors.redAccent,
    },
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _controller.forward();
    fetchNextBus();
    fetchSchedules();
    loadUserData();
  }

  void loadUserData() {
    final box = Hive.box('userBox');
    setState(() {
      userName = box.get('name') ?? "Guest";
    });
  }

  void fetchSchedules() async {
    final data = await BusScheduleService.getSchedules();
    print("Schedules: $data"); // <- Check this
    schedules = List<Map<String, dynamic>>.from(data);

    // Add dateTime field
    schedules = schedules.map((bus) {
      final parsedTime = parseTimeToToday(cleanTime(bus['time']));
      return {...bus, "dateTime": parsedTime};
    }).toList();

    filteredSchedules = List<Map<String, dynamic>>.from(schedules);
    setState(() {});
  }

  void fetchNextBus() async {
    final data = await BusScheduleService.getSchedules();

    final next = await getNextBus();

    if (next != null) {
      nextBus = next;
      countdown = getCountdown(nextBus!["dateTime"]);
    }
    setState(() {});
  }

  String getCountdown(DateTime busTime) {
    final now = DateTime.now();
    final diff = busTime.difference(now);

    if (diff.inMinutes <= 0) return "Departing now";

    if (diff.inMinutes < 60) {
      return "Departing in ${diff.inMinutes} min";
    }

    final hours = diff.inHours;
    final mins = diff.inMinutes % 60;
    return "Departing in ${hours}h ${mins}m";
  }

  String cleanTime(String time) {
    return time
        // Replace all Unicode space characters with normal space
        .replaceAll(RegExp(r'[\s\u00A0\u202F\u2007\u205F]+'), ' ')
        .trim();
  }

  DateTime? parseTimeToToday(String timeStr) {
    try {
      final now = DateTime.now();
      final parts = timeStr.trim().split(
        RegExp(r'[:\s]'),
      ); // splits 4:45 PM into ['4','45','PM']
      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);
      final isPM = parts.last.toLowerCase() == 'pm';
      if (isPM && hour != 12) hour += 12;
      if (!isPM && hour == 12) hour = 0;
      return DateTime(now.year, now.month, now.day, hour, minute);
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getNextBus() async {
    final schedules = await BusScheduleService.getSchedules();
    DateTime now = DateTime.now();

    // Determine if today is weekend
    bool isWeekend =
        now.weekday == DateTime.saturday || now.weekday == DateTime.sunday;

    // Filter schedules for today (weekday/weekend)
    List<Map<String, dynamic>> todaySchedules = schedules
        .where((bus) => bus["day_type"] == (isWeekend ? "weekend" : "weekday"))
        .map((e) => Map<String, dynamic>.from(e))
        .toList();

    // Convert times and find the next bus
    List<Map<String, dynamic>> upcomingBuses = [];
    for (var sch in todaySchedules) {
      DateTime? scheduleTime = parseTimeToToday(cleanTime(sch["time"]));
      if (scheduleTime != null) {
        sch["dateTime"] = scheduleTime;
        if (scheduleTime.isAfter(now)) {
          upcomingBuses.add(sch);
        }
      }
    }

    // Return the next upcoming bus if available
    if (upcomingBuses.isNotEmpty) {
      upcomingBuses.sort(
        (a, b) =>
            (a["dateTime"] as DateTime).compareTo(b["dateTime"] as DateTime),
      );
      var next = upcomingBuses.first;
      return {
        "busNo": next["busNo"],
        "route": next["route"],
        "dateTime": next["dateTime"],
      };
    }

    // If all buses have passed, return the first bus of today
    if (todaySchedules.isNotEmpty) {
      todaySchedules.sort(
        (a, b) =>
            (a["dateTime"] as DateTime).compareTo(b["dateTime"] as DateTime),
      );
      var first = todaySchedules.first;
      return {
        "busNo": first["busNo"],
        "route": first["route"],
        "dateTime": first["dateTime"],
      };
    }

    // No schedules at all
    return null;
  }

  // Add this method inside your State class:
  ImageProvider _getUserProfileImage() {
    final box = Hive.box('userBox');
    final path = box.get('profileImage');

    if (path != null && File(path).existsSync()) {
      return FileImage(File(path));
    } else {
      // fallback to default asset image
      return const AssetImage("assets/images/user.png");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('EEEE, dd MMM yyyy').format(DateTime.now());
    // String timeOnlyt = DateFormat('h:mm a').format(nextBus!['dateTime']);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // Inside your build method, where the avatar is:
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/profile');
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).cardColor,
                              image: DecorationImage(
                                image:
                                    _getUserProfileImage(), // <-- method to get image
                                fit: BoxFit.cover,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.shadow.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // GestureDetector(
                        //   onTap: () {
                        //     Navigator.pushNamed(context, '/profile');
                        //   },
                        //   child: Container(
                        //     height: 50,
                        //     width: 50,
                        //     decoration: BoxDecoration(
                        //       shape: BoxShape.circle,
                        //       color: Theme.of(context).cardColor,
                        //       image: const DecorationImage(
                        //         image: AssetImage("assets/images/user.png"),
                        //         fit: BoxFit.cover,
                        //       ),
                        //       boxShadow: [
                        //         BoxShadow(
                        //           color: Theme.of(
                        //             context,
                        //           ).colorScheme.shadow.withOpacity(0.1),
                        //           blurRadius: 8,
                        //           offset: const Offset(0, 4),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome back,",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              userName,
                              style: TextStyle(
                                fontSize: 15,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.notifications_none_rounded,
                            size: 30,
                            color: Theme.of(
                              context,
                            ).iconTheme.color, // dynamic color
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/notification');
                          },
                        ),
                        Positioned(
                          right: 8,
                          top: 10,
                          child: Container(
                            height: 10,
                            width: 10,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // STICKY DATE HEADER
                Text(
                  today,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    // color: Colors.grey[700],
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurfaceVariant, // dynamic subtle text
                  ),
                ),

                const SizedBox(height: 16),

                // SEARCH BAR
                TextField(
                  controller: searchController,
                  onChanged: (value) {
                    final query = value.toLowerCase().trim();
                    setState(() {
                      isSearching = query.isNotEmpty; // <-- track active search

                      if (query.isEmpty) {
                        filteredSchedules = [];
                      } else {
                        filteredSchedules = schedules.where((bus) {
                          final busNo = bus['busNo'].toString().toLowerCase();
                          final route = bus['route'].toString().toLowerCase();
                          return busNo.contains(query) || route.contains(query);
                        }).toList();
                      }
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Search buses or routes",
                    prefixIcon: Icon(
                      Icons.search,
                      color: Theme.of(
                        context,
                      ).colorScheme.primary, // dynamic primary color
                    ),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    hintStyle: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurfaceVariant, // dynamic hint text color
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                !isSearching
                    ? const SizedBox()
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredSchedules.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final bus = filteredSchedules[index];
                          return Container(
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).cardColor, // white background
                              borderRadius: BorderRadius.circular(
                                16,
                              ), // rounded corners
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).colorScheme.shadow
                                      .withOpacity(0.05), // subtle shadow
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ListTile(
                              leading: Icon(
                                Icons.directions_bus,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              title: Text(
                                bus['busNo'],
                                style: Theme.of(
                                  context,
                                ).textTheme.titleMedium, // dynamic title color
                              ),
                              subtitle: Text(
                                bus['route'],
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium, // dynamic subtitle color
                              ),
                              onTap: () {
                                // Navigate to seat selection or show details
                                if (bus['dateTime'] != null) {
                                  String timeOnly = DateFormat(
                                    'h:mm a',
                                  ).format(bus['dateTime']!);

                                  // Navigate to seat selection screen with bus details
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SeatSelectionScreen(
                                        busNo: bus['busNo'] ?? 'Unknown Bus',
                                        route: bus['route'] ?? 'Unknown Route',
                                        time: timeOnly.isNotEmpty
                                            ? timeOnly
                                            : 'Unknown Time',
                                      ),
                                    ),
                                  );

                                  // Navigator.pushNamed(
                                  //   context,
                                  //   AppRoutes.seatSelection,
                                  //   arguments: {
                                  //     "busNo": bus['busNo'],
                                  //     "time": timeOnly,
                                  //     "route": bus['route'],
                                  //   },
                                  // );
                                } else {
                                  // Optional: show a message if bus time is missing
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Bus time not available",
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface, // dynamic color
                                        ),
                                      ),
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .surface, // optional dynamic background
                                    ),
                                  );
                                }
                              },
                            ),
                          );
                        },
                      ),

                const SizedBox(height: 20),

                // NEXT BUS CARD (Animated)
                nextBus == null
                    ? const SizedBox()
                    : AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).primaryColor.withOpacity(0.95),
                              Theme.of(context).primaryColor.withOpacity(0.85),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(26),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(
                                context,
                              ).primaryColor.withOpacity(0.25),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Next Bus",
                              style: TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              nextBus!["busNo"],
                              style: TextStyle(
                                color: Colors.white,
                              ), // dynamic color
                              // style: .whiteTitle,
                            ),
                            Text(
                              nextBus!["route"],
                              style: TextStyle(color: Colors.white),
                              // dynamic color
                              // style: AppTextStyles.whiteTitle,
                            ),
                            const SizedBox(height: 18),
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  color: Colors.white, // dynamic color
                                  // color: Colors.white,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  countdown.isEmpty ? "Loading..." : countdown,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ), // dynamic color
                                  // style: AppTextStyles.whiteTitle,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Seat Availability",
                              style: TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: LinearProgressIndicator(
                                minHeight: 10,
                                value: 27 / 40,
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .surfaceVariant
                                    .withOpacity(0.3), // dynamic background
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary, // dynamic progress
                                // backgroundColor: Colors.white.withOpacity(0.3),
                                // color: Colors.greenAccent,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "27/40 seats available",
                              style: TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 18),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (nextBus != null) {
                                    // Declare and assign formattedDateTime here
                                    String timeOnly = DateFormat(
                                      'h:mm a',
                                    ).format(nextBus!['dateTime']);

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            SeatSelectionScreen(
                                              busNo:
                                                  nextBus?['busNo'] ??
                                                  'Unknown Bus',
                                              route:
                                                  nextBus?['route'] ??
                                                  'Unknown Route',
                                              time: timeOnly.isNotEmpty
                                                  ? timeOnly
                                                  : 'Unknown Time',
                                            ),
                                      ),
                                    );

                                    // Navigator.pushNamed(
                                    //   context,
                                    //   AppRoutes.seatSelection,
                                    //   arguments: {
                                    //     "busNo": nextBus!['busNo'],
                                    //     // "route": nextBus!['route'],
                                    //     "time": timeOnly,
                                    //     "route": nextBus!['route'],
                                    //   },
                                    // );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  // backgroundColor: Theme.of(
                                  //   context,
                                  // ).colorScheme.surface, // dynamic background
                                  foregroundColor: Theme.of(
                                    context,
                                  ).colorScheme.primary,
                                  // backgroundColor: Colors.white,
                                  // foregroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                ),
                                child: Text(
                                  "Reserve Now",
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary, // ensures text matches theme
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                const SizedBox(height: 27),

                // ===================== QUICK ACTION GRID =====================
                Text(
                  "Fast Access",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface, // dynamic color
                    // color: Colors.grey[900], // dark gray instead of pure black
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 18),

                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.1,
                  mainAxisSpacing: 18,
                  crossAxisSpacing: 18,
                  children: [
                    quickActionButton(
                      icon: Icons.event_seat,
                      label: "Reserve Seat",
                      onTap: () => Navigator.pushNamed(context, '/bus-list'),
                    ),
                    quickActionButton(
                      icon: Icons.calendar_month,
                      label: "Bus Schedule",
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.busSchedule),
                    ),
                    quickActionButton(
                      icon: Icons.history,
                      label: "My Bookings",
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.bookingList),
                    ),
                    quickActionButton(
                      icon: Icons.qr_code_2_rounded,
                      label: "Digital Pass",
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.digitalPass,
                          arguments: {
                            'busNumber': "Bus B12",
                            'route': "SMT → CUET",
                            'seat': "14A",
                            'date': "Sun, Jan 14",
                            'time': "8:30 AM",
                          },
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                Text(
                  "Today’s Highlights",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface, // dynamic color for light/dark mode
                    // color: Colors.grey[900], // dark gray instead of pure black
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 18),

                // HORIZONTAL SCROLLABLE OVERVIEW CARDS
                SizedBox(
                  height: 140,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: overviewCards.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      final card = overviewCards[index];
                      return GestureDetector(
                        onTap: () {
                          // Navigate
                          switch (card['title']) {
                            case "Service Updates":
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ServiceUpdatesScreen(),
                                ),
                              );
                              break;
                            case "Lost & Found":
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LostAndFoundScreen(),
                                ),
                              );
                              break;
                            case "Safety Tips":
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SafetyTipsScreen(),
                                ),
                              );
                              break;
                          }
                        },
                        child: Container(
                          width: 140,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(
                                  context,
                                ).colorScheme.shadow.withOpacity(0.08),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                card['icon'],
                                size: 36,
                                color: card['color'],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                card['title'],
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===================== QUICK ACTION WIDGET =====================
  Widget quickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {},
      child: AnimatedScale(
        scale: 1.0,
        duration: const Duration(milliseconds: 120),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.surfaceVariant, // dynamic light/dark mode color
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.shadow.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.primary.withOpacity(
                      0.15,
                    ), // dynamic background
                  ),
                  padding: const EdgeInsets.all(14),
                  child: Icon(
                    icon,
                    size: 32,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface, // dynamic color
                    // color: Colors.grey[900],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
