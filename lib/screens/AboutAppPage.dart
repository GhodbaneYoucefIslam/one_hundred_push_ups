import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:get/get.dart";
import "package:one_hundred_push_ups/utils/translationConstants.dart";

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
                          infoParagraph.tr,
                            style: TextStyle(fontSize: 16.0),
                            textAlign: TextAlign.justify,
                          ),
                        )
                    ),
                    SingleChildScrollView(
                        child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                            termsAndConditionsParagraph.tr,
                              style: TextStyle(fontSize: 16.0),
                              textAlign: TextAlign.justify,
                            )
                        )
                    ),
                    SingleChildScrollView(
                        child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                            privacyPolicyParagraph.tr,
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
                        child: Text(aboutSection.tr,
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
                        child: Text(termsAndConditionsSection.tr,
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
                        child: Text(privacyPolicySection.tr,
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
