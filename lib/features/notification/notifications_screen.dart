import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String, dynamic>> notifications = [];
  late Box notificationsBox;

  @override
  void initState() {
    super.initState();
    notificationsBox = Hive.box("notifications");
    loadNotifications();
  }

  void loadNotifications() {
    // Convert Hive values to List<Map<String, dynamic>>
    notifications = notificationsBox.values
        .map((e) => Map<String, dynamic>.from(e))
        .toList()
        .reversed
        .toList(); // show latest first
    setState(() {});
  }

  Future<void> _refreshNotifications() async {
    await Future.delayed(const Duration(milliseconds: 300));
    loadNotifications();
  }

  IconData _getIcon(String type) {
    switch (type) {
      case "success":
        return Icons.check_circle_rounded;
      case "info":
        return Icons.notifications_active_rounded;
      case "alert":
        return Icons.warning_rounded;
      case "update":
        return Icons.system_update_alt_rounded;
      default:
        return Icons.info;
    }
  }

  Color _getColor(String type) {
    switch (type) {
      case "success":
        return Colors.green;
      case "info":
        return Colors.blue;
      case "alert":
        return Colors.red;
      case "update":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // backgroundColor: AppColors.bgColor,
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: Text(
          "Notification",
          style: TextStyle(color: theme.appBarTheme.foregroundColor),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: theme.appBarTheme.foregroundColor,
          ),
          onPressed: () {
            Navigator.pop(context); // goes back to previous screen
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshNotifications,
        child: CustomScrollView(
          slivers: [
            // Top curved header
            SliverToBoxAdapter(
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.primary.withOpacity(0.8),
                      // AppColors.primary,
                      // AppColors.primary.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                padding: const EdgeInsets.only(left: 24, right: 24, top: 60),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Notifications",
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).appBarTheme.foregroundColor, // dynamic
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Stay updated with your CUETBus activity",
                      style: theme.textTheme.bodySmall!.copyWith(
                        color: Theme.of(
                          context,
                        ).appBarTheme.foregroundColor, // dynamic
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Notification list
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final item = notifications[index];

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        item["read"] = true;

                        // Update Hive
                        final key = notificationsBox.keys.firstWhere(
                          (k) =>
                              Map<String, dynamic>.from(
                                    notificationsBox.get(k),
                                  )["time"] ==
                                  item["time"] &&
                              Map<String, dynamic>.from(
                                    notificationsBox.get(k),
                                  )["title"] ==
                                  item["title"],
                          orElse: () => null,
                        );

                        if (key != null) {
                          notificationsBox.put(key, item);
                        }
                      });
                    },

                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: item["read"]
                            ? theme.cardColor
                            : theme.colorScheme.primary.withOpacity(0.07),
                        // color: item["read"]
                        //     ? Colors.white
                        //     : AppColors.primary.withOpacity(0.07),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.shadow.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Icon
                          Container(
                            height: 48,
                            width: 48,
                            decoration: BoxDecoration(
                              color: _getColor(item["type"]).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              _getIcon(item["type"]),
                              color: _getColor(item["type"]),
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Texts
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item["title"],
                                  style: theme.textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item["message"],
                                  style: theme.textTheme.bodySmall!.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .color
                                        ?.withOpacity(0.7), // dynamic
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  item["time"],
                                  style: theme.textTheme.bodySmall!.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .color
                                        ?.withOpacity(0.5), // dynamic
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Unread dot
                          if (!item["read"])
                            Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                color: theme.primaryColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Theme.of(context)
                                  .colorScheme
                                  .error, // dynamic red for both themes
                            ),
                            onPressed: () {
                              final key = notificationsBox.keys.firstWhere(
                                (k) =>
                                    Map<String, dynamic>.from(
                                          notificationsBox.get(k),
                                        )["time"] ==
                                        item["time"] &&
                                    Map<String, dynamic>.from(
                                          notificationsBox.get(k),
                                        )["title"] ==
                                        item["title"],
                                orElse: () => null,
                              );

                              if (key != null) {
                                notificationsBox.delete(key);
                                loadNotifications();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }, childCount: notifications.length),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
