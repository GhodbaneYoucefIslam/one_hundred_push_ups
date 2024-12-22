import "package:flutter/material.dart";

import "../utils/constants.dart";

class SettingsMenuItem extends StatelessWidget {
  String text;
  IconData icon;
  void Function()? onTap;
  SettingsMenuItem(
      {super.key, required this.text, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: grey.withOpacity(0.1),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                ),
                Icon(
                  icon,
                  size: 30,
                ),
                const SizedBox(
                  width: 12,
                ),
                Text(
                  text,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.15,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
