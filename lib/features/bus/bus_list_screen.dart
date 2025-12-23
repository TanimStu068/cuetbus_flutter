import 'package:cuetbus/core/routing/app_routes.dart';
import 'package:cuetbus/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:cuetbus/core/services/bus_service.dart';

class BusListScreen extends StatefulWidget {
  const BusListScreen({super.key});

  @override
  State<BusListScreen> createState() => _BusListScreenState();
}

class _BusListScreenState extends State<BusListScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  List<Map<String, dynamic>> filteredBuses = []; // filtered list
  TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> buses = []; // <-- define buses here

  Future<void> fetchBuses() async {
    try {
      final data = await BusService.getBuses();
      setState(() {
        buses = data;
        filteredBuses = List<Map<String, dynamic>>.from(
          buses,
        ); // initialize filtered list
      });
    } catch (e) {
      print("Error fetching buses: $e");
    }
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _controller.forward();

    // Fetch buses from backend
    fetchBuses();
  }

  void filterBuses(String query) {
    query = query.toLowerCase().trim();
    if (query.isEmpty) {
      setState(() {
        filteredBuses = List<Map<String, dynamic>>.from(buses);
      });
    } else {
      setState(() {
        filteredBuses = buses.where((bus) {
          final busNo = bus['busNo'].toString().toLowerCase();
          final route = bus['route'].toString().toLowerCase();
          final time = bus['time'].toString().toLowerCase();
          return busNo.contains(query) ||
              route.contains(query) ||
              time.contains(query);
        }).toList();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    searchController.dispose();
    super.dispose();
  }

  Color statusColor(BuildContext context, String status) {
    final colors = Theme.of(context).colorScheme;

    switch (status) {
      case "On Time":
        return colors.success;
      case "Arriving":
        return colors.secondary;
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
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0.6,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        //   onPressed: () {
        //     Navigator.pop(context); // goes back to previous screen
        //   },
        // ),
        centerTitle: true,
        title: Text(
          "Available Buses",
          style: TextStyle(
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeIn,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // ===================== SEARCH BAR =====================
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(18),
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
                child: TextField(
                  controller: searchController,
                  onChanged: filterBuses, // <-- add this
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium, // dynamic text color

                  decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(
                      Icons.search,
                      color: Theme.of(context).colorScheme.primary,
                      // color: AppColors.primary,
                      size: 28,
                    ),
                    hintText: "Search bus, route, time",
                    hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).hintColor,
                    ),
                    suffixIcon: searchController.text.isEmpty
                        ? null
                        : IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            onPressed: () {
                              searchController.clear();
                              filterBuses('');
                            },
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // ===================== SORT & FILTER =====================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Sort
                  InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(
                              context,
                            ).shadowColor.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.sort_rounded,
                            size: 22,
                            color: Theme.of(context).colorScheme.primary,

                            // color: AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Sort",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Filter
                  InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary, // dynamic primary color
                        // color: AppColors.primary.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.filter_alt_rounded,
                            size: 22,
                            color: Theme.of(
                              context,
                            ).colorScheme.onPrimary, // dynamic: white or black
                            // color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Filter",
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ===================== BUS LIST =====================
              Expanded(
                child: ListView.separated(
                  itemCount: filteredBuses.length,
                  physics: const BouncingScrollPhysics(),
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final bus = filteredBuses[index];
                    final double percent = bus["available"] / bus["capacity"];

                    return Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(
                              context,
                            ).colorScheme.shadow.withOpacity(0.06),
                            blurRadius: 14,
                            offset: const Offset(0, 7),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // --------------------- TOP ROW ---------------------
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                bus["busNo"],
                                style: Theme.of(context).textTheme.titleMedium,

                                // style: AppTextStyles.titleMedium,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    bus["favorite"] = !bus["favorite"];
                                  });
                                },
                                child: Icon(
                                  bus["favorite"]
                                      ? Icons.favorite
                                      : Icons.favorite_border_outlined,
                                  color: bus["favorite"]
                                      ? Colors.red
                                      : Theme.of(context).colorScheme.onSurface
                                            .withOpacity(0.5),
                                  size: 26,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 6),

                          Text(
                            bus["route"],
                            style: Theme.of(context).textTheme.bodySmall,
                          ),

                          const SizedBox(height: 14),

                          Row(
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                size: 20,
                                color: Theme.of(context).colorScheme.primary,

                                // color: AppColors.primary.withOpacity(0.9),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                bus["time"],
                                style: Theme.of(context).textTheme.bodyMedium,

                                // style: AppTextStyles.bodyMedium,
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),

                          // --------------------- STATUS ---------------------
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
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

                          const SizedBox(height: 18),

                          // --------------------- Seat Availability ---------------------
                          Text(
                            "Seat Availability",
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          const SizedBox(height: 4),

                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              minHeight: 10,
                              value: percent,
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.12),
                              color: percent > 0.6
                                  ? Colors.green
                                  : percent > 0.3
                                  ? Colors.orange
                                  : Colors.red,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            "${bus["available"]}/${bus["capacity"]} seats available",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),

                          const SizedBox(height: 16),

                          // --------------------- ACTION BUTTON ---------------------
                          Align(
                            alignment: Alignment.bottomRight,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.busDetails,
                                  arguments: bus,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.primary,
                                foregroundColor: Theme.of(
                                  context,
                                ).colorScheme.onPrimary,
                                // backgroundColor: AppColors.primary,
                                // foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 22,
                                  vertical: 12,
                                ),
                              ),
                              child: const Text("View Details"),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
