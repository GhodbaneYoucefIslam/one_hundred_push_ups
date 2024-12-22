import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:get/get.dart";
import "package:one_hundred_push_ups/AppHome.dart";
import "package:one_hundred_push_ups/models/Endpoints.dart";
import "package:one_hundred_push_ups/screens/CodeConfirmationPageForForgotPassword.dart";
import "package:one_hundred_push_ups/screens/SignUpPage.dart";
import "package:one_hundred_push_ups/utils/translationConstants.dart";
import "package:one_hundred_push_ups/widgets/RoundedTextFormField.dart";
import "package:provider/provider.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:toastification/toastification.dart";
import "../models/GoogleSignInApi.dart";
import "../models/User.dart";
import "../models/UserProvider.dart";
import "../utils/constants.dart";
import "../utils/methods.dart";
import "../widgets/LoadingIndicatorDialog.dart";
import "../widgets/RoundedTextField.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final myController = TextEditingController();
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
                        child: SvgPicture.asset(Theme.of(context).brightness == Brightness.dark ? "assets/images/logo_white.svg":"assets/images/logo_black.svg")),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${welcome.tr}  ",
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
                  loginNow.tr,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                RoundedTextFormField(
                  hintText: enterEmail.tr,
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
                  hintText: enterPassword.tr,
                  hintTextSize: 17,
                  borderColor: grey,
                  selectedBorderColor: greenBlue,
                  borderRadius: 10,
                  obscureText: !passwordVisible,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return passwordNotEmptyMessage.tr;
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
                      onTap: () async{
                        var result = await openDialogForForgetPassword();
                        String emailForForgotPassword = result!;
                        resetPassword(emailForForgotPassword);
                      },
                      child: Text(
                        forgotPassword.tr,
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
                              .show(context, text: verifyingCredentials.tr);
                          User? user =
                              await loginWithEmailAndPassword(email, password);
                          LoadingIndicatorDialog().dismiss();
                          if (user != null) {
                            if (user.id != -1) {
                              final snackBar = SnackBar(
                                content: Text(
                                  '${authenticationOf.tr} ${user.lastname} ${user.firstname} ${successfulWithId.tr}:${user.id}!',
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
                              myPrefs.setBool(userIsPublic, user.isPublic);
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
                                  invalidCredentials.tr,
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          } else {
                            final snackBar = SnackBar(
                              content: Text(
                                serverConnectionError.tr,
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
                      child: Text(login.tr,
                          style: TextStyle(fontSize: 16, color: Colors.white))),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        indent: 10,
                        endIndent: 10,
                        thickness: 1,
                        color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).colorScheme.onBackground : darkBlue,
                      ),
                    ),
                    Text(
                      or.tr,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).colorScheme.onBackground : darkBlue,
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        indent: 10,
                        endIndent: 10,
                        thickness: 1,
                        color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).colorScheme.onBackground : darkBlue,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () async{
                    String lName, fName;
                    final user = await GoogleSignInApi.login();
                    if (user != null){
                      String fullName = user.displayName.toString();
                      email =  user.email;
                      List<String> names = fullName.split(" ");
                      lName = names[names.length-1];
                      if (names.length >= 2){
                        names.remove(lName);
                        fName = names.join(" ");
                      }else{
                        fName= "";
                      }
                      print("user: ${fName} $lName $email");
                      LoadingIndicatorDialog().show(context, text: loggingIn.tr);
                      final loggedInUser = await loginOrSignUpWithGoogle(email, fName, lName);
                      LoadingIndicatorDialog().dismiss();
                      if(loggedInUser != null){
                        if (loggedInUser.id!= -1){
                          final snackBar = SnackBar(
                            content: Text(
                              '${authenticationOf.tr} ${loggedInUser.lastname} ${loggedInUser.firstname} ${successfulWithId.tr}:${loggedInUser.id}!',
                            ),
                          );
                          ScaffoldMessenger.of(context)
                              .showSnackBar(snackBar);
                          final myPrefs =
                          await SharedPreferences
                              .getInstance();
                          //Keeping hold of new user for subsequent uses of the app
                          myPrefs.setInt(userId, loggedInUser.id!);
                          myPrefs.setString(
                              userEmail, loggedInUser.email);
                          myPrefs.setString(
                              userFname, loggedInUser.firstname);
                          myPrefs.setString(
                              userLname, loggedInUser.lastname);
                          myPrefs.setBool(userIsPublic, loggedInUser.isPublic);
                          myPrefs.setBool(userIsLoggedIn, true);
                          Provider.of<UserProvider>(context,
                              listen: false)
                              .initUserFromPrefs();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                  const AppHome(
                                      title: appName)));
                        }else{
                          final snackBar = SnackBar(
                            content: Text(
                              notConnectedWithGoogleErrorMessage.tr,
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      }else{
                        final snackBar = SnackBar(
                          content: Text(
                            serverConnectionError.tr,
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    }else{
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
                        Icon(
                          Icons.g_mobiledata_rounded,
                          size: 40,
                        ),
                        Text(
                          continueWithGoogle.tr,
                          style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).colorScheme.onBackground : Colors.black,
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
                      dontHaveAccount.tr+" ",
                      style: TextStyle(
                        fontSize: 17,
                        color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).colorScheme.onBackground : Colors.black,
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
                        signUpKey.tr,
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
                    bool? result = await openDialogForProceedingWithoutAccount();
                    if(result == true){
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                              const AppHome(title: appName)));
                    }
                  },
                  child: Text(
                    continueWithoutAccount.tr,
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

  void resetPassword(String email) async{
    //see if email is associated to an account
    LoadingIndicatorDialog().show(context, text: verifyingEmail.tr);
    bool? emailDoesntExists = await isEmailNotPreviouslyUsed(email);
    LoadingIndicatorDialog().dismiss();
    if (emailDoesntExists==false){
      //take user to confirmation screen
      Navigator.push(context, MaterialPageRoute(builder: (context)=>CodeConfirmationPageForForgotPassword(email: email, codeExpiresIn: const Duration(minutes: 5))));
    }else if(emailDoesntExists == true){
      final snackBar = SnackBar(
        content: Text(
          noAccountForEmailErrorMessage.tr,
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }else{
      final snackBar = SnackBar(
        content: Text(
          serverConnectionError.tr,
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<String?> openDialogForForgetPassword() => showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).colorScheme.background,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                pleaseProvideEmail.tr,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                width: 220,
                child: RoundedTextField(
                  hintText: enterEmail.tr,
                  hintTextSize: 10,
                  borderColor: grey,
                  selectedBorderColor: greenBlue,
                  controller: myController,
                  borderRadius: 10,
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    String? validationResult = validateEmail(myController.text);
                    if (validationResult == null) {
                      Navigator.of(context).pop(myController.text);
                      myController.text = "";
                    } else {
                      toastification.show(
                          context: context,
                          title: Text(validationResult),
                          autoCloseDuration: const Duration(seconds: 2),
                          style: ToastificationStyle.simple,
                          alignment: const Alignment(0, 0.75));
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
                  child: Text(confirm.tr,
                      style: TextStyle(fontSize: 16, color: Colors.white))),
            ],
          ),
        ),
      ));

  Future<bool?> openDialogForProceedingWithoutAccount() => showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).colorScheme.background,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                proceedWithoutAccountWarningMessage.tr,
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
                      child: Text(no.tr,
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
                      child: Text(yes.tr,
                          style: TextStyle(
                              fontSize: 16, color: Colors.white))),
                ],
              ),
            ],
          ),
        ),
      ));
}
