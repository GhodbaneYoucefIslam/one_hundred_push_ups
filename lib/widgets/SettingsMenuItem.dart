import "package:flutter/material.dart";

import "../utils/constants.dart";
class SettingsMenuItem extends StatelessWidget {
  String text;
  IconData icon;
  void Function()? onTap;
  SettingsMenuItem({super.key, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: grey, width: 1, style: BorderStyle.solid))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.15,
            ),
            Icon(
              icon,
              size: 35,
            ),
            const SizedBox(
              width: 12,
            ),
            Text(
              text,
              style: const TextStyle(fontSize: 18),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.15,
            )
          ],
        ),
      ),
    );
  }
}
