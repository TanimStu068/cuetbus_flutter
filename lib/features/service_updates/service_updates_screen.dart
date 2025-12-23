import 'package:flutter/material.dart';

class ServiceUpdatesScreen extends StatefulWidget {
  const ServiceUpdatesScreen({super.key});

  @override
  State<ServiceUpdatesScreen> createState() => _ServiceUpdatesScreenState();
}

class _ServiceUpdatesScreenState extends State<ServiceUpdatesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  // Dummy service updates data
  final List<Map<String, dynamic>> serviceUpdates = [
    {
      "title": "Bus 12 Delayed",
      "description": "Bus 12 will be delayed by 10 minutes due to traffic.",
      "time": "08:30 AM",
      "type": "warning", // can be 'info', 'warning', 'success'
    },
    {
      "title": "New Route Added",
      "description": "A new route from Dorm → Library is now available.",
      "time": "Yesterday, 4:15 PM",
      "type": "success",
    },
    {
      "title": "Maintenance Notice",
      "description":
          "Bus SMT → CUET will be unavailable tomorrow due to maintenance.",
      "time": "Yesterday, 9:00 AM",
      "type": "warning",
    },
    {
      "title": "App Update",
      "description": "New app version 2.1.0 is now available.",
      "time": "2 days ago",
      "type": "info",
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

  Color _getTypeColor(String type) {
    switch (type) {
      case 'success':
        return Colors.green;
      case 'warning':
        return Colors.orange;
      case 'info':
      default:
        return Theme.of(context).primaryColor;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'success':
        return Icons.check_circle_outline;
      case 'warning':
        return Icons.error_outline;
      case 'info':
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,

        title: Text(
          "Service Updates",
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
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: serviceUpdates.isEmpty
              ? Center(
                  child: Text(
                    "No updates available",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                )
              : ListView.separated(
                  itemCount: serviceUpdates.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final update = serviceUpdates[index];
                    final typeColor = _getTypeColor(update['type']);
                    final typeIcon = _getTypeIcon(update['type']);

                    return Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.white.withOpacity(0.05)
                                : Colors.black.withOpacity(0.06),

                            // color: Colors.black.withOpacity(0.06),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: typeColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(typeIcon, color: typeColor),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  update['title'],
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  update['description'],
                                  style: Theme.of(context).textTheme.bodySmall!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .color!
                                            .withOpacity(0.7),

                                        // color: Colors.grey[700],
                                      ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  update['time'],
                                  style: Theme.of(context).textTheme.bodySmall!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .color!
                                            .withOpacity(0.5),

                                        // color: Colors.grey[500],
                                      ),
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
      ),
    );
  }
}
