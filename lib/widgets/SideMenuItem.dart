import "package:flutter/material.dart";
import '../utils/constants.dart';

class SideMenuItem extends StatelessWidget {
  int id;
  String title;
  IconData icon;
  bool selected;
  VoidCallback onTap;
  SideMenuItem(
      {super.key,
      required this.id,
      required this.title,
      required this.icon,
      required this.selected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Material(
        color: selected ? greenBlue.withOpacity(0.5) : Colors.white10,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 11, bottom: 11),
            child: Row(
              children: [
                Expanded(
                    child: Icon(
                  icon,
                  size: 20,
                  color: selected ? turquoiseBlue : Colors.black,
                )),
                Expanded(
                  flex: 3,
                  child: Text(
                    title,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: selected ? turquoiseBlue : Colors.black),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
