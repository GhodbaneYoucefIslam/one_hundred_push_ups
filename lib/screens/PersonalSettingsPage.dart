import "package:flutter/material.dart";

import "../utils/constants.dart";
import "../widgets/RoundedTextFormField.dart";

class PersonalSettingsPage extends StatefulWidget {
  const PersonalSettingsPage({super.key});

  @override
  State<PersonalSettingsPage> createState() => _PersonalSettingsPageState();
}

class _PersonalSettingsPageState extends State<PersonalSettingsPage> {
  final formKey = GlobalKey<FormState>();
  String fName = "YoucefIslam";
  String lName = "Ghodbane";
  bool visible = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Your account",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.7 ,
                decoration: BoxDecoration(
                    color: grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10)),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Basic info",
                        style: TextStyle(fontSize: 20
                            , fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      RoundedTextFormField(
                        initialValue: fName,
                        hintText: "First name",
                        hintTextSize: 17,
                        borderColor: grey,
                        selectedBorderColor: greenBlue,
                        borderRadius: 10,
                        validator: (value){
                          if (value == null || value.isEmpty) {
                            return 'First name cannot be empty';
                          }
                          return null;
                        },
                        onSaved: (value){
                          fName = value!;
                        },
                      ),
                      RoundedTextFormField(
                        initialValue: lName,
                        hintText: "Last time",
                        hintTextSize: 17,
                        borderColor: grey,
                        selectedBorderColor: greenBlue,
                        borderRadius: 10,
                        validator: (value){
                          if (value == null || value.isEmpty) {
                            return 'Last name cannot be empty';
                          }
                          return null;
                        },
                        onSaved: (value){
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
                                visible=value!;
                              });
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            side: MaterialStateBorderSide.resolveWith(
                                  (states) =>
                              const BorderSide(width: 1.0, color: Color(0xff9BAEBC)),
                            ),
                          ),
                          const Text(
                            'Account visible in rankings leaderboard',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: ElevatedButton(
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              if(formKey.currentState!.validate()){
                                formKey.currentState!.save();
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
                            child: const Text("Save changes",
                                style: TextStyle(fontSize: 16, color: Colors.black))),
                      ),
                      Text(
                        "Credentials",
                        style: TextStyle(fontSize: 20
                            , fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: ElevatedButton(
                            onPressed: () {},
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  turquoiseBlue.withOpacity(0.7)),
                              shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            child: const Text("Change email",
                                style: TextStyle(fontSize: 16, color: Colors.white))),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: ElevatedButton(
                            onPressed: () {},
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  turquoiseBlue.withOpacity(0.7)),
                              shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            child: const Text("Change password",
                                style: TextStyle(fontSize: 16, color: Colors.white))),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}
