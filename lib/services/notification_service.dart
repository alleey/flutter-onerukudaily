
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../common/native.dart';

class AppLaunchInfo {
  final bool isNotificationLaunch;
  final String payload;

  AppLaunchInfo({
    this.isNotificationLaunch = false,
    this.payload = "",
  });

  AppLaunchInfo copyWith({
    bool? isNotificationLaunch,
    String? payload,
  }) {
    return AppLaunchInfo(
      isNotificationLaunch: isNotificationLaunch ?? this.isNotificationLaunch,
      payload: payload ?? this.payload,
    );
  }
}

class NotificationService {

  final _plugin = FlutterLocalNotificationsPlugin();

  AppLaunchInfo appLaunchInfo = AppLaunchInfo();
  bool platformHasSupport = false;

  Future<bool?> initialize() async {

    bool initialized = true;
    platformHasSupport = !kIsWeb && (Platform.isAndroid || Platform.isMacOS);
    if (platformHasSupport && Platform.isAndroid) {
      platformHasSupport = !(await NativeChannel.isAndroidTV());
    }

    if (platformHasSupport) {
      var settings = const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: DarwinInitializationSettings()
        );

      initialized = await _plugin.initialize(settings) ?? true;
      if (initialized) {
        appLaunchInfo = await _didNotificationLaunchApp();
      }
    }

    return initialized;
  }

  Future<bool> hasPendingdNotifications() async {
    var pending = await _plugin.pendingNotificationRequests();
    return pending.isNotEmpty;
  }

  NotificationDetails _notificationDetails() {
    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
          'io.alleey.development.read_ruku_everyday',
          'Read 1 Ruku Everday',
          channelDescription: 'Read 1 Ruku Everday',
          importance: Importance.max,
          priority: Priority.high,
        ),
      iOS: DarwinNotificationDetails()
    );
    return notificationDetails;
  }

  Future<AppLaunchInfo> _didNotificationLaunchApp() async {

    final details = await _plugin.getNotificationAppLaunchDetails();
    if (details?.didNotificationLaunchApp ?? false) {
      return AppLaunchInfo(
        isNotificationLaunch: true,
        payload: details!.notificationResponse?.payload ?? ""
      );
    }
    return AppLaunchInfo();
  }

  Future<bool> requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      await _plugin
          .resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      return await android?.requestNotificationsPermission() ?? false;
    }
    return true;
  }

  Future<void> cancelAllNotifications() async {
    await _plugin.cancelAll();
  }

  Future<void> scheduleNotification({
    int id = 1,
    required tz.TZDateTime scheduledDate,
    String? title,
    String? body
  }) async {

    final details = _notificationDetails();
    await _plugin.zonedSchedule(
      id, // Notification ID
      title,
      body, // Notification body
      scheduledDate,
      details,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exact,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}
