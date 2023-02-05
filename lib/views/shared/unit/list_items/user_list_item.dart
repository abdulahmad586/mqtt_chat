import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:flutter/material.dart';
import 'package:chat/models/user.model.dart';
import 'package:chat/theme/colors.dart';

class UserListItem extends StatelessWidget {
  UserListItem(
      {required this.userData, required this.onPressed, this.trailing});
  final GestureTapCallback? onPressed;
  final User userData;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 0,
      fillColor: Colors.white,
      splashColor: Colors.white10,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            TextAvatar(
              shape: Shape.Circular,
              size: 36,
              text: userData.name,
              numberLetters: 2,
            ),
            SizedBox(
              width: 10.0,
            ),
            Expanded(
                child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(userData.name,
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 16, color: Colors.grey)),
                    Text('',
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 10)),
                  ],
                ),
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  mainAxisSize: MainAxisSize.max,
//                  children: [
//                    Row(children: [
//                      Icon(Icons.message, color: Colors.amber, size: 14),
//                      Text("",
//                          textAlign: TextAlign.start,
//                          style: TextStyle(fontSize: 10))
//                    ]),
//                  ],
//                ),
              ],
            )),
            SizedBox(
              width: 10.0,
            ),
            trailing ??
                IconButton(
                  icon:
                      Icon(Icons.arrow_forward_ios, color: AppColors().primary),
                  iconSize: 10,
                  constraints: BoxConstraints(maxWidth: 30, maxHeight: 30),
                  onPressed: () {
                    print('modify search filters');
                  },
                ),
          ],
        ),
      ),
      onPressed: onPressed,
    );
  }
}
