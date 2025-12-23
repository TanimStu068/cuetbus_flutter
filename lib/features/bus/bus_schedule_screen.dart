import 'package:cuetbus/core/services/bus_schedule_service.dart';
import 'package:cuetbus/core/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

class BusScheduleScreen extends StatefulWidget {
  const BusScheduleScreen({super.key});

  @override
  State<BusScheduleScreen> createState() => _BusScheduleScreenState();
}

class _BusScheduleScreenState extends State<BusScheduleScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late String formattedDate;

  List<Map<String, dynamic>> weekdaySchedule = [];
  List<Map<String, dynamic>> weekendSchedule = [];

  List<Map<String, dynamic>> filteredWeekdaySchedule = [];
  List<Map<String, dynamic>> filteredWeekendSchedule = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    formattedDate = DateFormat('EEEE, d MMM yyyy').format(DateTime.now());

    // Request permission
    NotificationService.requestPermission();

    fetchSchedules();
  }

  void fetchSchedules() async {
    try {
      final data = await BusScheduleService.getSchedules();
      final buses = data;

      List<Map<String, dynamic>> weekdays = [];
      List<Map<String, dynamic>> weekends = [];

      for (var item in buses) {
        final busNo = item["busNo"] ?? "Unknown";
        final dayType = item["day_type"] ?? "";

        final scheduleItem = {
          "bus": busNo,
          "time": item["time"] ?? "",
          "route": item["route"] ?? "",
          "type": item["type"] ?? "",
        };

        if (dayType == "weekday") {
          weekdays.add(scheduleItem);
        } else if (dayType == "weekend") {
          weekends.add(scheduleItem);
        }
      }

      setState(() {
        weekdaySchedule = weekdays;
        weekendSchedule = weekends;
        filteredWeekdaySchedule = List.from(weekdays);
        filteredWeekendSchedule = List.from(weekends);
        isLoading = false;
      });

      print("Weekday schedule: $weekdaySchedule");
      print("Weekend schedule: $weekendSchedule");
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterSchedules(String query) {
    query = query.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        filteredWeekdaySchedule = List.from(weekdaySchedule);
        filteredWeekendSchedule = List.from(weekendSchedule);
      } else {
        filteredWeekdaySchedule = weekdaySchedule.where((item) {
          final bus = item['bus'].toString().toLowerCase();
          final route = item['route'].toString().toLowerCase();
          return bus.contains(query) || route.contains(query);
        }).toList();

        filteredWeekendSchedule = weekendSchedule.where((item) {
          final bus = item['bus'].toString().toLowerCase();
          final route = item['route'].toString().toLowerCase();
          return bus.contains(query) || route.contains(query);
        }).toList();
      }
    });
  }

  Map<String, List<Map<String, dynamic>>> categorizeByTimeOfDay(
    List<Map<String, dynamic>> schedules,
  ) {
    Map<String, List<Map<String, dynamic>>> categorized = {
      "Morning": [],
      "Noon": [],
      "Evening": [],
    };

    for (var item in schedules) {
      final type = item["type"];
      if (categorized.containsKey(type)) {
        categorized[type]!.add(item);
      }
    }
    return categorized;
  }

  Widget scheduleCard(Map<String, dynamic> item) {
    return GestureDetector(
      onTapDown: (_) => setState(() {
        /* optional: scale card */
      }),
      onTapUp: (_) => setState(() {
        /* optional: reset scale */
      }),

      child: AnimatedContainer(
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
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
            // Circular time indicator
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor.withOpacity(0.9),
                    Theme.of(context).primaryColor.withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                item["time"],
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.white, // or a dark variant
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Bus & Route info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item["bus"],
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item["route"],
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors
                                .white70 // for dark mode
                          : Colors.black54, // for light mode
                    ),
                  ),
                ],
              ),
            ),

            // Reminder Button
            GestureDetector(
              onTap: () {
                final bus = item["bus"];
                final timeString = item["time"]; // "5:40 AM"

                // Convert string to DateTime
                final now = DateTime.now();
                final timeParts = timeString.split(RegExp(r'[: ]'));
                int hour = int.parse(timeParts[0]);
                int minute = int.parse(timeParts[1]);
                final period = timeParts[2];

                if (period == "PM" && hour != 12) hour += 12;
                if (period == "AM" && hour == 12) hour = 0;

                DateTime scheduledTime = DateTime(
                  now.year,
                  now.month,
                  now.day,
                  hour,
                  minute,
                );

                // If the time has already passed today, schedule for tomorrow
                if (scheduledTime.isBefore(now)) {
                  scheduledTime = scheduledTime.add(Duration(days: 1));
                }

                NotificationService.scheduleNotification(
                  id: bus.hashCode + scheduledTime.hashCode, // unique id
                  title: "Bus Reminder: $bus",
                  body: "Bus at ${item['time']} on route: ${item['route']}",
                  scheduledTime: scheduledTime,
                );

                // Show immediate confirmation notification
                // NotificationService.showNotification(
                //   id: bus.hashCode,
                //   title: "Reminder Set",
                //   body:
                //       "Reminder set for ${item['time']} on route ${item['route']}",
                // );

                // Save to local database (Hive)
                final box = Hive.box("notifications");
                box.add({
                  "title": "Bus Reminder: $bus",
                  "message":
                      "Bus at ${item['time']} on route: ${item['route']}",
                  "time": DateFormat('hh:mm a').format(scheduledTime),
                  "read": false,
                  "type": "info",
                  "createdAt": DateTime.now().toString(),
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Reminder set for ${item['time']}")),
                );
              },

              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withOpacity(0.85),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.alarm_rounded,
                      size: 18,
                      color: Theme.of(
                        context,
                      ).colorScheme.onPrimary, // adapts to theme
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Reminder",
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onPrimary, // adapts to theme
                        // color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSchedule(List<Map<String, dynamic>> data) {
    final categorized = categorizeByTimeOfDay(data);
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        if (categorized["Morning"]!.isNotEmpty) ...[
          Text("Morning", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...categorized["Morning"]!.map(scheduleCard),
          const SizedBox(height: 16),
        ],
        if (categorized["Noon"]!.isNotEmpty) ...[
          Text("Noon", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...categorized["Noon"]!.map(scheduleCard),
          const SizedBox(height: 16),
        ],
        if (categorized["Evening"]!.isNotEmpty) ...[
          Text("Evening", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...categorized["Evening"]!.map(scheduleCard),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.only(top: 50, bottom: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withOpacity(0.85),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      "Bus Schedule",
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onPrimary, // adapts to light/dark mode
                        fontSize: 20,
                      ),
                    ),
                  ),
                  // Positioned(
                  //   left: 16,
                  //   top: -4,
                  //   bottom: 0,
                  //   child: IconButton(
                  //     onPressed: () {
                  //       Navigator.pop(context);
                  //     },
                  //     icon: const Icon(
                  //       Icons.arrow_back_ios,
                  //       color: Colors.white,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),

            // Tabs
            Container(
              margin: const EdgeInsets.only(top: 16, bottom: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                //isScrollable: true,
                indicator: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary, // dynamic primary color
                  // color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                indicatorPadding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: -7,
                ),

                labelColor: Theme.of(
                  context,
                ).colorScheme.onPrimary, // text color on primary
                unselectedLabelColor: Theme.of(
                  context,
                ).colorScheme.onSurface.withOpacity(0.7),
                labelStyle: TextStyle(fontSize: 16),
                tabs: const [
                  Tab(text: "Weekdays"),
                  Tab(text: "Weekend"),
                ],
              ),
            ),
            //search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: TextField(
                onChanged: (value) {
                  filterSchedules(value);
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
                  fillColor: Theme.of(context).brightness == Brightness.light
                      ? Colors.white
                      : Colors.grey[850], // dynamic background for light/dark
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  hintStyle: TextStyle(
                    color: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.color?.withOpacity(0.6),
                  ),
                ),
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.color, // dynamic text color
                ),
              ),
            ),

            // date
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  formattedDate, // You can make this dynamic with DateTime
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.grey[700]
                        : Colors.grey[400],
                  ),
                ),
              ),
            ),

            // Schedule List
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        buildSchedule(filteredWeekdaySchedule),
                        buildSchedule(filteredWeekendSchedule),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
