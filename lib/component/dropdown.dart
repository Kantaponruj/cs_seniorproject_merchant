import 'dart:io';

import 'package:cs_senior_project_merchant/asset/color.dart';
import 'package:cs_senior_project_merchant/asset/text_style.dart';
import 'package:flutter/material.dart';

class BuildDropdown extends StatelessWidget {
  BuildDropdown({
    Key key,
    @required this.dropdownValues,
    @required this.onChanged,
    this.value,
    this.hintText,
    this.width,
  }) : super(key: key);

  final List<DropdownMenuItem<String>> dropdownValues;
  final Function(String) onChanged;
  final String value;
  final String hintText;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
            color: Colors.grey, style: BorderStyle.solid, width: 0.80),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          iconSize: 30,
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: Colors.black,
          ),
          isExpanded: true,
          items: dropdownValues,
              // .map((value) => DropdownMenuItem(
              //       child: Text(value),
              //       value: value,
              //     ))
              // .toList(),
          onChanged: onChanged,
          value: value,
          hint: Text(
            hintText,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
        ),
      ),
    );
  }
}
