import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:chat/bloc/state_management/main_cubit.dart';
import 'package:chat/store/settings.dart';
import 'package:chat/views/interfaces/auth/settings.dart';
import 'package:chat/views/interfaces/main/status_page.dart';
import 'package:chat/views/interfaces/secondary/chat_room.dart';
import 'package:chat/views/shared/nav_drawer.dart';
import 'package:chat/views/utils/nav_utils.dart';
import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Main extends StatefulWidget {
  Main();

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  BuildContext? chatsContext;

  int _pageId = 0;

  List<Map<String, dynamic>> _pages = [];

  @override
  void initState() {
    Settings.init().then(
      (value) {
        setState(() {
          _pages = [
            {
              "label": "Chatroom",
              "icon": Icons.message,
              "page": ChatPage(
                myUsername: value.username,
                user2: 'SecondUser',
              ),
            },
            {
              "label": "Status",
              "icon": Icons.anchor_sharp,
              "page": StatusPage(),
            },
          ];
        });
      },
    ).catchError((error) {});
    connectConveyor();
    super.initState();
  }

  void connectConveyor() {
    BlocProvider.of<MainCubit>(context).connectConveyor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        actions: [
          TextAvatar(
            shape: Shape.Circular,
            size: 50,
            text: 'John Doe',
            numberLetters: 2,
          ),
          const SizedBox(width: 10),
        ],
      ),
      drawer: NavDrawer(
        pages: _pages,
        actions: [
          {
            "label": "Logout",
            "icon": Icons.logout,
            "onClick": () {
              Navigator.pop(context);
              Navigator.pop(context);
            }
          },
          {
            "label": "Settings",
            "icon": Icons.settings,
            "onClick": () {
              Navigator.pop(context);
              NavUtils.navTo(context, SettingsPage());
            }
          },
        ],
        onPageChanged: (pageId) {
          setState(() {
            _pageId = pageId;
          });
        },
        currentPage: _pageId,
      ),
      body: _buildPage(),
    );
  }

  Widget _buildPage() {
    return _pages[_pageId]["page"] ?? const Text("Page is messed up");
  }

  void checkNotificationPermission() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // This is just a basic example. For real apps, you must show some
        // friendly dialog box before call the request method.
        // This is very important to not harm the user experience
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }
}
