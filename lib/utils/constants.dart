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
const String userFname = "userFname";
const String userLname = "userLname";
const String userEmail = "userEmail";
const String userId = "userId";
const String userIsPublic = "isPublic";
const String userIsLoggedIn = "userIsLoggedIn";

const String goalsTable = "goal";
const String setsTable = "sets";

const String goalsTableOption = "Goals";
const String setsTableOption = "Sets";
const String rankTableOption = "Rank";
const String jsonFormatOption = "JSON";
const String csvFormatOption = "CSV";
const String localStorageSaveOption = "Local storage";
const String emailSaveOption = "Send to email";
const String allTimeDateOption = "All time";
const String customRangeDateOption = "Custom range";

final Goal placeholderGoal = Goal(
    type: defaultGoalType,
    date:
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
    goalAmount: 100);
final User placeholderUser = User(-1,"","","", true);
const String endpoint = "https://jyghodbane.alwaysdata.net";
