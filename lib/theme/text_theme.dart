import 'package:flutter/material.dart';
import 'package:chat/theme/colors.dart';

class MyTextTheme extends TextTheme {
  TextStyle popupTextStyle = const TextStyle(fontSize: 12);
  TextStyle smallText = const TextStyle(fontSize: 10);
  TextStyle smallHintText =
      TextStyle(fontSize: 10, color: AppColors().hintText);
  TextStyle normalTextStyle = TextStyle(color: Colors.black, fontSize: 12);
  TextStyle headingTextStyle =
      TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold);
}
