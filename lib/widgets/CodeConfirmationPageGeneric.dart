import 'dart:async';
import 'package:flutter/material.dart';

class CodeConfirmationPageGeneric extends StatefulWidget {
  String email;
  String? fName, lName, password;
  Duration codeExpiresIn;
  Future? codeSendingFunction;
  Widget Function(BuildContext context, AsyncSnapshot snapshot) builder;
  CodeConfirmationPageGeneric(
      {required this.email,
      this.fName,
      this.lName,
      this.password,
      required this.codeExpiresIn,
      required this.codeSendingFunction,
      required this.builder,
      super.key});

  @override
  State<CodeConfirmationPageGeneric> createState() =>
      _CodeConfirmationPageState();
}

class _CodeConfirmationPageState extends State<CodeConfirmationPageGeneric> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: FutureBuilder(
            future: widget.codeSendingFunction, builder: widget.builder));
  }
}
