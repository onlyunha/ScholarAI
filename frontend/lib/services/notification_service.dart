/// =============================================================
/// File : notification_service. dart
/// Desc : 알림 서비스
/// Auth : yunha Hwang (DKU)
/// Crtd : 2025-06-08
/// Updt : 2025-06-08
/// =============================================================

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';

class NotificationService {
  static const MethodChannel _channel = MethodChannel('exact_alarm_channel');

  static Future<void> scheduleSafeNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    // 에뮬레이터 또는 웹/테스트 환경인 경우: 즉시 알림으로 대체
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      final isEmulator = await _isEmulator();
      if (isEmulator) {
        print('⚠️ 에뮬레이터 환경입니다. 즉시 알림으로 대체합니다.');
        await showNow(id: id, title: title, body: body);
        return;
      }
    }

    // 실기기라면 정확 알람 예약
    await scheduleNotification(
      id: id,
      title: title,
      body: body,
      scheduledTime: scheduledTime,
    );
  }

  // 에뮬레이터 감지용
  static Future<bool> _isEmulator() async {
    final deviceInfoPlugin = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfoPlugin.androidInfo;
      final model = androidInfo.model?.toLowerCase() ?? '';
      final device = androidInfo.device?.toLowerCase() ?? '';
      const emulatorIndicators = [
        'generic',
        'sdk',
        'emulator',
        'goldfish',
        'ranchu',
      ];

      return emulatorIndicators.any(
        (e) => model.contains(e) || device.contains(e),
      );
    }

    if (Platform.isIOS) {
      final iosInfo = await deviceInfoPlugin.iosInfo;
      return !iosInfo.isPhysicalDevice;
    }
    return false;
  }

  static Future<String> _getProp(String name) async {
    try {
      final result = await Process.run('getprop', [name]);
      return result.stdout.toString().trim();
    } catch (e) {
      return '';
    }
  }

  static Future<void> requestExactAlarmPermission() async {
    try {
      await _channel.invokeMethod('requestExactAlarmPermission');
    } on PlatformException catch (e) {
      print("❌ 권한 요청 실패: ${e.message}");
    }
  }

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iOSSettings =
        DarwinInitializationSettings();

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iOSSettings,
    );

    await _plugin.initialize(initSettings);
  }

  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'scholarship_channel',
          'Scholarship Notifications',
          channelDescription: '찜한 장학금에 대한 알림입니다.',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  static Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id);
  }

  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  // 테스트용
  static Future<void> showNow({
    required int id,
    required String title,
    required String body,
  }) async {
    await _plugin.show(
      id,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'scholarship_channel',
          'Scholarship Notifications',
          channelDescription: '테스트용 즉시 알림',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }
}
