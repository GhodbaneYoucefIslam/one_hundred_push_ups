import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:one_hundred_push_ups/models/Endpoints.dart";
import "package:one_hundred_push_ups/screens/LoginPage.dart";
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
                    child: SvgPicture.asset("assets/images/logo.svg")),
                Column(
                  children: [
                    Text(
                      "Change password for",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${widget.email}",
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.normal),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                Column(
                  children: [
                    RoundedTextFormField(
                      hintText: "Password",
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
                          return 'Password cannot be empty';
                        } else if (value.toString().length < 4) {
                          return 'Password cannot contain less than 4 characters';
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
                      hintText: "Confirm password",
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
                          return 'Confirmed password cannot be empty';
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
                            LoadingIndicatorDialog().show(context, text: "Changing password");
                            User? updatedUser = await changeUserPassword(widget.email, password);
                            LoadingIndicatorDialog().dismiss();
                              if (updatedUser != null) {
                                final snackBar = SnackBar(
                                  content: Text(
                                    'Changed password successfully for ${updatedUser.lastname} ${updatedUser.firstname} successful with id:${updatedUser.id}!',
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
                                const snackBar = SnackBar(
                                  content: Text(
                                    'Error changing password',
                                  ),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                          } else {
                            const snackBar = SnackBar(
                              content: Text(
                                'Please confirm your password',
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
                      child: const Text("Change password",
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
