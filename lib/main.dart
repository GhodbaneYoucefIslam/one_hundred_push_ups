import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:one_hundred_push_ups/models/GoalProvider.dart';
import 'package:one_hundred_push_ups/screens/LoginPage.dart';
import 'package:one_hundred_push_ups/screens/OnboardingScreen.dart';
import 'package:one_hundred_push_ups/screens/SettingsPage.dart';
import 'package:one_hundred_push_ups/screens/SignUpPage.dart';
import 'package:one_hundred_push_ups/utils/LocalNotifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/UserProvider.dart';
import 'utils/constants.dart';
import "AppHome.dart";
import 'package:flutter_background/flutter_background.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final myPrefs = await SharedPreferences.getInstance();
  final  isFirstUse = myPrefs.getBool(showOnboarding)?? true;
  final areNotificationsOn = myPrefs.getBool(activateNotifications) ?? true;

  tz.initializeTimeZones();
  //final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
  //tz.setLocalLocation(tz.getLocation(currentTimeZone));
  final androidConfig = FlutterBackgroundAndroidConfig(
    notificationTitle: "Daily reminder notification controller",
    notificationText: "Running in the background to check if goal is complete",
    notificationImportance: AndroidNotificationImportance.Default,
    enableWifiLock: false,
  );

  await FlutterBackground.initialize(androidConfig: androidConfig);
  await LocalNotifications.init();
  await LocalNotifications.startBackgroundNotificationChecker(areNotificationsOn);

  runApp(const MyApp(isFirstUse: false/*todo: replace false with actual value before deployment*/));
}

class MyApp extends StatelessWidget {
  final bool isFirstUse;
  const MyApp({super.key, required this.isFirstUse});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>GoalProvider()),
        ChangeNotifierProvider(create: (context)=>UserProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: appName,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: lightBlue),
          useMaterial3: true,
          fontFamily: "SpaceGrotesk",
        ),
        home: /*isFirstUse? const OnboardingScreen() : const AppHome(title: appName)*/ AppHome(title: appName,),
      ),
    );
  }
}


