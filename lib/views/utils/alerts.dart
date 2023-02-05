import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:chat/theme/text_theme.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AppAlert {
  AppAlert(this.context);
  BuildContext context;

  void cautiousOperation({required String message, required Function() onYes}) {
    AwesomeDialog(
            btnOkColor: Colors.orange,
            context: context,
            animType: AnimType.SCALE,
            dialogType: DialogType.QUESTION,
            headerAnimationLoop: false,
            title: "Confirm?",
            desc: message,
            btnOkOnPress: onYes,
            btnOkText: "Yes",
            btnCancelText: "Cancel")
        .show();
  }

  void inform(String title, String desc, {Function()? onPressed}) {
    AwesomeDialog(
      btnOkColor: Colors.orange,
      context: context,
      animType: AnimType.SCALE,
      dialogType: DialogType.INFO,
      headerAnimationLoop: false,
      title: title,
      desc: desc,
      btnOkOnPress: onPressed,
    ).show();
  }

  void informDetailed(String title, String desc, Widget child) {
    showMaterialModalBottomSheet(
        context: context,
        expand: false,
        builder: (context) => Container(
              height: 500,
              padding: EdgeInsets.all(10),
              child: Column(children: [
                SizedBox(height: 10),
                Text(title,
                    style: MyTextTheme()
                        .headingTextStyle
                        .copyWith(color: Colors.red)),
                SizedBox(height: 10),
                Text(desc, style: MyTextTheme().normalTextStyle),
                SizedBox(height: 10),
                child
              ]),
            ));
  }
}
