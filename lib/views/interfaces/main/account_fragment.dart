import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat/bloc/app_texts.dart';
import 'package:chat/bloc/dtos/users.dto.dart';
import 'package:chat/bloc/state_management/main_cubit.dart';
import 'package:chat/bloc/state_management/main_state.dart';
import 'package:chat/theme/colors.dart';
import 'dart:ui';
import 'package:chat/theme/text_theme.dart';
import 'package:chat/views/shared/unit/my_text_field.dart';
import 'package:chat/views/utils/cib.dart';
import 'package:chat/views/shared/unit/app_bar.dart';
import 'package:chat/views/shared/unit/normal_button.dart';
import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:chat/views/utils/funcs.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:chat/views/utils/rating_indicator.dart';

class AccountFragment extends StatefulWidget {
  AccountFragment({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AccountFragmentState();
  }
}

class _AccountFragmentState extends State<AccountFragment> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          shadowColor: Colors.white,
          title: Row(children: [
            Text("My ",
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
            Text("Account", style: TextStyle(color: Colors.black45))
          ]),
          elevation: 0,
          actions: [
            PopupMenuButton(
              icon: Icon(Icons.more_horiz, color: Colors.black),
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<String>(
                    value: '1',
                    child: Text('Upgrade account',
                        style: MyTextTheme().popupTextStyle),
                  ),
                  PopupMenuItem<String>(
                      value: '2',
                      child: Text('Change password',
                          style: MyTextTheme().popupTextStyle)),
                  PopupMenuItem<String>(
                    value: '3',
                    child: Text('Report issue',
                        style: MyTextTheme().popupTextStyle),
                  ),
                  PopupMenuItem<String>(
                      value: '4',
                      child:
                          Text("Logout", style: MyTextTheme().popupTextStyle)),
                ];
              },
              onSelected: (string) async {
                switch (string) {
                  case "1":
                    break;
                  case "2":
                    break;
                  case "3":
                    break;
                  case "4":
                    context.read<MainCubit>().logout();
                    break;
                }
              },
            ),
          ],
        ),
        body: _body());
  }

  Widget _body() {
    return BlocBuilder<MainCubit, MainState>(builder: (context, state) {
      return Container(
          child: Center(
              child: Column(children: [
        SizedBox(height: 100.0),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              TextAvatar(
                shape: Shape.Circular,
                text: state.user == null ? 'N L' : state.user!.name,
                numberLetters: 2,
                size: 100,
              ),
              SizedBox(height: 20.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                      state.user == null
                          ? 'Not logged in'
                          : state.user!.name.toUpperCase(),
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  Text("User",
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.normal)),
                  SizedBox(height: 20),
                  Text(
                    state.user == null ? '' : state.user!.about,
                    style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                  ),
                ],
              )
            ],
          ),
        ),
        SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ColorIconButton(
              'Edit profile',
              Icons.edit,
              Colors.white,
              iconColor: AppColors().primary,
              borderColor: AppColors().primary,
              showShadow: false,
              textColor: Colors.grey,
              iconSize: 20,
              textSize: 11,
              onPressed: () async {
                _navTo(EditProfile());
              },
            ),
            ColorIconButton(
                context.read<MainCubit>().user!.totalRating.toStringAsFixed(1),
                Icons.star,
                Colors.white,
                iconColor: AppColors().primary,
                borderColor: AppColors().primary,
                showShadow: false,
                textColor: Colors.grey,
                iconSize: 25,
                textSize: 11,
                onPressed: () {}),
            ColorIconButton(
              'Logout',
              Icons.logout,
              Colors.white,
              iconColor: AppColors().primary,
              borderColor: AppColors().primary,
              showShadow: false,
              textColor: Colors.grey,
              iconSize: 20,
              textSize: 11,
              onPressed: () {
                context.read<MainCubit>().logout();
              },
            ),
          ],
        ),
        SizedBox(
          height: 160.0,
          child: Column(
            children: [
              starRating(5, state.user!.rating["s5"]!.toDouble()),
              starRating(4, state.user!.rating["s4"]!.toDouble()),
              starRating(3, state.user!.rating["s3"]!.toDouble()),
              starRating(2, state.user!.rating["s2"]!.toDouble()),
              starRating(1, state.user!.rating["s1"]!.toDouble()),
            ],
          ),
        ),
      ])));
    });
  }

  void _navTo(Widget dest) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => dest),
    );
  }
}

class EditProfile extends StatefulWidget {
  EditProfile();

  @override
  State<StatefulWidget> createState() {
    return EditProfileState();
  }
}

class EditProfileState extends State<EditProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController aboutController = TextEditingController();

  @override
  void initState() {
    nameController.text = context.read<MainCubit>().user != null
        ? context.read<MainCubit>().user!.name
        : '';
    aboutController.text = context.read<MainCubit>().user != null
        ? context.read<MainCubit>().user!.about
        : '';
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    aboutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(context: context, titleText: "EDIT PROFILE"),
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(height: 15),
          FancyTextField(
            validator: (String? string) {
              if (string == null || string.isEmpty) {
                return "Sorry name cannot be empty";
              } else if (string.contains(" ")) {
                return "No spaces are allowed in a username";
              }
              return null;
            },
            mController: nameController,
            // The validator receives the text that the user has entered.
            textAlign: TextAlign.center,
            enabled: false,
            label: "Username",
          ),
          SizedBox(height: 10),
          FancyTextField(
            validator: (String? string) {
              return null;
            },
            mController: aboutController,
            // The validator receives the text that the user has entered.
            textAlign: TextAlign.center,
            label: "Status",
          ),
          SizedBox(height: 10),
          NormalButton(
            label: "SAVE",
            onPressed: () {
              UserDTO userDTO =
                  UserDTO(conveyor: context.read<MainCubit>().conveyor!);

              userDTO
                  .updateUser(nameController.text, aboutController.text)
                  .then((value) {
                Functions.s(context, "Updated!");
                Navigator.pop(context);
              }).onError((error, stackTrace) {
                Functions.s(context, error.toString());
              });
            },
          ),
        ]),
      ),
    );
  }
}
