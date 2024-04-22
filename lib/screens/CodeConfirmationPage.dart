import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:one_hundred_push_ups/models/Endpoints.dart';
import 'package:one_hundred_push_ups/utils/constants.dart';
import 'package:toastification/toastification.dart';

class CodeConfirmationPage extends StatefulWidget {
  final String email, fName, lName, password;
  const CodeConfirmationPage(
      {required this.email,
      required this.fName,
      required this.lName,
      required this.password,
      super.key});

  @override
  State<CodeConfirmationPage> createState() => _CodeConfirmationPageState();
}

class _CodeConfirmationPageState extends State<CodeConfirmationPage> {
  final formKey = GlobalKey<FormState>();
  late String digit1, digit2, digit3, digit4;
  late ValueNotifier<Duration> remainingTime;
  void startTimer(DateTime expiryTime) async {
    Timer timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!remainingTime.value.isNegative) {
        remainingTime.value = expiryTime.difference(DateTime.now());
      }
    });
  }

  @override
  void initState() {
    remainingTime = ValueNotifier<Duration>(const Duration(minutes: 5));
    startTimer(DateTime.now().add(const Duration(minutes: 5)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: FutureBuilder(
            future: sendOTPCode(widget.email, widget.fName, widget.lName),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  toastification.show(
                      context: context,
                      title: const Text("Error connecting to server"),
                      autoCloseDuration: const Duration(seconds: 2),
                      style: ToastificationStyle.simple,
                      alignment: const Alignment(0, 0.75));
                });
                return const Center(
                  child: Text(
                    "Failed sending verification code, please go to previous page",
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
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
                        Text(
                          "Verify email address",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        Column(
                          children: [
                            Text(
                              "A verification code has been sent to ${widget.email}",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.normal),
                              textAlign: TextAlign.center,
                            ),
                            ValueListenableBuilder(
                              valueListenable: remainingTime,
                              builder: (context, value, child) => Text(
                                !value.isNegative
                                    ? "Code expires in ${value.inMinutes}:${value.inSeconds - value.inMinutes * 60}"
                                    : "Code expired click resend",
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
                            SizedBox(
                              height: 70,
                              width: 70,
                              child: TextFormField(
                                style: Theme.of(context).textTheme.titleLarge,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                  filled: false,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                        width: 2, color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide:
                                        BorderSide(width: 1, color: greenBlue),
                                  ),
                                ),
                                onChanged: (value) {
                                  if (value.length == 1) {
                                    FocusScope.of(context).nextFocus();
                                  }
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'cannot be empty';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  digit1 = value!;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 70,
                              width: 70,
                              child: TextFormField(
                                style: Theme.of(context).textTheme.titleLarge,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                  filled: false,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                        width: 2, color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide:
                                        BorderSide(width: 1, color: greenBlue),
                                  ),
                                ),
                                onChanged: (value) {
                                  if (value.length == 1) {
                                    FocusScope.of(context).nextFocus();
                                  }
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'cannot be empty';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  digit2 = value!;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 70,
                              width: 70,
                              child: TextFormField(
                                style: Theme.of(context).textTheme.titleLarge,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                  filled: false,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                        width: 2, color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide:
                                        BorderSide(width: 1, color: greenBlue),
                                  ),
                                ),
                                onChanged: (value) {
                                  if (value.length == 1) {
                                    FocusScope.of(context).nextFocus();
                                  }
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'cannot be empty';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  digit3 = value!;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 70,
                              width: 70,
                              child: TextFormField(
                                style: Theme.of(context).textTheme.titleLarge,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                  filled: false,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                        width: 2, color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide:
                                        BorderSide(width: 1, color: greenBlue),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'cannot be empty';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  digit4 = value!;
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: ElevatedButton(
                                  onPressed: () {},
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(grey),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  child: Text("Resend",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white))),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: ElevatedButton(
                                  onPressed: () async{
                                    if (formKey.currentState!.validate()) {
                                      formKey.currentState!.save();
                                      String otp = digit1 + digit2 + digit3 + digit4;
                                      String hash = snapshot.data!;
                                      print("hash is : "+snapshot.data.toString());
                                      bool? correct = await verifyOTPCode(widget.email, hash, otp);
                                      if(correct == true){
                                        const snackBar = SnackBar(
                                          content: Text(
                                            'Correct otp code!',
                                          ),
                                        );
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      }else if(correct == false){
                                        const snackBar = SnackBar(
                                          content: Text(
                                            'Incorrect otp code!',
                                          ),
                                        );
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                                  child: const Text("Confirm",
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
            }));
  }
}
