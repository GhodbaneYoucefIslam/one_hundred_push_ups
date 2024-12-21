import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:one_hundred_push_ups/utils/LocalNotifications.dart";
import "package:one_hundred_push_ups/utils/translationConstants.dart";
import "package:provider/provider.dart";
import "package:shared_preferences/shared_preferences.dart";
import "../models/GoalProvider.dart";
import "../utils/constants.dart";

class PreferencesPage extends StatefulWidget {
  const PreferencesPage({super.key});

  @override
  State<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  late bool areNotificationsOn;
  late String currentLanguage;
  bool isDataLoaded = false;

  Future<void> loadPreferences() async {
    final myPrefs = await SharedPreferences.getInstance();
    setState(() {
      areNotificationsOn = myPrefs.getBool(activateNotifications) ?? true;
      currentLanguage = myPrefs.getString(chosenLanguage) ?? english;
      isDataLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    loadPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: isDataLoaded? buildPage(context) : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget buildPage(BuildContext context){
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 30, right: 30, bottom: 100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            inAppPreferences.tr,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.25,
            decoration: BoxDecoration(
              color: grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  notifications.tr,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.notifications_off,
                          size: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 7),
                          child: Text(inactive.tr,
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                    Switch(
                        value: areNotificationsOn,
                        onChanged: (value) async{
                          setState(() {
                            areNotificationsOn = !areNotificationsOn;
                          });
                          //save notification activation status
                          final myPrefs = await SharedPreferences.getInstance();
                          myPrefs.setBool(activateNotifications, areNotificationsOn);
                          //trigger changes
                          print("status : $areNotificationsOn");
                          int goal = Provider.of<GoalProvider>(context, listen: false).todayGoal!.goalAmount;
                          int totalReps = Provider.of<GoalProvider>(context, listen: false).totalReps;
                          LocalNotifications.updateBackgroundNotificationCheckerStatus(areNotificationsOn, totalReps>=goal);
                        }),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 7),
                          child: Icon(
                            Icons.notifications_active,
                            size: 20,
                          ),
                        ),
                        Text(active.tr,
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold))
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.25,
            decoration: BoxDecoration(
              color: grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  displayLanguage.tr,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) => Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          width: MediaQuery.of(context).size.width * 0.95,
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  RadioMenuButton(
                                      value: english,
                                      groupValue: currentLanguage,
                                      onChanged: (selectedLanguage) async {
                                        setState(() {
                                          currentLanguage =
                                          selectedLanguage!;
                                        });
                                        final myPrefs = await SharedPreferences.getInstance();
                                        myPrefs.setString(chosenLanguage, currentLanguage);
                                        var locale = Locale("en","US");
                                        Get.updateLocale(locale);
                                        Navigator.pop(context);
                                      },
                                      child: Text(english)),
                                  RadioMenuButton(
                                      value: french,
                                      groupValue: currentLanguage,
                                      onChanged: (selectedLanguage) async{
                                        setState(() {
                                          currentLanguage =
                                          selectedLanguage!;
                                        });
                                        final myPrefs = await SharedPreferences.getInstance();
                                        myPrefs.setString(chosenLanguage, currentLanguage);
                                        var locale = Locale("fr","FR");
                                        Get.updateLocale(locale);
                                        Navigator.pop(context);
                                      },
                                      child: Text(french))
                                ],
                              ),
                            ],
                          ),
                        ));
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(lightBlue),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      "${displayLanguage.tr} : $currentLanguage \n (${tapToChange.tr})",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
