import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:get/get.dart";
import "package:one_hundred_push_ups/utils/constants.dart";
import "package:one_hundred_push_ups/utils/translationConstants.dart";

class OnboardingScreenContent extends StatelessWidget {
  String content;
  OnboardingScreenContent({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(Theme.of(context).brightness == Brightness.dark
                  ? "assets/images/logo_white.svg"
                  : "assets/images/logo_black.svg"),
              Text(
                welcome.tr,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              Text(
                appName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: lightBlue,
                ),
              )
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            decoration: BoxDecoration(
              color: turquoiseBlue.withOpacity(0.2),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.1),
              child: Text(
                content,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
