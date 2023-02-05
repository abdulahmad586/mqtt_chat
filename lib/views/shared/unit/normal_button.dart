import 'package:flutter/material.dart';
import 'package:chat/theme/colors.dart';

class NormalButton extends StatelessWidget {
  NormalButton(
      {required this.label,
      this.onPressed,
      this.icon = Icons.arrow_forward,
      this.horizontalMargin = 20,
      this.verticalMargin = 20,
      this.horizontalPadding = 20,
      this.verticalPadding = 10});
  String label;
  Function()? onPressed;
  double horizontalMargin, verticalMargin;
  double horizontalPadding, verticalPadding;
  IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: horizontalMargin, vertical: verticalMargin),
        child: RawMaterialButton(
          elevation: 0,
          fillColor: AppColors().primary,
          splashColor: AppColors().primaryDark,
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    this.label,
                    style: TextStyle(
                        color: AppColors().primaryContrast,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                  Icon(icon, color: AppColors().primaryContrast, size: 15),
                ],
              ))),
          onPressed: onPressed,
          shape: const StadiumBorder(),
        ));
  }
}

class ElevButton extends StatelessWidget {
  ElevButton(
      {required this.label, this.onPressed, this.icon = Icons.arrow_forward});
  String label;
  Function()? onPressed;
  IconData icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(AppColors().primary),
      ),
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                this.label,
                style: TextStyle(
                    color: AppColors().primaryContrast,
                    fontWeight: FontWeight.bold),
              ),
              Icon(icon, color: AppColors().primaryContrast),
            ],
          ))),
      onPressed: onPressed,
    );
  }
}
