import 'dart:async';
import 'package:chat/store/settings.dart';
import 'package:chat/views/interfaces/auth/settings.dart';
import 'package:chat/views/interfaces/main/main_main.dart';
import 'package:chat/views/shared/unit/app_bar.dart';
import 'package:chat/views/utils/nav_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat/bloc/state_management/main_cubit.dart';
import 'package:chat/models/user.model.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:chat/views/interfaces/auth/register_page.dart';
import 'package:chat/views/shared/unit/my_text_field.dart';
import 'package:chat/theme/text_theme.dart';
import 'package:chat/theme/colors.dart';
import 'package:chat/views/shared/unit/normal_button.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();

  String deviceId = "";
  String status = "";

  @override
  void initState() {
    getDeviceId();
    super.initState();
  }

  getDeviceId() async {
    deviceId = await PlatformDeviceId.getDeviceId ?? 'No ID';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        backEnabled: false,
        context: context,
        actions: [
          IconButton(
              onPressed: () {
                NavUtils.navTo(context, SettingsPage());
              },
              icon: const Icon(Icons.settings))
        ],
      ),
      body: Container(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset("assets/images/logo.png", width: 70),
          Text("LOGIN",
              textScaleFactor: 1.0, style: MyTextTheme().headingTextStyle),
          const SizedBox(
            height: 20,
          ),
          FancyTextField(
            validator: (text) {
              if (text == null || text.isEmpty) {
                return "Please enter your username";
              }
              return null;
            },
            label: "Username",
            prefixText: "@",
            mController: username,
          ),
          FancyTextField(
            validator: (text) {
              if (text == null || text.isEmpty) {
                return "Password cannot be empty";
              }
              return null;
            },
            label: "Password",
            isPassword: true,
            mController: password,
          ),
          SizedBox(height: 10),
          Text("$status",
              style: MyTextTheme().smallHintText.copyWith(fontSize: 12)),
          NormalButton(
              label: "CONTINUE",
              verticalPadding: 20,
              onPressed: () async {
                if (username.text.isEmpty || password.text.isEmpty) {
                  setState(() {
                    status = "Enter username and password";
                  });
                  return;
                }
                Settings.init().then((value) {
                  value.username = username.text;
                  value.password = password.text;
                  setState(() {
                    status = "Logged in!";
                  });
                  Future.delayed(const Duration(seconds: 1), () {
                    NavUtils.navToReplace(context, Main());
                  });
                });
              }),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("New user? ", style: MyTextTheme().normalTextStyle),
              GestureDetector(
                child: Text("Create a new account",
                    style: MyTextTheme()
                        .normalTextStyle
                        .copyWith(color: AppColors().primary)),
                onTap: () {
                  NavUtils.navToReplace(context, RegisterPage());
                },
              ),
            ],
          ),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }

  disposeControllers() {
    username.dispose();
    password.dispose();
  }

  void _navTo(Widget dest) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => dest),
    );
  }

  void _navToReplace(Widget dest) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => dest),
    );
  }
}
