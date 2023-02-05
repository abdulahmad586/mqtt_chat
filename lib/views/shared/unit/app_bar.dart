import 'package:flutter/material.dart';
import 'package:chat/views/utils/cib.dart';
import 'package:google_fonts/google_fonts.dart';

class MyAppBar extends AppBar {
  MyAppBar(
      {required this.context,
      this.titleText = "",
      this.icon,
      this.backEnabled = true,
      this.actions = const []});
  final BuildContext context;
  final String titleText;
  final IconData? icon;
  final List<Widget> actions;
  bool backEnabled = true;

  @override
  State<AppBar> createState() {
    return MyAppBarState();
  }
}

class MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.white,
      actions: widget.actions,
      leading: widget.backEnabled
          ? Padding(
              padding: EdgeInsets.all(10.0),
              child: ColorIconButton(
                "",
                Icons.arrow_back,
                Colors.white,
                iconColor: Colors.orange,
                shape: BoxShape.rectangle,
                iconSize: 15,
                onPressed: () {
                  Navigator.pop(context);
                },
              ))
          : null,
      title: Align(
          alignment: Alignment.center,
          child: Row(children: [
//            Text(widget.titleText, style: TextStyle(color: Colors.black, fontSize: 14)),
            Text(widget.titleText,
                style: GoogleFonts.orbitron(
                    textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold))),
            SizedBox(width: 10.0),
            widget.icon != null
                ? Icon(
                    widget.icon!,
                    color: Colors.black,
                    size: 15,
                  )
                : Container()
          ])),
    );
  }
}
