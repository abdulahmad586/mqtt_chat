import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:chat/bloc/state_management/main_cubit.dart';
import 'package:chat/bloc/state_management/main_state.dart';
import 'package:chat/views/interfaces/auth/settings.dart';
import 'package:chat/views/interfaces/secondary/chat_room.dart';
import 'package:chat/views/shared/nav_drawer.dart';
import 'package:chat/views/shared/unit/normal_button.dart';
import 'package:chat/views/utils/nav_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatusPage extends StatefulWidget {
  StatusPage();

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocBuilder<MainCubit, MainState>(builder: (context, state) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.info),
            Text(state.conveyorState.toString()),
            const SizedBox(height: 20),
            Text(state.errorStr.toString()),
            const SizedBox(height: 20),
            NormalButton(
              label: 'RECONNECT',
              onPressed: () {
                BlocProvider.of<MainCubit>(context).connectConveyor();
              },
            )
          ],
        ),
      );
    }));
  }
}
