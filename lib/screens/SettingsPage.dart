import "package:flutter/material.dart";
import "package:one_hundred_push_ups/screens/AboutAppPage.dart";
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
              onTap: () {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: SettingsMenuItem(
              text: "Preferences",
              icon: Icons.tune,
              onTap: () {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: SettingsMenuItem(
              text: "Data center",
              icon: Icons.dataset_linked,
              onTap: () {},
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
