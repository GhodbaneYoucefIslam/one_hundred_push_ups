import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:get/get.dart";
import "package:one_hundred_push_ups/models/Endpoints.dart";
import "package:one_hundred_push_ups/screens/LoginPage.dart";
import "package:one_hundred_push_ups/utils/translationConstants.dart";
import "package:one_hundred_push_ups/widgets/RoundedTextFormField.dart";
import "package:shared_preferences/shared_preferences.dart";
import "../models/User.dart";
import "../utils/constants.dart";
import "../widgets/LoadingIndicatorDialog.dart";

class ChangePasswordPage extends StatefulWidget {
  final String email;
  const ChangePasswordPage({required this.email, super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final formKey = GlobalKey<FormState>();
  bool accept = false;
  late String password, confirmedPassword;
  bool passwordVisible = false;
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
                SizedBox(
                    width: 25,
                    child: SvgPicture.asset("assets/images/logo_black.svg")),
                Column(
                  children: [
                    Text(
                      changedPasswordFor.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.email,
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.normal),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                Column(
                  children: [
                    RoundedTextFormField(
                      hintText: passwordField.tr,
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
                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.025,
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
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: ElevatedButton(
                      onPressed: () async{
                        FocusScope.of(context).unfocus();
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          if (password == confirmedPassword) {
                            LoadingIndicatorDialog().show(context, text: changingPassword.tr);
                            User? updatedUser = await changeUserPassword(widget.email, password);
                            LoadingIndicatorDialog().dismiss();
                              if (updatedUser != null) {
                                final snackBar = SnackBar(
                                  content: Text(
                                    '${changedPasswordFor.tr} ${updatedUser.lastname} ${updatedUser.firstname} ${successfulWithId.tr}: ${updatedUser.id}!',
                                  ),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        const LoginPage()));
                              }else{
                                final snackBar = SnackBar(
                                  content: Text(
                                    errorChangingPasswordErrorMessage.tr,
                                  ),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                          } else {
                            final snackBar = SnackBar(
                              content: Text(
                                pleaseConfirmPassword.tr,
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
                      child: Text(changePassword.tr,
                          style: TextStyle(fontSize: 16, color: Colors.white))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
