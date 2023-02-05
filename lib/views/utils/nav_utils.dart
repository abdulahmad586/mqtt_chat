import 'package:flutter/material.dart';

class NavUtils {
  static void navTo(BuildContext context, Widget dest,
      {Function(bool?)? onReturn}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => dest),
    ).then((value) {
      if (onReturn != null) {
        onReturn(value);
      }
    }).catchError((err) {
      print("Navigation error: $err");
    });
  }

  static void navToReplace(BuildContext context, Widget dest) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => dest),
    );
  }
}
