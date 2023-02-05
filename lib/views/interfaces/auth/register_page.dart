import 'dart:async';
import 'package:chat/views/utils/nav_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat/bloc/state_management/main_cubit.dart';
import 'package:chat/models/user.model.dart';
import 'package:chat/views/interfaces/auth/login_page.dart';
import 'package:chat/views/shared/unit/my_text_field.dart';
import 'package:chat/theme/text_theme.dart';
import 'package:chat/theme/colors.dart';
import 'package:chat/views/shared/unit/normal_button.dart';
import 'package:platform_device_id/platform_device_id.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController fullname = new TextEditingController();
  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController deviceId = new TextEditingController();

  String status = "";

  @override
  void initState() {
    getDeviceId();
    super.initState();
  }

  getDeviceId() async {
    deviceId.text = await PlatformDeviceId.getDeviceId ?? 'No ID';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            "REGISTER",
            textScaleFactor: 2,
            style: MyTextTheme().headingTextStyle,
          ),
          const SizedBox(
            height: 20,
          ),
          Image.asset("assets/images/logo.png", width: 100),
          const SizedBox(
            height: 20,
          ),
          FancyTextField(
            validator: (s) {},
            mController: fullname,
            label: "Full name",
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
          Text(
            "$status",
            style: MyTextTheme().smallHintText,
          ),
          NormalButton(
              label: "CONTINUE",
              onPressed: () async {
                setState(() {
                  status = "";
                });
                context
                    .read<MainCubit>()
                    .register(username.text, password.text, fullname.text)
                    .then((user) {
                  setState(() {
                    status = "Registered " + user.name;
                  });
                }).onError((error, stackTrace) {
                  setState(() {
                    status = error.toString();
                  });
                });
              }),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Already have an account? ",
                  style: MyTextTheme().normalTextStyle),
              GestureDetector(
                child: Text("Login",
                    style: MyTextTheme()
                        .normalTextStyle
                        .copyWith(color: AppColors().primary)),
                onTap: () {
                  NavUtils.navToReplace(context, LoginPage());
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
    fullname.dispose();
    username.dispose();
    password.dispose();
    deviceId.dispose();
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
