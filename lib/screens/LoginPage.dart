import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:one_hundred_push_ups/AppHome.dart";
import "package:one_hundred_push_ups/models/Endpoints.dart";
import "package:one_hundred_push_ups/screens/SignUpPage.dart";
import "package:one_hundred_push_ups/widgets/RoundedTextFormField.dart";
import "package:provider/provider.dart";
import "package:shared_preferences/shared_preferences.dart";

import "../models/User.dart";
import "../models/UserProvider.dart";
import "../utils/constants.dart";
import "../utils/methods.dart";
import "../widgets/LoadingIndicatorDialog.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  bool passwordVisible = false;
  late String email, password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 25,
                        child: SvgPicture.asset("assets/images/logo.svg")),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Welcome to  ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Text(
                          appName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: lightBlue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  "Login now",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                RoundedTextFormField(
                  hintText: "Enter Your email",
                  hintTextSize: 17,
                  borderColor: grey,
                  selectedBorderColor: greenBlue,
                  borderRadius: 10,
                  validator: (value) => validateEmail(value),
                  onSaved: (value) {
                    email = value!;
                  },
                ),
                RoundedTextFormField(//todo: hide password
                  hintText: "Enter Your password",
                  hintTextSize: 17,
                  borderColor: grey,
                  selectedBorderColor: greenBlue,
                  borderRadius: 10,
                  obscureText: !passwordVisible,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password cannot be empty';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    password = value!;
                  },
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordVisible? Icons.visibility_off: Icons.visibility
                    ),
                    onPressed: () {
                      setState(() {
                        passwordVisible = ! passwordVisible;
                      });
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        //todo : implement forgot password
                      },
                      child: Text(
                        'Forgot password ?',
                        style: TextStyle(
                          fontSize: 17,
                          color: grey,
                        ),
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
                              .show(context, text: "Verifying credentials");
                          User? user =
                              await loginWithEmailAndPassword(email, password);
                          LoadingIndicatorDialog().dismiss();
                          if (user != null) {
                            if (user.id != -1) {
                              final snackBar = SnackBar(
                                content: Text(
                                  'Login of ${user.lastname} ${user.firstname} successful with id:${user.id}!',
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              final myPrefs =
                                  await SharedPreferences.getInstance();
                              //Keeping hold of new user for subsequent uses of the app
                              myPrefs.setInt(userId, user.id!);
                              myPrefs.setString(userEmail, user.email);
                              myPrefs.setString(userFname, user.firstname);
                              myPrefs.setString(userLname, user.lastname);
                              myPrefs.setBool(userIsLoggedIn, true);
                              Provider.of<UserProvider>(context, listen: false)
                                  .initUserFromPrefs();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AppHome(title: appName)));
                            } else {
                              const snackBar = SnackBar(
                                content: Text(
                                  'Invalid credentials!',
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          } else {
                            const snackBar = SnackBar(
                              content: Text(
                                'Error connecting to server, please try again later',
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
                      child: const Text("Login",
                          style: TextStyle(fontSize: 16, color: Colors.white))),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        indent: 10,
                        endIndent: 10,
                        thickness: 1,
                        color: darkBlue,
                      ),
                    ),
                    Text(
                      'or',
                      style: TextStyle(
                        fontSize: 16,
                        color: darkBlue,
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        indent: 10,
                        endIndent: 10,
                        thickness: 1,
                        color: darkBlue,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    //todo : implement sign in with google
                  },
                  child: Container(
                    width: 350,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xffD9D9D9))),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.g_mobiledata_rounded,
                          size: 40,
                        ),
                        Text(
                          'Login with google',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don’t have an account?  ',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpPage()));
                      },
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                            fontSize: 17,
                            color: greenBlue,
                            decoration: TextDecoration.underline,
                            decorationColor: greenBlue),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    bool? result = await openDialog();
                    if(result == true){
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                              const AppHome(title: appName)));
                    }
                  },
                  child: Text(
                    'Continue without an account',
                    style: TextStyle(
                      fontSize: 15,
                      color: grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> openDialog() => showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                "Proceed without an account?\n"
                    "You won't have access to all of 100PushUps's features",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                      child: const Text("No",
                          style: TextStyle(
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
                      child: const Text("Yes",
                          style: TextStyle(
                              fontSize: 16, color: Colors.white))),
                ],
              ),
            ],
          ),
        ),
      ));
}
