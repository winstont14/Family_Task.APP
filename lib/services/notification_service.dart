import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    if (kIsWeb) return;

    tz.initializeTimeZones();
    final String localTz = await _resolveLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localTz));

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: darwinSettings,
        macOS: darwinSettings,
      ),
    );

    // Request permissions on macOS/iOS
    await _plugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  static Future<String> _resolveLocalTimezone() async {
    try {
      // Use the system local timezone name if it's valid
      final name = DateTime.now().timeZoneName;
      tz.getLocation(name);
      return name;
    } catch (_) {
      return 'UTC';
    }
  }

  static Future<void> scheduleTaskNotification({
    required String id,
    required String title,
    required DateTime dueDate,
  }) async {
    if (kIsWeb) return;
    if (dueDate.isBefore(DateTime.now())) return;

    final notifId = id.hashCode.abs() % 2147483647;

    const androidDetails = AndroidNotificationDetails(
      'todo_deadlines',
      'Task Deadlines',
      channelDescription: 'Alerts when a task deadline is reached',
      importance: Importance.high,
      priority: Priority.high,
    );
    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const details = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
      macOS: darwinDetails,
    );

    await _plugin.zonedSchedule(
      notifId,
      '⏰ "$title" is due!',
      'Your task deadline has arrived.',
      tz.TZDateTime.from(dueDate, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> cancelNotification(String id) async {
    if (kIsWeb) return;
    await _plugin.cancel(id.hashCode.abs() % 2147483647);
  }
}
