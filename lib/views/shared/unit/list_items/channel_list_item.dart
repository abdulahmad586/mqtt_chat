import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:flutter/material.dart';
import 'package:chat/models/channel.model.dart';
import 'package:chat/theme/colors.dart';

class ChannelListItem extends StatelessWidget {
  ChannelListItem(
      {required this.chanData, @required this.onPressed, this.trailing});
  final GestureTapCallback? onPressed;
  final Channel chanData;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 0,
      fillColor: Colors.white,
      splashColor: Colors.white10,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            TextAvatar(
              shape: Shape.Circular,
              size: 36,
              text: chanData.name,
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
                    Text(chanData.name,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 16, color: AppColors().primaryText)),
                    Text('',
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 10)),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(children: [
                      Icon(Icons.people, color: Colors.amber, size: 14),
                      SizedBox(width: 5),
                      Text("635 users",
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 10))
                    ]),
                  ],
                ),
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
                  onPressed: () {},
                ),
          ],
        ),
      ),
      onPressed: onPressed,
    );
  }
}
