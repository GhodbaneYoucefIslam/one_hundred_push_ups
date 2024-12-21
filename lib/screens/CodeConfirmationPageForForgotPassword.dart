import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:one_hundred_push_ups/screens/ChangePasswordPage.dart';
import 'package:one_hundred_push_ups/utils/translationConstants.dart';
import 'package:toastification/toastification.dart';
import '../models/Endpoints.dart';
import '../utils/constants.dart';
import '../widgets/CodeConfirmationPageGeneric.dart';
import '../widgets/FourDigitFormCell.dart';

class CodeConfirmationPageForForgotPassword extends StatefulWidget {
  String email;
  Duration codeExpiresIn;
  CodeConfirmationPageForForgotPassword(
      {required this.email, required this.codeExpiresIn, super.key});

  @override
  State<CodeConfirmationPageForForgotPassword> createState() =>
      _CodeConfirmationPageForForgotPasswordState();
}

class _CodeConfirmationPageForForgotPasswordState
    extends State<CodeConfirmationPageForForgotPassword> {
  final formKey = GlobalKey<FormState>();
  late String digit1, digit2, digit3, digit4;
  late ValueNotifier<Duration> remainingTime;
  void startTimer(DateTime expiryTime) async {
    Timer timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
        codeSendingFunction: sendOTPCodeForForgotPassword(widget.email),
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
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
              ),
            );
          } else {
            return Container(
              width: MediaQuery.of(context).size.width,
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 25,
                        child: SvgPicture.asset("assets/images/logo.svg")),
                    Text(
                      verifyPasswordReset.tr,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Column(
                      children: [
                        Text(
                          "${verificationCodeSent.tr} ${widget.email}",
                          style: TextStyle(
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
                                          style: TextStyle(
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
                                  print(
                                      "hash is : " + snapshot.data.toString());
                                  bool? correct = await verifyOTPCode(
                                      widget.email, hash, otp);
                                  if (correct == true) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ChangePasswordPage(
                                                    email: widget.email)));
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
                                  style: TextStyle(
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
