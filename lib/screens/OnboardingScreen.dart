import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:one_hundred_push_ups/AppHome.dart";
import "package:one_hundred_push_ups/screens/OnboardingScreenContent.dart";
import "package:one_hundred_push_ups/screens/SignUpPage.dart";
import "package:one_hundred_push_ups/utils/constants.dart";
import "package:one_hundred_push_ups/utils/translationConstants.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:smooth_page_indicator/smooth_page_indicator.dart";

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController _controller = PageController();
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        PageView(
          onPageChanged: (index) {
            setState(() {
              currentPage = index;
            });
          },
          controller: _controller,
          children: [
            OnboardingScreenContent(content: onboardingContent1.tr),
            OnboardingScreenContent(content: onboardingContent2.tr),
            OnboardingScreenContent(content: onboardingContent3.tr),
            OnboardingScreenContent(content: onboardingContent4.tr),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    child: Text(
                      currentPage == 3 ? maybeLater.tr : back.tr,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: currentPage == 0 ? grey : Colors.black),
                    ),
                    onTap: () async {
                      if (currentPage < 3) {
                        _controller.previousPage(
                            duration: Duration(microseconds: 500),
                            curve: Curves.easeIn);
                      } else {
                        final myPrefs = await SharedPreferences.getInstance();
                        myPrefs.setBool(showOnboarding, false);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  AppHome(title: "100PushUPs"),
                            ));
                      }
                    },
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (currentPage < 3) {
                        _controller.nextPage(
                            duration: Duration(microseconds: 500),
                            curve: Curves.easeIn);
                      } else {
                        final myPrefs = await SharedPreferences.getInstance();
                        myPrefs.setBool(showOnboarding, false);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  SignUpPage(),
                            ));
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            greenBlue.withOpacity(0.5))),
                    child: currentPage <= 2
                        ? Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: Colors.white,
                          )
                        : Text(
                            "${yes.tr}!",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              SmoothPageIndicator(
                controller: _controller,
                count: 4,
                effect: WormEffect(
                  dotColor: grey,
                  activeDotColor: turquoiseBlue
                ),
                onDotClicked: (index) => _controller.animateToPage(index,
                    duration: Duration(microseconds: 500),
                    curve: Curves.easeIn),
              ),
            ],
          ),
        )
      ]),
    );
  }
}
