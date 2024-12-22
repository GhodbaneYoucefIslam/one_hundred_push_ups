import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:get/get.dart";
import "package:one_hundred_push_ups/AppHome.dart";
import "package:one_hundred_push_ups/models/GoogleSignInApi.dart";
import "package:one_hundred_push_ups/screens/AboutAppPage.dart";
import "package:one_hundred_push_ups/screens/LoginPage.dart";
import "package:one_hundred_push_ups/utils/translationConstants.dart";
import "package:one_hundred_push_ups/widgets/RoundedTextFormField.dart";
import "package:one_hundred_push_ups/models/Endpoints.dart";
import "package:provider/provider.dart";
import "package:shared_preferences/shared_preferences.dart";

import "../models/UserProvider.dart";
import "../utils/constants.dart";
import "../utils/methods.dart";
import "../widgets/LoadingIndicatorDialog.dart";
import "CodeConfirmationPageForSignUp.dart";

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();
  bool accept = false;
  late String fName, lName, email, password, confirmedPassword;
  bool passwordVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
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
                        child: SvgPicture.asset(
                            Theme.of(context).brightness == Brightness.dark
                                ? "assets/images/logo_white.svg"
                                : "assets/images/logo_black.svg")),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          welcome.tr,
                          style: const TextStyle(
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
                  createAccount.tr,
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold),
                ),
                RoundedTextFormField(
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
                RoundedTextFormField(
                  hintText: emailField.tr,
                  hintTextSize: 17,
                  borderColor: grey,
                  selectedBorderColor: greenBlue,
                  borderRadius: 10,
                  validator: (value) => validateEmail(value),
                  onSaved: (value) {
                    email = value!;
                  },
                ),
                RoundedTextFormField(
                  hintText: passwordField,
                  hintTextSize: 17,
                  borderColor: grey,
                  selectedBorderColor: greenBlue,
                  borderRadius: 10,
                  obscureText: !passwordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(passwordVisible
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return passwordNotEmptyMessage.tr;
                    } else if (value.toString().length < 4) {
                      return minCharactersErrorMessage.tr;
                    }
                    return null;
                  },
                  onSaved: (value) {
                    password = value!;
                  },
                ),
                RoundedTextFormField(
                  hintText: confirmPassword.tr,
                  hintTextSize: 17,
                  borderColor: grey,
                  selectedBorderColor: greenBlue,
                  borderRadius: 10,
                  obscureText: !passwordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(passwordVisible
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return confirmedPasswordEmptyErrorMessage.tr;
                    }
                    return null;
                  },
                  onSaved: (value) {
                    confirmedPassword = value!;
                  },
                ),
                Row(
                  children: [
                    Checkbox(
                      checkColor: Colors.white,
                      activeColor: greenBlue,
                      value: accept,
                      onChanged: (value) {
                        setState(() {
                          accept = value!;
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
                      "${iAccept.tr} ",
                      style: TextStyle(
                        fontSize: 17,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Theme.of(context).colorScheme.onBackground
                            : Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AboutAppPage(index: 1)));
                      },
                      child: Text(
                        terms.tr,
                        style: TextStyle(
                            fontSize: 17,
                            color: greenBlue,
                            decoration: TextDecoration.underline,
                            decorationColor: greenBlue),
                      ),
                    ),
                    Text(
                      " ${and.tr} ",
                      style: TextStyle(
                        fontSize: 17,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Theme.of(context).colorScheme.onBackground
                            : Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AboutAppPage(index: 1)));
                      },
                      child: Text(
                        conditions.tr,
                        style: TextStyle(
                            fontSize: 17,
                            color: greenBlue,
                            decoration: TextDecoration.underline,
                            decorationColor: greenBlue),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: ElevatedButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          if (accept) {
                            if (password == confirmedPassword) {
                              signUp(fName, lName, email, password);
                            } else {
                              final snackBar = SnackBar(
                                content: Text(
                                  pleaseConfirmPassword.tr,
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          } else {
                            final snackBar = SnackBar(
                              content: Text(
                                termsMustBeAcceptedErrorMessage.tr,
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
                      child: Text(signUpKey.tr,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white))),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        indent: 10,
                        endIndent: 10,
                        thickness: 1,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Theme.of(context).colorScheme.onBackground
                            : darkBlue,
                      ),
                    ),
                    Text(
                      or.tr,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Theme.of(context).colorScheme.onBackground
                            : darkBlue,
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        indent: 10,
                        endIndent: 10,
                        thickness: 1,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Theme.of(context).colorScheme.onBackground
                            : darkBlue,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    final user = await GoogleSignInApi.login();
                    if (user != null) {
                      String fullName = user.displayName.toString();
                      email = user.email;
                      List<String> names = fullName.split(" ");
                      lName = names[names.length - 1];
                      if (names.length >= 2) {
                        names.remove(lName);
                        fName = names.join(" ");
                      } else {
                        fName = "";
                      }
                      LoadingIndicatorDialog()
                          .show(context, text: loggingIn.tr);
                      final loggedInUser =
                          await loginOrSignUpWithGoogle(email, fName, lName);
                      LoadingIndicatorDialog().dismiss();
                      if (loggedInUser != null) {
                        if (loggedInUser.id != -1) {
                          final snackBar = SnackBar(
                            content: Text(
                              '${authenticationOf.tr} ${loggedInUser.lastname} ${loggedInUser.firstname} ${successfulWithId.tr}:${loggedInUser.id}!',
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          final myPrefs = await SharedPreferences.getInstance();
                          //Keeping hold of new user for subsequent uses of the app
                          myPrefs.setInt(userId, loggedInUser.id!);
                          myPrefs.setString(userEmail, loggedInUser.email);
                          myPrefs.setString(userFname, loggedInUser.firstname);
                          myPrefs.setString(userLname, loggedInUser.lastname);
                          myPrefs.setBool(userIsPublic, loggedInUser.isPublic);
                          myPrefs.setBool(userIsLoggedIn, true);
                          Provider.of<UserProvider>(context, listen: false)
                              .initUserFromPrefs();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const AppHome(title: appName)));
                        } else {
                          final snackBar = SnackBar(
                            content: Text(
                              notConnectedWithGoogleErrorMessage.tr,
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      } else {
                        final snackBar = SnackBar(
                          content: Text(
                            serverConnectionError.tr,
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    } else {
                      final snackBar = SnackBar(
                        content: Text(
                          googleFailed.tr,
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: Container(
                    width: 350,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xffD9D9D9))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.g_mobiledata_rounded,
                          size: 40,
                        ),
                        Text(
                          continueWithGoogle.tr,
                          style: TextStyle(
                            fontSize: 20,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Theme.of(context).colorScheme.onBackground
                                    : Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${alreadyHaveAccount.tr} ",
                      style: TextStyle(
                        fontSize: 17,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Theme.of(context).colorScheme.onBackground
                            : Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()));
                      },
                      child: Text(
                        login.tr,
                        style: TextStyle(
                            fontSize: 17,
                            color: greenBlue,
                            decoration: TextDecoration.underline,
                            decorationColor: greenBlue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void signUp(String fName, String lName, String email, String password) async {
    //see if email available
    LoadingIndicatorDialog().show(context, text: verifyingEmail.tr);
    bool? availableEmail = await isEmailNotPreviouslyUsed(email);
    LoadingIndicatorDialog().dismiss();
    if (availableEmail == true) {
      //take user to confirmation screen
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CodeConfirmationPageForSignUp(
                    email: email,
                    fName: fName,
                    lName: lName,
                    password: password,
                    codeExpiresIn: const Duration(minutes: 5),
                  )));
    } else if (availableEmail == false) {
      final snackBar = SnackBar(
        content: Text(
          emailUsedErrorMessage.tr,
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final snackBar = SnackBar(
        content: Text(
          serverConnectionError.tr,
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
