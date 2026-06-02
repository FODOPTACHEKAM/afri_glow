import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static const _birthdayId = 42;

  static const _androidChannel = AndroidNotificationDetails(
    'afriglow_birthday',
    'Birthday Notifications',
    channelDescription: 'AfriGlow birthday celebration reminder',
    importance: Importance.high,
    priority: Priority.high,
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
      const NotificationDetails(android: _androidChannel),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> cancelBirthday() async {
    await _plugin.cancel(_birthdayId);
  }
}
