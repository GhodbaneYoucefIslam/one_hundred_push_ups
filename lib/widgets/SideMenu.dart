import "package:flutter/material.dart";
class SideMenu extends StatelessWidget {
  String accountName;
  String accountEmail;
  Widget avatar;
  List<Widget> menuEntries;
  List<Widget>? optionWidgets;

  SideMenu({super.key,required this.accountEmail,required this.accountName,required this.avatar,required this.menuEntries,this.optionWidgets});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName:  Text(
              accountName,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            accountEmail: Text(
              accountEmail,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black)),
                  child:  Center(
                    child: avatar,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: menuEntries,
            ),
          ),
          Column(
            children: (optionWidgets != null)? optionWidgets! : [],
          )
        ],
      ),
    );
  }
}

