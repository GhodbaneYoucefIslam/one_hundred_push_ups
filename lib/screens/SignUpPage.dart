import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:one_hundred_push_ups/AppHome.dart";
import "package:one_hundred_push_ups/screens/CodeConfirmationPage.dart";
import "package:one_hundred_push_ups/screens/LoginPage.dart";
import "package:one_hundred_push_ups/widgets/RoundedTextFormField.dart";
import "package:one_hundred_push_ups/models/Endpoints.dart";

import "../utils/constants.dart";

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();
  bool accept = false;
  late String fName, lName, email, password, confirmedPassword;
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email cannot be empty';
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);
    bool invalid = (value.isNotEmpty && !regex.hasMatch(value));
    return invalid
        ? 'Enter a valid email address'
        : null;
  }
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
                  "Create your account",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                RoundedTextFormField(
                  hintText: "First name",
                  hintTextSize: 17,
                  borderColor: grey,
                  selectedBorderColor: greenBlue,
                  borderRadius: 10,
                  validator: (value){
                    if (value == null || value.isEmpty) {
                      return 'First name cannot be empty';
                    }
                    return null;
                  },
                  onSaved: (value){
                    fName = value!;
                  },
                ),
                RoundedTextFormField(
                  hintText: "Last name",
                  hintTextSize: 17,
                  borderColor: grey,
                  selectedBorderColor: greenBlue,
                  borderRadius: 10,
                  validator: (value){
                    if (value == null || value.isEmpty) {
                      return 'Last name cannot be empty';
                    }
                    return null;
                  },
                  onSaved: (value){
                    lName = value!;
                  },
                ),
                RoundedTextFormField(
                  hintText: "Email",
                  hintTextSize: 17,
                  borderColor: grey,
                  selectedBorderColor: greenBlue,
                  borderRadius: 10,
                  validator: (value) => validateEmail(value),
                  onSaved: (value){
                    email = value!;
                  },
                ),
                RoundedTextFormField(
                  hintText: "Password",
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
                RoundedTextFormField(
                  hintText: "Confirm password",
                  hintTextSize: 17,
                  borderColor: grey,
                  selectedBorderColor: greenBlue,
                  borderRadius: 10,
                  validator: (value){
                    if (value == null || value.isEmpty) {
                      return 'Confirmed password cannot be empty';
                    }
                    return null;
                  },
                  onSaved: (value){
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
                          accept=value!;
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      side: MaterialStateBorderSide.resolveWith(
                            (states) =>
                        const BorderSide(width: 1.0, color: Color(0xff9BAEBC)),
                      ),
                    ),
                    const Text(
                      'I accept ',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        //todo : load page that contains terms and conditions
                      },
                      child: Text(
                        'terms ',
                        style: TextStyle(
                          fontSize: 17,
                          color: greenBlue,
                          decoration: TextDecoration.underline,
                          decorationColor: greenBlue
                        ),
                      ),
                    ),
                    const Text(
                      'and ',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        //todo : load page that contains terms and conditions
                      },
                      child: Text(
                        'conditions ',
                        style: TextStyle(
                          fontSize: 17,
                          color: greenBlue,
                          decoration: TextDecoration.underline,
                          decorationColor: greenBlue
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
                          if(accept){
                            if (password==confirmedPassword){
                              signUp(fName, lName, email, password);
                            }else{
                              const snackBar = SnackBar(
                                content: Text(
                                  'Please confirm your password',
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                          }else{
                            const snackBar = SnackBar(
                              content: Text(
                                'Terms & conditions must be accepted',
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
                      child: const Text("Sign up",
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
                    //todo : implement sign up with google
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
                          'Sign up with google',
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
                      'Already have an account?  ',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginPage()));
                      },
                      child: Text(
                        'Login',
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
  void signUp(String fName, String lName, String email, String password) async{
    //see if email available
    bool? availableEmail = await isEmailPreviouslyUsed(email);
    if (availableEmail==true){
      //take user to confirmation screen
      Navigator.push(context, MaterialPageRoute(builder: (context)=>CodeConfirmationPage(email: email, fName: fName, lName: lName, password: password)));
    }else if(availableEmail== false){
      const snackBar = SnackBar(
        content: Text(
          'This email address is already used, please provide a different one',
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }else{
      const snackBar = SnackBar(
        content: Text(
          'Cannot connect to server, please try again',
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }


  }
}
