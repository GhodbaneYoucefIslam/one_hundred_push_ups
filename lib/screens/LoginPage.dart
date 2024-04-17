import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:one_hundred_push_ups/AppHome.dart";
import "package:one_hundred_push_ups/screens/SignUpPage.dart";
import "package:one_hundred_push_ups/widgets/RoundedTextFormField.dart";

import "../utils/constants.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  bool rememberMe = false;
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
                          style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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
                  validator: (value){
                    if (value == null || value.isEmpty) {
                      return 'Email cannot be empty';
                    }
                    return null;
                  },
                  onSaved: (value){
                    email = value!;
                  },
                ),
                RoundedTextFormField(
                  hintText: "Enter Your password",
                  hintTextSize: 17,
                  borderColor: grey,
                  selectedBorderColor: greenBlue,
                  borderRadius: 10,
                  validator: (value){
                    if (value == null || value.isEmpty) {
                      return 'Password cannot be empty';
                    }
                    return null;
                  },
                  onSaved: (value){
                    password = value!;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          activeColor: greenBlue,
                          value: rememberMe,
                          onChanged: (value) {
                            setState(() {
                              rememberMe = value!;
                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          side: MaterialStateBorderSide.resolveWith(
                            (states) => const BorderSide(
                                width: 1.0, color: Color(0xFFB9B9B9)),
                          ),
                        ),
                        Text(
                          "Remember me",
                          style: TextStyle(fontSize: 17, color: grey),
                        ),
                      ],
                    ),
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
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        if(formKey.currentState!.validate()){
                          formKey.currentState!.save();
                          if(login(email, password, rememberMe)){
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> AppHome(title: appName)));
                          }else{
                            const snackBar = SnackBar(
                              content: Text(
                                'Invalid credentials',
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> SignUpPage()));
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
              ],
            ),
          ),
        ),
      ),
    );
  }
  bool login(String email, String password, bool rememberMe){
    //todo : implement login
    return email == "me@me.com" && password == "1234";
  }
}
