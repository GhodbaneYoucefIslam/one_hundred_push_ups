import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:one_hundred_push_ups/utils/translationConstants.dart';
import 'package:one_hundred_push_ups/widgets/FourDigitFormCell.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';
import '../AppHome.dart';
import '../models/Endpoints.dart';
import '../models/User.dart';
import '../models/UserProvider.dart';
import '../utils/constants.dart';
import '../widgets/CodeConfirmationPageGeneric.dart';

class CodeConfirmationPageForSignUp extends StatefulWidget {
  String email;
  String? fName, lName, password;
  Duration codeExpiresIn;
  CodeConfirmationPageForSignUp(
      {required this.email,
      required this.codeExpiresIn,
      this.fName,
      this.lName,
      this.password,
      super.key});

  @override
  State<CodeConfirmationPageForSignUp> createState() =>
      _CodeConfirmationPageForSignUpState();
}

class _CodeConfirmationPageForSignUpState
    extends State<CodeConfirmationPageForSignUp> {
  final formKey = GlobalKey<FormState>();
  late String digit1, digit2, digit3, digit4;
  late ValueNotifier<Duration> remainingTime;
  void startTimer(DateTime expiryTime) async {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!remainingTime.value.isNegative) {
        remainingTime.value = expiryTime.difference(DateTime.now());
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void initState() {
    remainingTime = ValueNotifier<Duration>(widget.codeExpiresIn);
    startTimer(DateTime.now().add(widget.codeExpiresIn));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CodeConfirmationPageGeneric(
        email: widget.email,
        codeExpiresIn: widget.codeExpiresIn,
        codeSendingFunction:
            sendOTPCodeForSignUp(widget.email, widget.fName!, widget.lName!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              toastification.show(
                  context: context,
                  title: Text(serverConnectionError.tr),
                  autoCloseDuration: const Duration(seconds: 2),
                  style: ToastificationStyle.simple,
                  alignment: const Alignment(0, 0.75));
            });
            return Center(
              child: Text(
                failedSendingCodeErrorMessage.tr,
                style: const TextStyle(
                    fontWeight: FontWeight.normal, fontSize: 20),
              ),
            );
          } else {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 25,
                        child:
                            SvgPicture.asset("assets/images/logo_black.svg")),
                    Text(
                      verifyRegistrationEmail.tr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Column(
                      children: [
                        Text(
                          "${verificationCodeSent.tr} ${widget.email}",
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.normal),
                          textAlign: TextAlign.center,
                        ),
                        ValueListenableBuilder(
                          valueListenable: remainingTime,
                          builder: (context, value, child) => Text(
                            !value.isNegative
                                ? "${codeExpiresIn.tr} ${value.inMinutes}:${(value.inSeconds - value.inMinutes * 60).toString().padLeft(2, "0")}"
                                : codeExpired.tr,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: darkBlue),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FourDigitFormCell(
                          height: 70,
                          width: 70,
                          onSaved: (value) {
                            digit1 = value!;
                          },
                        ),
                        FourDigitFormCell(
                          height: 70,
                          width: 70,
                          onSaved: (value) {
                            digit2 = value!;
                          },
                        ),
                        FourDigitFormCell(
                          height: 70,
                          width: 70,
                          onSaved: (value) {
                            digit3 = value!;
                          },
                        ),
                        FourDigitFormCell(
                          height: 70,
                          width: 70,
                          onSaved: (value) {
                            digit4 = value!;
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: ValueListenableBuilder(
                              valueListenable: remainingTime,
                              builder: (context, value, child) =>
                                  ElevatedButton(
                                      onPressed: () {
                                        if (value.isNegative) {
                                          remainingTime =
                                              ValueNotifier<Duration>(
                                                  widget.codeExpiresIn);
                                          setState(() {
                                            startTimer(DateTime.now()
                                                .add(widget.codeExpiresIn));
                                          });
                                        }
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                value.isNegative
                                                    ? turquoiseBlue
                                                    : grey),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      child: Text(resend.tr,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white)))),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: ElevatedButton(
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  formKey.currentState!.save();
                                  String otp =
                                      digit1 + digit2 + digit3 + digit4;
                                  String hash = snapshot.data!;
                                  bool? correct = await verifyOTPCode(
                                      widget.email, hash, otp);
                                  if (correct == true) {
                                    User? newUser = await postNewUser(
                                        widget.email,
                                        widget.fName!,
                                        widget.lName!,
                                        widget.password!);
                                    if (newUser != null) {
                                      final snackBar = SnackBar(
                                        content: Text(
                                          '${authenticationOf.tr} ${newUser.lastname} ${newUser.firstname} ${successfulWithId.tr}: ${newUser.id}!',
                                        ),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                      final myPrefs =
                                          await SharedPreferences.getInstance();
                                      //Keeping hold of new user for subsequent uses of the app
                                      myPrefs.setInt(userId, newUser.id!);
                                      myPrefs.setString(
                                          userEmail, newUser.email);
                                      myPrefs.setString(
                                          userFname, newUser.firstname);
                                      myPrefs.setString(
                                          userLname, newUser.lastname);
                                      myPrefs.setBool(
                                          userIsPublic, newUser.isPublic);
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
                                    }
                                  } else if (correct == false) {
                                    final snackBar = SnackBar(
                                      content: Text(
                                        incorrectOtpErrorMessage.tr,
                                      ),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                }
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
                              child: Text(confirm.tr,
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.white))),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          }
        });
  }
}
