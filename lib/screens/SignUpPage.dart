import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:one_hundred_push_ups/AppHome.dart";
import "package:one_hundred_push_ups/models/GoogleSignInApi.dart";
import "package:one_hundred_push_ups/screens/AboutAppPage.dart";
import "package:one_hundred_push_ups/screens/LoginPage.dart";
import "package:one_hundred_push_ups/widgets/RoundedTextFormField.dart";
import "package:one_hundred_push_ups/models/Endpoints.dart";
import "package:provider/provider.dart";
import "package:shared_preferences/shared_preferences.dart";

import "../models/UserProvider.dart";
import "../utils/constants.dart";
import "../utils/methods.dart";
import "../widgets/LoadingIndicatorDialog.dart";
import "CodeConfirmationPageForSignUp.dart";

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();
  bool accept = false;
  late String fName, lName, email, password, confirmedPassword;
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
                  obscureText: !passwordVisible,
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
                  validator: (value){
                    if (value == null || value.isEmpty) {
                      return 'Password cannot be empty';
                    }else if(value.toString().length<4){
                      return 'Password cannot contain less than 4 characters';
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
                  obscureText: !passwordVisible,
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
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AboutAppPage(index: 1)));
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
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AboutAppPage(index: 1)));
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
                  onTap: () async{
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
                      LoadingIndicatorDialog().show(context, text: "Logging in");
                      final loggedInUser = await loginOrSignUpWithGoogle(email, fName, lName);
                      LoadingIndicatorDialog().dismiss();
                      if(loggedInUser != null){
                        if (loggedInUser.id!= -1){
                          final snackBar = SnackBar(
                            content: Text(
                              'Registration of ${loggedInUser.lastname} ${loggedInUser.firstname} successful with id:${loggedInUser.id}!',
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
                          const snackBar = SnackBar(
                            content: Text(
                              'This user is not connected through google, please use email and password to login',
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      }else{
                        const snackBar = SnackBar(
                          content: Text(
                            'Error connecting to server, please try again',
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    }else{
                      const snackBar = SnackBar(
                        content: Text(
                          'Google authentication failed please try again',
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
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.g_mobiledata_rounded,
                          size: 40,
                        ),
                        Text(
                          'Continue with google',
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
    LoadingIndicatorDialog().show(context, text: "Verifying email");
    bool? availableEmail = await isEmailNotPreviouslyUsed(email);
    LoadingIndicatorDialog().dismiss();
    if (availableEmail==true){
      //take user to confirmation screen
      Navigator.push(context, MaterialPageRoute(builder: (context)=>CodeConfirmationPageForSignUp(email: email, fName: fName, lName: lName, password: password, codeExpiresIn: const Duration(minutes: 5),)));
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
