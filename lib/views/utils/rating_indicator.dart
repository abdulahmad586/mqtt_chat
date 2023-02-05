import 'package:flutter/material.dart';
import 'package:chat/theme/colors.dart';

Widget starRating(int star, double value) {
  return Container(
    width: 150,
    child: Row(
      children: [
        Text(
          star.toString() + " ",
          style: TextStyle(
              color: AppColors().primary, fontWeight: FontWeight.bold),
        ),
        Icon(Icons.star, color: AppColors().primary, size: 15),
        SizedBox(
          width: 90,
          child: LinearProgressIndicator(
            backgroundColor: AppColors().primary.withAlpha(100),
            valueColor: new AlwaysStoppedAnimation<Color>(AppColors().primary),
            value: value,
          ),
        )
      ],
    ),
  );
}
