import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Initialize timezones
    tz.initializeTimeZones();
    final String localTz = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localTz));

    // Android init
    const androidInit = AndroidInitializationSettings('@mipmap/launcher_icon');

    // iOS init
    const iosInit = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    final initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _notificationsPlugin.initialize(initSettings);
    await _createDefaultChannels();

    // Request permissions (iOS / Android 13+)
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  // Pre-create channels with custom sounds - ESSENTIAL for Android 11
  static Future<void> _createDefaultChannels() async {
    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      // Default channel with custom sound
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          'selavu_app_reminder',
          'Daily Reminder - Selavu',
          description: 'Selavu app - reminder',
          importance: Importance.high,
          sound: RawResourceAndroidNotificationSound('notification'),
          enableVibration: true,
          showBadge: true,
        ),
      );
  }
  }

  Future<void> scheduleDailyNotification(TimeOfDay time) async {
    final now = tz.TZDateTime.now(tz.local);

    // Schedule at today's chosen time
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    // If the time already passed today → schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _notificationsPlugin.zonedSchedule(
      0,
      "Selavu - Daily Expense Reminder",
      "Update your expenses now and stay financially confident.",
      scheduledDate,
      _notificationDetails(),
      matchDateTimeComponents: DateTimeComponents.time, // repeat daily
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  NotificationDetails _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'selavu_app_reminder',
        'Daily Reminder - Selavu',
        channelDescription: 'Selavu app - reminder',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        visibility: NotificationVisibility.public,
        sound: RawResourceAndroidNotificationSound('notification'),
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future<void> cancelAll() async {
    await _notificationsPlugin.cancelAll();
  }
}