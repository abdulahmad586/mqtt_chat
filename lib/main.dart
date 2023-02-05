import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:chat/bloc/runtime_initializer.dart';
import 'package:chat/bloc/state_management/chats_cubit.dart';
import 'package:chat/bloc/state_management/main_cubit.dart';
import 'package:chat/bloc/state_management/main_observer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat/theme/colors.dart';
import 'package:chat/views/interfaces/main_page.dart';

void main() async {
  await RuntimeInitializer.initializeAll();
  BlocOverrides.runZoned(
    () => runApp(MyApp()),
    blocObserver: MainObserver(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<MainCubit>(
      create: (_) {
        return MainCubit();
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: ' ',
        theme: ThemeData(
          primarySwatch: AppColors().primary as MaterialColor,
        ),
        home: const MainPage(),
      ),
    );
  }
}
