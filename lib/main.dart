import 'package:flutter/material.dart';
import 'package:one_hundred_push_ups/models/GoalProvider.dart';
import 'package:one_hundred_push_ups/models/ThemeProvider.dart';
import 'package:one_hundred_push_ups/screens/OnboardingScreen.dart';
import 'package:one_hundred_push_ups/utils/LocalNotifications.dart';
import 'package:one_hundred_push_ups/utils/LocaleStrings.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/UserProvider.dart';
import 'utils/constants.dart';
import "AppHome.dart";
import 'package:flutter_background/flutter_background.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:get/get.dart';
import 'theme/AppThemes.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.removeAfter(initialization);

  final myPrefs = await SharedPreferences.getInstance();
  final isFirstUse = myPrefs.getBool(showOnboarding) ?? true;
  final currentLanguage = myPrefs.getString(chosenLanguage) ?? english;

  tz.initializeTimeZones();
  const androidConfig = FlutterBackgroundAndroidConfig(
    notificationTitle: "Daily reminder notification controller",
    notificationText: "Running in the background to check if goal is complete",
    notificationImportance: AndroidNotificationImportance.Default,
    enableWifiLock: false,
  );

  await FlutterBackground.initialize(androidConfig: androidConfig);
  await LocalNotifications.init();

  runApp(MyApp(
    isFirstUse: isFirstUse,
    currentLanguage: currentLanguage,
  ));
}

Future initialization(BuildContext? context) async {
  await Future.delayed(const Duration(seconds: 2));
}

class MyApp extends StatelessWidget {
  final bool isFirstUse;
  final String currentLanguage;
  const MyApp(
      {super.key, required this.isFirstUse, required this.currentLanguage});

  Locale languageToLocale(String language) {
    switch (language) {
      case english:
        return const Locale("en", "US");
      case french:
        return const Locale("fr", "FR");
      default:
        return const Locale("en", "US");
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GoalProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          translations: LocaleStrings(),
          locale: languageToLocale(currentLanguage),
          title: appName,
          theme: AppThemes.getLightTheme(),
          darkTheme: AppThemes.getDarkTheme(),
          themeMode: context.watch<ThemeProvider>().getCurrentThemeMode,
          home: isFirstUse
              ? const OnboardingScreen()
              : const AppHome(title: appName),
        );
      }),
    );
  }
}
