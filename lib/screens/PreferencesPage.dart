import "package:flutter/material.dart";

import "../utils/constants.dart";
class PreferencesPage extends StatefulWidget {
  const PreferencesPage({super.key});

  @override
  State<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  bool areNotificationsOn = true;
  String currentLanguage = "English";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(left: 30, right: 30, bottom: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "In-App Preferences",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.25,
              decoration: BoxDecoration(
                color: grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    "Notifications",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.notifications_off,
                            size: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 7),
                            child: Text("Inactive",
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                      Switch(
                          value: areNotificationsOn,
                          onChanged: (value) {
                            setState(() {
                              areNotificationsOn = !areNotificationsOn;
                            });
                          }),
                      const Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 7),
                            child: Icon(
                              Icons.notifications_active,
                              size: 20,
                            ),
                          ),
                          Text("Active",
                              style:
                              TextStyle(fontSize: 13, fontWeight: FontWeight.bold))
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
              height: MediaQuery.of(context).size.height*0.25,
              decoration: BoxDecoration(
                color: grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    "Display Language",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(context: context, builder: (context) => Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        width: MediaQuery.of(context).size.width*0.95,
                        child: Column(
                          children: [
                            Column(
                              children: [
                                RadioMenuButton(
                                    value: "English",
                                    groupValue: currentLanguage,
                                    onChanged: (selectedLanguage){
                                      setState(() {
                                        currentLanguage = selectedLanguage!;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Text("English")
                                ),
                                RadioMenuButton(
                                    value: "Français",
                                    groupValue: currentLanguage,
                                    onChanged: (selectedLanguage){
                                      setState(() {
                                        currentLanguage = selectedLanguage!;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Text("Français")
                                )
                              ],
                            ),
                          ],
                        ),
                      ));
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(lightBlue),
                      shape:
                      MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        "Current Language : $currentLanguage \n (Tap to change)",
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
      ),
    );
  }
}
