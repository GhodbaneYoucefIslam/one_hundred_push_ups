import 'dart:ui';

import 'package:one_hundred_push_ups/models/Goal.dart';

import '../models/User.dart';

Color darkBlue = const Color(0xFF233565);
Color lightBlue = const Color(0xFF0075A6);
Color turquoiseBlue = const Color(0xFF00B9C9);
Color greenBlue = const Color(0xFF6EFACC);
Color grey = const Color(0xFFB9B9B9);

const String showOnboarding = "showOnboarding";
const String dailyGoalId = "dailyGoalId";
const String defaultGoalType = "pushUps";
const String appName = "100PushUPs";

final Goal placeholderGoal =  Goal(type: defaultGoalType, date: DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day), goalAmount: 100);
final User me = User(3,"me","me","me@me.com");//todo: replace with actual current user
const String endpoint = "https://one-hundred-push-ups-backend.onrender.com";