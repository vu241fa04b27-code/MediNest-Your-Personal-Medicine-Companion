import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  // Channel IDs
  static const String medChannelId = 'medinest_meds_channel_v1';
  static const String medChannelName = 'Medicine Reminders';
  static const String medChannelDesc = 'Critical alarms for daily medicine intake with action buttons';

  static const String hospitalChannelId = 'medinest_hospital_channel_v1';
  static const String hospitalChannelName = 'Hospital & Check-up Reminders';
  static const String hospitalChannelDesc = 'Monthly hospital check-up countdown and visit reminders';

  static const String stockChannelId = 'medinest_refill_channel_v1';
  static const String stockChannelName = 'Medicine Stock Refill Alerts';
  static const String stockChannelDesc = 'Alerts when tablet stock is running low';

  // Action IDs
  static const String actionTaken = 'ACTION_TAKEN';
  static const String actionSnooze = 'ACTION_SNOOZE';

  Function(String medicineId, String action)? onNotificationAction;

  Future<void> init({Function(String medicineId, String action)? onAction}) async {
    if (_isInitialized) return;
    onNotificationAction = onAction;

    try {
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const InitializationSettings initSettings = InitializationSettings(
        android: androidSettings,
      );

      await _notificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          final payload = response.payload ?? '';
          final actionId = response.actionId;
          debugPrint("Notification clicked: actionId=$actionId, payload=$payload");

          if (actionId == actionTaken) {
            onNotificationAction?.call(payload, 'taken');
          } else if (actionId == actionSnooze) {
            onNotificationAction?.call(payload, 'snooze');
          } else if (payload.isNotEmpty) {
            onNotificationAction?.call(payload, 'view');
          }
        },
      );

      // Create Android Notification Channels
      if (Platform.isAndroid) {
        final AndroidNotificationChannel medChannel = AndroidNotificationChannel(
          medChannelId,
          medChannelName,
          description: medChannelDesc,
          importance: Importance.max,
          enableVibration: true,
          vibrationPattern: Int64List.fromList([0, 500, 200, 500, 200, 800]),
          playSound: true,
          showBadge: true,
        );

        final AndroidNotificationChannel hospitalChannel = AndroidNotificationChannel(
          hospitalChannelId,
          hospitalChannelName,
          description: hospitalChannelDesc,
          importance: Importance.high,
          enableVibration: true,
          playSound: true,
        );

        final AndroidNotificationChannel stockChannel = AndroidNotificationChannel(
          stockChannelId,
          stockChannelName,
          description: stockChannelDesc,
          importance: Importance.high,
          enableVibration: true,
          playSound: true,
        );

        final androidPlugin = _notificationsPlugin
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

        await androidPlugin?.createNotificationChannel(medChannel);
        await androidPlugin?.createNotificationChannel(hospitalChannel);
        await androidPlugin?.createNotificationChannel(stockChannel);

        // Request runtime permission for Android 13+
        await androidPlugin?.requestNotificationsPermission();
        await androidPlugin?.requestExactAlarmsPermission();
      }

      _isInitialized = true;
    } catch (e) {
      debugPrint("NotificationService init error: $e");
    }
  }

  // Show Medicine Reminder Notification with Taken & Snooze Action Buttons
  Future<void> showMedicineAlert({
    required int id,
    required String medicineId,
    required String medicineName,
    required String timing, // e.g. "After Lunch" or "01:30 PM"
    required String purpose,
    int repeatAttempt = 0,
  }) async {
    final title = repeatAttempt == 0
        ? '💊 Time to take your medicine'
        : '⚠️ Reminder (${repeatAttempt * 10}m): Take $medicineName';

    final body = '$medicineName • $timing\nPurpose: $purpose';

    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      medChannelId,
      medChannelName,
      channelDescription: medChannelDesc,
      importance: Importance.max,
      priority: Priority.high,
      ongoing: true, // Remains on screen until marked as taken
      autoCancel: false,
      enableVibration: true,
      vibrationPattern: Int64List.fromList([0, 600, 250, 600]),
      styleInformation: BigTextStyleInformation(
        body,
        contentTitle: title,
        summaryText: 'MediNest Dose Alarm',
      ),
      actions: <AndroidNotificationAction>[
        const AndroidNotificationAction(
          actionTaken,
          '✓ Taken',
          showsUserInterface: true,
          cancelNotification: true,
        ),
        const AndroidNotificationAction(
          actionSnooze,
          '⏱ Snooze (10 min)',
          showsUserInterface: false,
        ),
      ],
    );

    final NotificationDetails notificationDetails = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: medicineId,
    );
  }

  // Monthly Hospital Appointment Notification
  Future<void> showHospitalReminder({
    required int id,
    required String doctorName,
    required String hospitalName,
    required String timeText,
    required String daysLeftText,
  }) async {
    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      hospitalChannelId,
      hospitalChannelName,
      channelDescription: hospitalChannelDesc,
      importance: Importance.high,
      priority: Priority.high,
      enableVibration: true,
      styleInformation: BigTextStyleInformation(
        'Check-up scheduled with $doctorName at $hospitalName.\n$timeText ($daysLeftText)',
        contentTitle: '🏥 Upcoming Hospital Visit: $daysLeftText',
        summaryText: 'Monthly Check-up',
      ),
    );

    final NotificationDetails notificationDetails = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      id,
      '🏥 Hospital Check-up Alert',
      'Visit $doctorName at $hospitalName ($daysLeftText)',
      notificationDetails,
    );
  }

  // Low Medicine Stock Notification
  Future<void> showLowStockNotification({
    required int id,
    required String medicineName,
    required int remainingCount,
  }) async {
    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      stockChannelId,
      stockChannelName,
      channelDescription: stockChannelDesc,
      importance: Importance.high,
      priority: Priority.high,
      enableVibration: true,
    );

    final NotificationDetails notificationDetails = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      id,
      '⚠️ Medicine Refill Alert',
      'Only $remainingCount tablets left of $medicineName. Buy refill soon.',
      notificationDetails,
    );
  }

  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  Future<void> cancelAll() async {
    await _notificationsPlugin.cancelAll();
  }
}
