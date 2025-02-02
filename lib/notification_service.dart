// notification_service.dart

import 'dart:developer';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz_data.initializeTimeZones(); // Timezone setup

    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _notificationsPlugin.initialize(initializationSettings);

    // Create Notification Channels
    await _createNotificationChannels();
  }

  Future<void> _createNotificationChannels() async {
    // For Scheduled Notifications
    const AndroidNotificationChannel scheduledChannel =
        AndroidNotificationChannel(
      'scheduled_channel',
      'Scheduled Notifications',
      importance: Importance.max,
    );
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(scheduledChannel);
  }

  // ================== SCHEDULED NOTIFICATION ==================
  Future<void> scheduleNotification(DateTime scheduledTime) async {
    log("Schedule Notification Called");

    // Indian Timezone (Asia/Kolkata) current time
    final now = tz.TZDateTime.now(tz.getLocation('Asia/Kolkata'));

    // Scheduled time converted into Indian Timezone
    tz.TZDateTime scheduledTzTime = tz.TZDateTime.from(
      scheduledTime,
      tz.getLocation('Asia/Kolkata'),
    );
    log("Scheduled time in IST: $scheduledTzTime");

    if (scheduledTzTime.isBefore(now)) {
      scheduledTzTime = scheduledTzTime.add(const Duration(days: 1));
      log("Scheduled time updated to next day: $scheduledTzTime");
    }

    // Notification schedule
    await _notificationsPlugin.zonedSchedule(
      2,
      'Scheduled Notification',
      'You have a reading session now!',
      scheduledTzTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'scheduled_channel',
          'Scheduled Notifications',
          importance: Importance.max,
          playSound: true, // Sound enabled
          enableVibration: true, // Vibration enabled
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    log("Schedule Notification executed");
  }
}
