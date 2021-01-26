import 'package:dima_project/shared/constants.dart';
import 'package:flutter/material.dart';

class CircleNumber extends StatelessWidget {
  final String number;

  CircleNumber(this.number);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        child: Text(number, style: textButtonStyle),
        radius: 15,
        backgroundColor: mainAppColor,
        foregroundColor: Colors.black);
  }
}
