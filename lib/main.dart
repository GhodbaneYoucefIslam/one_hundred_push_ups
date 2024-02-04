import 'package:flutter/material.dart';
import 'package:one_hundred_push_ups/screens/OnboardingScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'utils/constants.dart';
import "AppHome.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final myPrefs = await SharedPreferences.getInstance();
  final  isFirstUse = myPrefs.getBool(showOnboarding)?? true;
  runApp(MyApp(isFirstUse: true));
}

class MyApp extends StatelessWidget {
  final bool isFirstUse;
  const MyApp({super.key, required this.isFirstUse});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '100PushUPs',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: lightBlue),
        useMaterial3: true,
        fontFamily: "SpaceGrotesk",
      ),
      home: isFirstUse? const OnboardingScreen() : const AppHome(title: "100PushUPs"),
    );
  }
}


