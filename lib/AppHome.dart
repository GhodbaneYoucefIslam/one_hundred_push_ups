import 'package:flutter/material.dart';
import 'package:one_hundred_push_ups/screens/HomePage.dart';
import 'package:one_hundred_push_ups/screens/LeaderboardPage.dart';
import 'package:one_hundred_push_ups/screens/MyGoalsPage.dart';
import 'package:one_hundred_push_ups/screens/SettingsPage.dart';
import 'package:one_hundred_push_ups/widgets/SideMenu.dart';
import 'package:one_hundred_push_ups/widgets/SideMenuItem.dart';
import 'package:provider/provider.dart';
import 'models/UserProvider.dart';
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
  bool isDarkMode = false;




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
        appBar: AppBar(
          backgroundColor: lightBlue,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(widget.title,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        drawer: SideMenu(
          accountEmail: context.watch<UserProvider>().currentUser != null? context.watch<UserProvider>().currentUser!.email: "",
          accountName: context.watch<UserProvider>().currentUser != null? "${context.watch<UserProvider>().currentUser!.lastname} ${context.watch<UserProvider>().currentUser!.firstname}" : "Not logged in",
          avatar: Text(
            context.watch<UserProvider>().currentUser != null? context.watch<UserProvider>().currentUser!.initials(): "NLI",
            style: const TextStyle(fontSize: 20),
          ),
          menuEntries: [
            SideMenuItem(
              id: 1,
              title: "Home",
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
              title: "My goal",
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
                title: "Leaderboard",
                icon: Icons.leaderboard,
                selected: currentPage == MenuEntry.leaderboard ? true : false,
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    currentPage = MenuEntry.leaderboard;
                    body = const LeaderboardPage();
                  });
                }),
            SideMenuItem(
                id: 4,
                title: "Settings",
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
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 7),
                      child: Icon(
                        Icons.sunny,
                        size: 20,
                      ),
                    ),
                    Text("Light\nmode",
                        style:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.bold))
                  ],
                ),
                Switch(
                    value: isDarkMode,
                    onChanged: (value) {
                      setState(() {
                        isDarkMode = !isDarkMode;
                      });
                    }),
                const Row(
                  children: [
                    Icon(
                      Icons.dark_mode,
                      size: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 7),
                      child: Text("Night\nmode",
                          style: TextStyle(
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
                onPressed: () {},
                icon: const Icon(Icons.logout, size: 20),
                label: const Text("Lougout", style: TextStyle(fontSize: 16)),
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(
                    const Size(
                      190,
                      40,
                    ),
                  ),
                  foregroundColor: MaterialStateProperty.all(Colors.black),
                  backgroundColor:
                  MaterialStateProperty.all(grey.withOpacity(0.2)),
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
        ),
        body: body,
      );
    }
  }