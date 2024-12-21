import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:one_hundred_push_ups/utils/constants.dart';
import 'package:one_hundred_push_ups/utils/translationConstants.dart';
import 'package:timezone/timezone.dart' as tz;

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
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();
    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            macOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (details) => null);

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

  static Future startBackgroundNotificationChecker(bool areNotificationsOn) async {
    if (areNotificationsOn){
      print("from update : turning on");
      bool success = await FlutterBackground.enableBackgroundExecution();
      if (success) {
        isRunning = true;
        timer = Timer.periodic(Duration(seconds: 3600), (timer) {
          showSimpleNotification(notificationTitle.tr, notificationMessage.tr, "");
        });
      }
    }
  }

  static void updateBackgroundNotificationCheckerStatus(bool areNotificationsOn, bool isGoalCompleted) async{
    print("areNotificationsOn: $areNotificationsOn");
    print("isGoalCompleted: $isGoalCompleted");
    //stop if process is running
    if (isRunning){
      if (!areNotificationsOn || isGoalCompleted){
        timer.cancel();
        await FlutterBackground.disableBackgroundExecution();
        print("from update : turning off");
        isRunning = false;
      }
    }
    //start if process isn't running
    else{
      if (!isGoalCompleted){
        startBackgroundNotificationChecker(areNotificationsOn);
      }
    }
  }
}
