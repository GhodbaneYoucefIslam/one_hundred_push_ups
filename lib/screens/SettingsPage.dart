import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:one_hundred_push_ups/screens/AboutAppPage.dart";
import "package:one_hundred_push_ups/screens/DataCenterPage.dart";
import "package:one_hundred_push_ups/screens/PersonalSettingsPage.dart";
import "package:one_hundred_push_ups/screens/PreferencesPage.dart";
import "package:one_hundred_push_ups/utils/translationConstants.dart";
import "package:one_hundred_push_ups/widgets/SettingsMenuItem.dart";

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 50),
            child: Text(settings.tr,
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: SettingsMenuItem(
              text: personal.tr,
              icon: Icons.person,
              onTap: () async {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const PersonalSettingsPage()));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: SettingsMenuItem(
                text: preferences.tr,
                icon: Icons.tune,
                onTap: () async {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const PreferencesPage()));
                }),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: SettingsMenuItem(
              text: dataCenter.tr,
              icon: Icons.dataset_linked,
              onTap: () async {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const DataCenterPage()));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: SettingsMenuItem(
              text: aboutApp.tr,
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
