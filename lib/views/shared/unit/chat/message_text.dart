import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:flutter/material.dart';

class ChannelListItem extends StatelessWidget {
  ChannelListItem({required this.chanData, @required this.onPressed, this.trailing});
  final GestureTapCallback? onPressed;
  final String chanData;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}