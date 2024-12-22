import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:one_hundred_push_ups/models/Endpoints.dart";
import "package:one_hundred_push_ups/utils/translationConstants.dart";
import "package:provider/provider.dart";
import "package:shared_preferences/shared_preferences.dart";

import "../models/User.dart";
import "../models/UserProvider.dart";
import "../utils/constants.dart";
import "../widgets/LoadingIndicatorDialog.dart";
import "../widgets/RoundedTextFormField.dart";

class PersonalSettingsPage extends StatefulWidget {
  const PersonalSettingsPage({super.key});

  @override
  State<PersonalSettingsPage> createState() => _PersonalSettingsPageState();
}

class _PersonalSettingsPageState extends State<PersonalSettingsPage> {
  final formKey = GlobalKey<FormState>();
  String fName = "";
  String lName = "";
  bool visible = true;
  bool isLoggedIn = false;
  bool isDataLoaded = false;

  Future<void> loadUserCredentials() async {
    final myPrefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = myPrefs.getBool(userIsLoggedIn) ?? false;
      if (isLoggedIn) {
        fName = myPrefs.getString(userFname) ?? "";
        lName = myPrefs.getString(userLname) ?? "";
        visible = myPrefs.getBool(userIsPublic) ?? true;
      }
      isDataLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    loadUserCredentials();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: isDataLoaded
          ? (isLoggedIn
              ? buildSettingsForm(context)
              : buildNotLoggedInMessage())
          : const Center(child: CircularProgressIndicator()), // Show loader
    );
  }

  Widget buildSettingsForm(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            yourAccount.tr,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: BoxDecoration(
                color: grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      basicInfo.tr,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    RoundedTextFormField(
                      initialValue: fName,
                      hintText: firstName.tr,
                      hintTextSize: 17,
                      borderColor: grey,
                      selectedBorderColor: greenBlue,
                      borderRadius: 10,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return fNameEmptyErrorMessage.tr;
                        }
                        return null;
                      },
                      onSaved: (value) {
                        fName = value!;
                      },
                    ),
                    RoundedTextFormField(
                      initialValue: lName,
                      hintText: lastName.tr,
                      hintTextSize: 17,
                      borderColor: grey,
                      selectedBorderColor: greenBlue,
                      borderRadius: 10,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return lNameEmptyErrorMessage.tr;
                        }
                        return null;
                      },
                      onSaved: (value) {
                        lName = value!;
                      },
                    ),
                    Row(
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          activeColor: greenBlue,
                          value: visible,
                          onChanged: (value) {
                            setState(() {
                              visible = value!;
                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          side: MaterialStateBorderSide.resolveWith(
                            (states) => const BorderSide(
                                width: 1.0, color: Color(0xff9BAEBC)),
                          ),
                        ),
                        Text(
                          accountVisible.tr,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: ElevatedButton(
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            LoadingIndicatorDialog()
                                .show(context, text: processingRequest.tr);
                            int currentId = Provider.of<UserProvider>(context,
                                            listen: false)
                                        .currentUser !=
                                    null
                                ? Provider.of<UserProvider>(context,
                                        listen: false)
                                    .currentUser!
                                    .id!
                                : 1;
                            User? updatedUser = await changeUserPersonalDetails(
                                currentId, fName, lName, visible);

                            final myPrefs =
                                await SharedPreferences.getInstance();
                            myPrefs.setString(userFname, fName);
                            myPrefs.setString(userLname, lName);
                            myPrefs.setBool(userIsPublic, true);
                            Provider.of<UserProvider>(context, listen: false)
                                .initUserFromPrefs();
                            LoadingIndicatorDialog().dismiss();
                            if (updatedUser != null) {
                              final snackBar = SnackBar(
                                content: Text(
                                  '${modificationResults.tr}: $updatedUser',
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(greenBlue),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        child: Text(
                          saveChanges.tr,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNotLoggedInMessage() {
    return Center(
      child: Text(
        notLoggedIn.tr,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
      ),
    );
  }
}
