import 'package:flutter/material.dart';

class RoundedTextFormField extends StatelessWidget {
  String hintText;
  double hintTextSize;
  Color borderColor;
  Color selectedBorderColor;
  Widget? suffixIcon;
  Widget? prefixIcon;
  double? borderRadius;
  bool? obscureText;
  TextEditingController? controller;
  FormFieldValidator? validator;
  FormFieldSetter<String?>? onSaved;
  String? initialValue;
  RoundedTextFormField(
      {Key? key,
      required this.hintText,
      required this.hintTextSize,
      required this.borderColor,
      required this.selectedBorderColor,
      this.obscureText,
      this.suffixIcon,
      this.prefixIcon,
      this.borderRadius,
      this.controller,
      this.validator,
      this.onSaved,
      this.initialValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: (obscureText == null) ? false : obscureText!,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: hintTextSize,
          color: const Color(0xff9BAEBC),
        ),
        filled: false,
        contentPadding: const EdgeInsets.only(left: 15, top: 5, bottom: 5),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              (borderRadius != null) ? borderRadius! : 20),
          borderSide: BorderSide(width: 1, color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(width: 1, color: selectedBorderColor),
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
      controller: controller,
      validator: validator,
      onSaved: onSaved,
      initialValue: initialValue,
    );
  }
}
