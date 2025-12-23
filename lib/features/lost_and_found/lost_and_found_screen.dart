import 'package:flutter/material.dart';

class LostAndFoundScreen extends StatefulWidget {
  const LostAndFoundScreen({super.key});

  @override
  State<LostAndFoundScreen> createState() => _LostAndFoundScreenState();
}

class _LostAndFoundScreenState extends State<LostAndFoundScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  String selectedFilter = "All"; // All, Lost, Found

  final List<Map<String, dynamic>> lostItems = [
    {
      "name": "Black Backpack",
      "description": "Found near the Library entrance.",
      "date": "Nov 15, 2025",
      "contact": "01712345678",
      "status": "Found",
      "icon": Icons.backpack,
    },
    {
      "name": "Blue Umbrella",
      "description": "Left on Bus 12 yesterday.",
      "date": "Nov 14, 2025",
      "contact": "01798765432",
      "status": "Lost",
      "icon": Icons.umbrella,
    },
    {
      "name": "Wallet",
      "description": "Black leather wallet found in Parking Area.",
      "date": "Nov 13, 2025",
      "contact": "01711223344",
      "status": "Found",
      "icon": Icons.account_balance_wallet,
    },
    {
      "name": "Phone",
      "description": "Left on Bus 5, black iPhone.",
      "date": "Nov 15, 2025",
      "contact": "01710000001",
      "status": "Lost",
      "icon": Icons.phone_iphone,
    },
    {
      "name": "Charger",
      "description": "White USB-C charger lost near Canteen.",
      "date": "Nov 16, 2025",
      "contact": "01710000002",
      "status": "Lost",
      "icon": Icons.power,
    },
    {
      "name": "EarPods",
      "description": "Wireless earphones, black color.",
      "date": "Nov 16, 2025",
      "contact": "01710000003",
      "status": "Lost",
      "icon": Icons.headphones,
    },
    {
      "name": "Powerbank",
      "description": "10,000mAh powerbank found in Library.",
      "date": "Nov 16, 2025",
      "contact": "01710000004",
      "status": "Found",
      "icon": Icons.battery_charging_full,
    },
    {
      "name": "Watch",
      "description": "Digital watch left in classroom.",
      "date": "Nov 16, 2025",
      "contact": "01710000005",
      "status": "Lost",
      "icon": Icons.watch_later,
    },
    {
      "name": "Money Bag",
      "description": "Small wallet with cash, found near parking.",
      "date": "Nov 16, 2025",
      "contact": "01710000006",
      "status": "Found",
      "icon": Icons.account_balance,
    },
    {
      "name": "ID Card",
      "description": "Student ID card found on Bus 3.",
      "date": "Nov 16, 2025",
      "contact": "01710000007",
      "status": "Found",
      "icon": Icons.badge,
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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Found':
        return Colors.green;
      case 'Lost':
      default:
        return Colors.redAccent;
    }
  }

  List<Map<String, dynamic>> get filteredItems {
    if (selectedFilter == "All") return lostItems;
    return lostItems.where((item) => item['status'] == selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Lost & Found",
          style: TextStyle(
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // -------------------- FILTER BUTTONS -------------------- //
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: ["All", "Lost", "Found"].map((filter) {
                  final isSelected = selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: ChoiceChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() {
                          selectedFilter = filter;
                        });
                      },
                      selectedColor: Theme.of(context).colorScheme.primary,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? Theme.of(context).colorScheme.onPrimary
                            : Colors.black,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // -------------------- LOST & FOUND LIST -------------------- //
              Expanded(
                child: filteredItems.isEmpty
                    ? Center(
                        child: Text(
                          "No items available",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      )
                    : ListView.separated(
                        itemCount: filteredItems.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final item = filteredItems[index];
                          final statusColor = _getStatusColor(item['status']);

                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(22),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.shadow.withOpacity(0.06),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Placeholder for image
                                Container(
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceVariant, // dynamic background
                                    // color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Icon(
                                    item['icon'] as IconData,
                                    size: 40,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              item['name'],
                                              style: Theme.of(
                                                context,
                                              ).textTheme.titleMedium,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: statusColor.withOpacity(
                                                0.15,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              item['status'],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(color: statusColor),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        item['description'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurfaceVariant, // dynamic color
                                              // color: Colors.grey[700],
                                            ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_today_outlined,
                                            size: 14,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant, // dynamic color
                                            // color: Colors.grey,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            item['date'],
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurfaceVariant, // dynamic color
                                                  // color: Colors.grey[500],
                                                ),
                                          ),
                                          const SizedBox(width: 12),
                                          Icon(
                                            Icons.phone,
                                            size: 14,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSurfaceVariant,
                                          ),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              item['contact'],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurfaceVariant, // dynamic color
                                                    // color: Colors.grey[500],
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
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
