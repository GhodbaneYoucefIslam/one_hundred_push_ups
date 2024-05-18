import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";

import "../utils/constants.dart";

class AboutAppPage extends StatefulWidget {
  int index;
  AboutAppPage({required this.index, super.key});

  @override
  State<AboutAppPage> createState() => _AboutAppPageState();
}

class _AboutAppPageState extends State<AboutAppPage> {
  int currentInfoPage = 0;
  final myPageController = PageController();

  @override
  void initState() {
    currentInfoPage = widget.index;
    Future.microtask(() {
      myPageController.animateToPage(
        currentInfoPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  SizedBox(
                      width: 25, child: SvgPicture.asset("assets/images/logo.svg")),
                  Text(
                    "100PushUps",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.6,
                decoration: BoxDecoration(
                    color: grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10)),
                child: PageView(
                  controller: myPageController,
                  onPageChanged: (index) {
                    setState(() {
                      currentInfoPage = index;
                    });
                  },
                  children: [
                    SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            "Welcome to One Hundred Push Ups, your ultimate fitness companion designed to help you achieve your strength goals through a structured and progressive push-up program. Our app is dedicated to providing you with personalized workout plans, tracking your progress, and keeping you motivated on your fitness journey.\n\n"
                                "With features like a daily leaderboard, achievement tracking, and data management tools, One Hundred Push Ups ensures you stay on top of your game. Whether you're a beginner or an advanced athlete, our app adapts to your level, offering a unique experience tailored to your needs.\n\n"
                                "We value your privacy and are committed to protecting your data. Please take a moment to review our Terms and Conditions and Privacy Policy. If you have any questions or feedback, feel free to contact us. We're here to support you every step of the way.\n\n"
                                "Thank you for choosing One Hundred Push Ups. Let's get stronger together!",
                            style: TextStyle(fontSize: 16.0),
                            textAlign: TextAlign.justify,
                          ),
                        )
                    ),
                    SingleChildScrollView(
                        child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              "Terms and Conditions\n\n"
                                  "Welcome to One Hundred Push Ups. These terms and conditions outline the rules and regulations for the use of our application. By accessing and using this app, you accept and agree to be bound by the terms and conditions set forth below.\n\n"
                                  "1. Use of the App: You agree to use the app only for lawful purposes and in a way that does not infringe the rights of, restrict, or inhibit anyone else's use and enjoyment of the app.\n\n"
                                  "2. Privacy: Your privacy is important to us. Please read our Privacy Policy for information on how we collect, use, and disclose your personal data.\n\n"
                                  "3. Modifications to the Service: We reserve the right to modify or discontinue the app at any time, with or without notice, and without liability to you.\n\n"
                                  "4. Limitation of Liability: The app is provided on an 'as is' and 'as available' basis. We make no warranties, expressed or implied, and hereby disclaim and negate all other warranties.\n\n"
                                  "5. Governing Law: These terms and conditions are governed by and construed in accordance with the laws, and you irrevocably submit to the exclusive jurisdiction of the courts in that location.\n\n"
                                  "For any questions or inquiries about our terms and conditions contact us.",
                              style: TextStyle(fontSize: 16.0),
                              textAlign: TextAlign.justify,
                            )
                        )
                    ),
                    SingleChildScrollView(
                        child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              "Privacy Policy\n\n"
                                  "Welcome to One Hundred Push Ups. Your privacy is important to us. This Privacy Policy explains how we collect, use, and safeguard your information when you use our application.\n\n"
                                  "1. Information We Collect: We may collect personal information such as your name, email address, and workout data when you register and use the app.\n\n"
                                  "2. Use of Information: The information we collect is used to provide and improve our services, customize your experience, and communicate with you about updates and offers.\n\n"
                                  "3. Data Security: We implement a variety of security measures to maintain the safety of your personal information. However, no method of transmission over the Internet or electronic storage is 100% secure.\n\n"
                                  "4. Third-Party Services: We may employ third-party companies and individuals to facilitate our service. These third parties have access to your personal information only to perform these tasks on our behalf and are obligated not to disclose or use it for any other purpose.\n\n"
                                  "5. Changes to This Privacy Policy: We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.\n\n"
                                  "If you have any questions or concerns about our Privacy Policy, please contact us.",
                              style: TextStyle(fontSize: 16.0),
                              textAlign: TextAlign.justify,
                            )
                        )
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            currentInfoPage = 0;
                          });
                          myPageController.animateToPage(
                            0,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              currentInfoPage == 0 ? greenBlue : grey),
                          shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        child: Text("About 100PushUps",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15,
                                color: currentInfoPage == 0
                                    ? Colors.black
                                    : Colors.white))),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.01,),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            currentInfoPage = 1;
                          });
                          myPageController.animateToPage(
                            1,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              currentInfoPage == 1 ? greenBlue : grey),
                          shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        child: Text("Terms & Conditions",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15,
                                color: currentInfoPage == 1
                                    ? Colors.black
                                    : Colors.white))),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.01,),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            currentInfoPage = 2;
                          });
                          myPageController.animateToPage(
                            2,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              currentInfoPage == 2 ? greenBlue : grey),
                          shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        child: Text("Privacy policy",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15,
                                color: currentInfoPage == 2
                                    ? Colors.black
                                    : Colors.white))),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
