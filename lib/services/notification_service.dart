import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static const _birthdayId = 42;
  static const _morningRoutineId = 1;
  static const _eveningRoutineId = 2;

  static const _birthdayChannel = AndroidNotificationDetails(
    'afriglow_birthday',
    'Birthday Notifications',
    channelDescription: 'AfriGlow birthday celebration reminder',
    importance: Importance.high,
    priority: Priority.high,
  );

  static const _routineChannel = AndroidNotificationDetails(
    'afriglow_routine',
    'Routine Reminders',
    channelDescription: 'Daily skincare routine reminders',
    importance: Importance.high,
    priority: Priority.high,
    icon: '@mipmap/ic_launcher',
  );

  static Future<void> init() async {
    tz.initializeTimeZones();
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _plugin.initialize(settings);
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  /// Schedule (or reschedule) the annual birthday notification.
  static Future<void> scheduleBirthday(DateTime dob, String firstName) async {
    await _plugin.cancel(_birthdayId);

    final now = DateTime.now();
    var next = DateTime(now.year, dob.month, dob.day, 9, 0);
    if (!next.isAfter(now)) {
      next = DateTime(now.year + 1, dob.month, dob.day, 9, 0);
    }

    await _plugin.zonedSchedule(
      _birthdayId,
      '🎂 Happy Birthday, $firstName!',
      'Your skin is glowing today — just like you. Wishing you a beautiful birthday! 🌿✨',
      tz.TZDateTime.from(next, tz.local),
      const NotificationDetails(android: _birthdayChannel),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> cancelBirthday() async {
    await _plugin.cancel(_birthdayId);
  }

  /// Schedule a daily morning routine reminder.
  static Future<void> scheduleMorningReminder(int hour, int minute) async {
    await _plugin.cancel(_morningRoutineId);
    await _plugin.zonedSchedule(
      _morningRoutineId,
      '☀️ Morning Routine Time!',
      'Start your day right — your AfriGlow morning skincare routine is waiting.',
      _nextInstanceOfTime(hour, minute),
      const NotificationDetails(android: _routineChannel),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Schedule a daily evening routine reminder.
  static Future<void> scheduleEveningReminder(int hour, int minute) async {
    await _plugin.cancel(_eveningRoutineId);
    await _plugin.zonedSchedule(
      _eveningRoutineId,
      '🌙 Evening Routine Time!',
      'Wind down with your AfriGlow evening skincare routine for overnight repair.',
      _nextInstanceOfTime(hour, minute),
      const NotificationDetails(android: _routineChannel),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> cancelMorningReminder() async {
    await _plugin.cancel(_morningRoutineId);
  }

  static Future<void> cancelEveningReminder() async {
    await _plugin.cancel(_eveningRoutineId);
  }

  static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
