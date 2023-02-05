import 'package:flutter/material.dart';

class Functions{

  static s(BuildContext c, String s){
      ScaffoldMessenger.of(c).showSnackBar(SnackBar(content: Text(s)));
  }

  static Widget numBadge(int number, {Color color= Colors.redAccent}) {
    return CircleAvatar(
        radius: 5,
        backgroundColor: color,
        child: Text(
          number.toString(),
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 5,
              color: Colors.white),
        ));
  }

}