import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:one_hundred_push_ups/utils/translationConstants.dart';

class LocalNotifications {
  static bool isRunning = false;
  static late Timer timer;
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static Future init() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();
    const LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            macOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (details) => {});

    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future showSimpleNotification(
      String title, String body, String payload) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, notificationDetails, payload: payload);
  }

  static Future startBackgroundNotificationChecker(
      bool areNotificationsOn) async {
    if (areNotificationsOn) {
      bool success = await FlutterBackground.enableBackgroundExecution();
      if (success) {
        isRunning = true;
        timer = Timer.periodic(const Duration(seconds: 10), (timer) {
          showSimpleNotification(
              notificationTitle.tr, notificationMessage.tr, "");
        });
      }
    }
  }

  static void updateBackgroundNotificationCheckerStatus(
      bool areNotificationsOn, bool isGoalCompleted) async {
    //stop if process is running
    if (isRunning) {
      if (!areNotificationsOn || isGoalCompleted) {
        timer.cancel();
        await FlutterBackground.disableBackgroundExecution();
        isRunning = false;
      }
    }
    //start if process isn't running
    else {
      if (!isGoalCompleted) {
        startBackgroundNotificationChecker(areNotificationsOn);
      }
    }
  }
}
