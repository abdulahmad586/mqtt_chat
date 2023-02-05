import 'package:flutter/material.dart';
import 'package:chat/theme/colors.dart';

class GenericListItem extends StatelessWidget {
  GenericListItem({required this.data});
  Map<String, dynamic> data;

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
            Icon(data['icon'], size: 15),
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
                    Text(data["title"],
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 16, color: AppColors().primaryText)),
                    Text('',
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 10)),
                  ],
                ),
                SizedBox(height: 5),
                Text(data["desc"],
                    textAlign: TextAlign.start,
                    style:
                        TextStyle(fontSize: 12, color: AppColors().hintText)),
              ],
            )),
            SizedBox(
              width: 10.0,
            ),
            data["trailing"] ??
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
      onPressed: data["onPressed"] ?? () {},
    );
  }
}
