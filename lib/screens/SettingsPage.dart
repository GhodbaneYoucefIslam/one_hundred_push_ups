import "dart:convert";

import "package:flutter/material.dart";
import "package:one_hundred_push_ups/database/LocalDB.dart";
import "package:one_hundred_push_ups/models/Goal.dart";
import "package:one_hundred_push_ups/models/StorageHelper.dart";
import "package:one_hundred_push_ups/screens/AboutAppPage.dart";
import "package:one_hundred_push_ups/screens/DataCenterPage.dart";
import "package:one_hundred_push_ups/widgets/SettingsMenuItem.dart";

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 50),
            child: Text("Settings",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: SettingsMenuItem(
              text: "Personal",
              icon: Icons.person,
              onTap: () async {
                StorageHelper.readStringFromFile("Goals.txt").then((value) {
                  print("File contents: $value");
                  List<dynamic> jsonValue = jsonDecode(value);
                  List<Goal> goals = jsonValue.map((map) => Goal.fromMap(Map<String, dynamic>.from(map))).toList();
                  print("There are ${goals.length} goals from file");
                  for(Goal goal in goals){
                    print(goal.toString());
                  }
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: SettingsMenuItem(
              text: "Preferences",
              icon: Icons.tune,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DataCenterPage()));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: SettingsMenuItem(
              text: "Data center",
              icon: Icons.dataset_linked,
              onTap: () async {
                var db = LocalDB();
                List<Goal> goalsInDB = await db.fetchAllGoals();
                List<Map<String, dynamic>> goalsMapList = goalsInDB.map((goal) => goal.toMap()).toList();
                String jsonContents = jsonEncode(goalsMapList);
                StorageHelper.writeStringToFile("Goals.txt", jsonContents).then((value) {
                  print("File created");
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: SettingsMenuItem(
              text: "About App",
              icon: Icons.info,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AboutAppPage(index: 0)));
              },
            ),
          ),
        ],
      ),
    );
  }
}
