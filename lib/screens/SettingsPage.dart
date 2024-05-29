import "dart:convert";
import "package:flutter/material.dart";
import "package:one_hundred_push_ups/database/LocalDB.dart";
import "package:one_hundred_push_ups/models/Goal.dart";
import "package:one_hundred_push_ups/models/StorageHelper.dart";
import "package:one_hundred_push_ups/screens/AboutAppPage.dart";
import "package:one_hundred_push_ups/screens/DataCenterPage.dart";
import "package:one_hundred_push_ups/widgets/SettingsMenuItem.dart";
import 'package:csv/csv.dart';
import 'dart:io';

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
                StorageHelper.readStringFromFile("Sets.txt").then((value) {
                  print("File contents are: $value");
                  /*List<dynamic> jsonValue = jsonDecode(value);
                  List<Goal> goals = jsonValue.map((map) => Goal.fromMap(Map<String, dynamic>.from(map))).toList();
                  print("There are ${goals.length} goals from file");
                  for(Goal goal in goals){
                    print(goal.toString());
                  }*/
                });
                /*final input = File(
                        '/storage/emulated/0/Android/data/com.example.one_hundred_push_ups/files/Sets.txt')
                    .openRead();
                final fields = await input
                    .transform(utf8.decoder)
                    .transform(CsvToListConverter(eol: '\n'))
                    .toList();
                print(fields.length);
                print(fields.toString());*/
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: SettingsMenuItem(
              text: "Preferences",
              icon: Icons.tune,
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => DataCenterPage()));
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
                List<Map<String, dynamic>> goalsMapList =
                    goalsInDB.map((goal) => goal.toMap()).toList();
                //String jsonContents = jsonEncode(goalsMapList);
                String csvContents = "";
                //convert the list of maps to a csv format
                //first we get the keys of the map to be used as column names in our csv
                List<String> mapKeys = goalsMapList[0].keys.toList();
                int numberOfColumns = mapKeys.length;
                print("number of keys: $numberOfColumns");
                for (int i = 0; i <= numberOfColumns - 2; i++) {
                  csvContents = "${csvContents + mapKeys[i]},";
                }
                //writing last key with an end of line
                csvContents = "${csvContents + mapKeys.last}\n";

                //now we write the actual values
                for (Map<String, dynamic> map in goalsMapList) {
                  for (int i = 0; i <= numberOfColumns - 2; i++) {
                    csvContents =
                        "${csvContents + map[mapKeys[i]].toString()},";
                  }
                  //writing last value with an end of line
                  csvContents =
                      "${csvContents + map[mapKeys.last].toString()}\n";
                }
                print("csv : $csvContents");
                StorageHelper.writeStringToFile("GoalsCSV.txt", csvContents, context)
                    .then((value) {
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
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AboutAppPage(index: 0)));
              },
            ),
          ),
        ],
      ),
    );
  }
}
