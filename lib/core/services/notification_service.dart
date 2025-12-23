import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  /// Initialize notifications (call in main before runApp)
  static Future<void> initialize() async {
    tz.initializeTimeZones();

    // Android settings
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS settings
    final DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestSoundPermission: true,
          requestBadgePermission: true,
          requestAlertPermission: true,
        );

    // Combine platform settings
    final InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // Initialize
    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap when app is foreground/background
        print('Notification tapped: ${response.payload}');
      },
      onDidReceiveBackgroundNotificationResponse:
          notificationTapBackground, // For terminated app
    );
  }

  /// Handle background notification tap (required for iOS/Android)
  @pragma('vm:entry-point')
  static void notificationTapBackground(NotificationResponse response) {
    print('Notification tapped in background/terminated: ${response.payload}');
    // You can navigate to a specific screen here
  }

  /// Request notification permission (Android 13+ and iOS)
  static Future<void> requestPermission() async {
    final status = await Permission.notification.request();
    if (status.isGranted) {
      print("Notification permission granted");
    } else {
      print("Notification permission denied");
    }
  }

  /// Show instant notification (useful for testing)
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    await _notifications.show(
      id,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'bus_channel_id',
          'Bus Reminders',
          channelDescription: 'Reminders for bus schedules',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  /// Schedule notification at a specific time
  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'bus_channel_id',
          'Bus Reminders',
          channelDescription: 'Reminders for bus schedules',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      // uiLocalNotificationDateInterpretation:
      //   UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents:
          DateTimeComponents.time, // optional: daily at same time
    );
  }

  /// Cancel a scheduled notification by ID
  static Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  /// Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
}
