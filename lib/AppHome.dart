import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:one_hundred_push_ups/database/DatabaseService.dart';
import 'package:one_hundred_push_ups/models/GoalProvider.dart';
import 'package:one_hundred_push_ups/screens/HomePage.dart';
import 'package:one_hundred_push_ups/screens/LeaderboardPage.dart';
import 'package:one_hundred_push_ups/screens/LoginPage.dart';
import 'package:one_hundred_push_ups/screens/MyGoalsPage.dart';
import 'package:one_hundred_push_ups/screens/SettingsPage.dart';
import 'package:one_hundred_push_ups/utils/translationConstants.dart';
import 'package:one_hundred_push_ups/widgets/SideMenu.dart';
import 'package:one_hundred_push_ups/widgets/SideMenuItem.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/UserProvider.dart';
import 'models/ThemeProvider.dart';
import 'utils/constants.dart';
import 'package:one_hundred_push_ups/utils/MenuEntry.dart';

class AppHome extends StatefulWidget {
  const AppHome({super.key, required this.title});
  final String title;

  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  late MenuEntry currentPage;
  late Widget body;
  bool isLoggedIn = false;

  Future<void> verifyIsLoggedIn(BuildContext context) async {
    final myPrefs = await SharedPreferences.getInstance();
    isLoggedIn = myPrefs.getBool(userIsLoggedIn) ?? false;
    Provider.of<UserProvider>(context, listen: false).initUserFromPrefs();
  }

  void logOut(BuildContext context) async {
    final myPrefs = await SharedPreferences.getInstance();
    myPrefs.setInt(userId, -1);
    myPrefs.setString(userEmail, "");
    myPrefs.setString(userFname, "");
    myPrefs.setString(userLname, "");
    myPrefs.setBool(userIsPublic, true);
    myPrefs.setBool(userIsLoggedIn, false);
    Provider.of<UserProvider>(context, listen: false).setUser(user: null);
  }

  @override
  void initState() {
    super.initState();
    currentPage = MenuEntry.home;
    body = const HomePage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      //backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: lightBlue,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(widget.title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      drawer: FutureBuilder(
        future: verifyIsLoggedIn(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            return SideMenu(
              accountEmail: context.watch<UserProvider>().currentUser != null
                  ? context.watch<UserProvider>().currentUser!.email
                  : "",
              accountName: context.watch<UserProvider>().currentUser != null
                  ? "${context.watch<UserProvider>().currentUser!.lastname} ${context.watch<UserProvider>().currentUser!.firstname}"
                  : notConnected.tr,
              avatar: Text(
                context.watch<UserProvider>().currentUser != null
                    ? context.watch<UserProvider>().currentUser!.initials()
                    : "",
                style: const TextStyle(fontSize: 20),
              ),
              menuEntries: [
                SideMenuItem(
                  id: 1,
                  title: home.tr,
                  icon: Icons.home_filled,
                  selected: currentPage == MenuEntry.home ? true : false,
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      currentPage = MenuEntry.home;
                      body = const HomePage();
                    });
                  },
                ),
                SideMenuItem(
                  id: 2,
                  title: statsAndGoals.tr,
                  icon: Icons.query_stats,
                  selected: currentPage == MenuEntry.goal ? true : false,
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      currentPage = MenuEntry.goal;
                      body = const MyGoalsPage();
                    });
                  },
                ),
                SideMenuItem(
                    id: 3,
                    title: leaderboard.tr,
                    icon: Icons.leaderboard,
                    selected:
                        currentPage == MenuEntry.leaderboard ? true : false,
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        currentPage = MenuEntry.leaderboard;
                        body = const LeaderboardPage();
                      });
                    }),
                SideMenuItem(
                    id: 4,
                    title: settings.tr,
                    icon: Icons.settings,
                    selected: currentPage == MenuEntry.settings ? true : false,
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        currentPage = MenuEntry.settings;
                        body = const SettingsPage();
                      });
                    }),
              ],
              optionWidgets: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 7),
                          child: Icon(
                            Icons.sunny,
                            size: 20,
                          ),
                        ),
                        Text(lightModeKey.tr,
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold))
                      ],
                    ),
                    Switch(
                        value: Theme.of(context).brightness == Brightness.dark
                            ? true
                            : false,
                        onChanged: (value) {
                          Provider.of<ThemeProvider>(context, listen: false)
                              .toggleTheme(Theme.of(context).brightness);
                        }),
                    Row(
                      children: [
                        const Icon(
                          Icons.dark_mode,
                          size: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 7),
                          child: Text(nightModeKey.tr,
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton.icon(
                    onPressed: () async {
                      if (isLoggedIn) {
                        bool? result = await openDialog();
                        if (result != null) {
                          logOut(context);
                          if (result == true) {
                            var dbService = DatabaseService();
                            dbService.dropDB();
                            Provider.of<GoalProvider>(context, listen: false)
                                .nullifyGoal();
                          }
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const AppHome(title: appName)));
                        }
                      } else {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()));
                      }
                    },
                    icon:
                        Icon(isLoggedIn ? Icons.logout : Icons.login, size: 20),
                    label: Text(isLoggedIn ? logout.tr : login.tr,
                        style: const TextStyle(fontSize: 16)),
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(
                        const Size(
                          190,
                          40,
                        ),
                      ),
                      foregroundColor: MaterialStateProperty.all(Colors.black),
                      backgroundColor: MaterialStateProperty.all(isLoggedIn
                          ? greenBlue
                          : turquoiseBlue.withOpacity(0.7)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    )),
                const SizedBox(
                  height: 20,
                )
              ],
            );
          }
        },
      ),
      body: body,
    );
  }

  Future<bool?> openDialog() => showDialog(
      context: context,
      builder: (context) => Dialog(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).colorScheme.background,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    resetDataQuestion.tr,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(greenBlue),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          child: Text(no.tr,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white))),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(turquoiseBlue),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          child: Text(yes.tr,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white))),
                    ],
                  ),
                ],
              ),
            ),
          ));
}
