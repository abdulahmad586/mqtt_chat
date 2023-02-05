import 'dart:async';
import 'package:chat/store/settings.dart';
import 'package:chat/views/shared/unit/app_bar.dart';
import 'package:chat/views/utils/nav_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat/bloc/state_management/main_cubit.dart';
import 'package:chat/models/user.model.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:chat/views/interfaces/auth/register_page.dart';
import 'package:chat/views/shared/unit/my_text_field.dart';
import 'package:chat/theme/text_theme.dart';
import 'package:chat/theme/colors.dart';
import 'package:chat/views/shared/unit/normal_button.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SettingsPageState();
  }
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController host = TextEditingController();
  TextEditingController port = TextEditingController();

  String status = '';

  @override
  void initState() {
    Settings.init().then((value) {
      host.text = value.host;
      port.text = value.port.toString();
    }).catchError((err) {
      print("Error" + err.toString());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        context: context,
        titleText: "Server Settings",
      ),
      body: Container(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("Setup server connection details",
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
            label: "Hostname",
            prefixText: "",
            mController: host,
            keyboardType: TextInputType.name,
          ),
          FancyTextField(
            validator: (text) {
              if (text == null || text.isEmpty) {
                return "Port cannot be empty";
              }
              return null;
            },
            label: "Port",
            mController: port,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          Text("$status",
              style: MyTextTheme().smallHintText.copyWith(fontSize: 12)),
          NormalButton(
              label: "SAVE",
              verticalPadding: 20,
              icon: Icons.save,
              onPressed: () async {
                if (host.text.isEmpty || port.text.isEmpty) {
                  setState(() {
                    status = "Some fields are missing";
                  });
                  return;
                }
                setState(() {
                  status = "Saving...";
                });
                Settings.init().then((value) {
                  value.host = host.text;
                  value.port = int.parse(port.text);
                  setState(() {
                    status = "Saved!";
                  });
                });
              }),
          const SizedBox(
            height: 20,
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
    host.dispose();
    port.dispose();
  }
}
