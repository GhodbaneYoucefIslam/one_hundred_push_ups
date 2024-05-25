import "package:dropdown_button2/dropdown_button2.dart";
import "package:flutter/material.dart";

class CustomDropDownMenu extends StatelessWidget {
  final List<String> menuEntries;
  final String? value;
  final Color borderColor;
  final void Function(String?)? onChanged;
  final double horizontalOffset;
  final double verticalOffset;
  final String hintText;
  const CustomDropDownMenu({super.key, required this.menuEntries,this.value, required this.borderColor, this.onChanged, required this.horizontalOffset, required this.verticalOffset, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        hint: Text(
          hintText,
          style: TextStyle(
            fontSize: 15,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        items: menuEntries
            .map((item) => DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black,
            ),
          ),
        ))
            .toList(),
        value: value,
        onChanged: onChanged,
        buttonStyleData:ButtonStyleData(
          height: 50,
          width: MediaQuery.of(context).size.width*0.35,
          padding: EdgeInsets.only(left: 14, right: 14),
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 160,
          width: 120,
          padding: null,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: borderColor),
          ),
          elevation: 1,
          offset: Offset(horizontalOffset, verticalOffset),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 30,
          padding: EdgeInsets.only(left: 10, right: 0),
        ),
      ),
    );
  }
}
