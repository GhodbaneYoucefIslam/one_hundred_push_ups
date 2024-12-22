import 'package:flutter/cupertino.dart';
import 'package:one_hundred_push_ups/models/User.dart';
import '../utils/constants.dart';
import "package:shared_preferences/shared_preferences.dart";

class UserProvider extends ChangeNotifier {
  User? currentUser;
  void initUserFromPrefs() async {
    final myPrefs = await SharedPreferences.getInstance();
    final isLoggedIn = myPrefs.getBool(userIsLoggedIn) ?? false;
    if (isLoggedIn) {
      final fName = myPrefs.getString(userFname) ?? "";
      final lName = myPrefs.getString(userLname) ?? "";
      final email = myPrefs.getString(userEmail) ?? "";
      final id = myPrefs.getInt(userId) ?? -1;
      final isPublic = myPrefs.getBool(userIsPublic) ?? true;
      currentUser = User(id, fName, lName, email, isPublic);
      notifyListeners();
    }
  }

  void setUser({required User? user}) {
    currentUser = user;
    notifyListeners();
  }
}
