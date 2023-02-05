import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:chat/bloc/db/hive_db.dart';
import 'package:chat/theme/colors.dart';

class RuntimeInitializer {
  static initializeAll() async {
    initNotification();
    await initHive();
  }

  static Future<bool> initHive() async {
    await HiveDBMan.initHive();
    return true;
  }

  static initNotification() {
    AwesomeNotifications().initialize(
        // set the icon to null if you want to use the default app icon
//      'resource://drawable/res_app_icon',
        null,
        [
          NotificationChannel(
              channelGroupKey: 'messages',
              channelKey: 'private_message',
              channelName: 'Private message',
              channelDescription: 'Notification channel for private messages',
              defaultColor: AppColors().primary,
              ledColor: Colors.white),
          NotificationChannel(
              channelGroupKey: 'messages',
              channelKey: 'broadcast_message',
              channelName: 'Chatroom message',
              channelDescription: 'Notification channel for chat room messages',
              defaultColor: AppColors().primary,
              ledColor: Colors.white),
        ],
        // Channel groups are only visual and are not required
        channelGroups: [
          NotificationChannelGroup(
              channelGroupkey: 'messages', channelGroupName: 'Messages')
        ],
        debug: true);
  }
}
