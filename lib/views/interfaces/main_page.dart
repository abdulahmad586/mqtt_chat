import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat/bloc/state_management/main_cubit.dart';
import 'package:chat/bloc/state_management/main_state.dart';
import 'package:chat/views/interfaces/auth/login_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, MainState>(builder: (context, state) {
      return LoginPage();
    });
  }

  @override
  void initState() {
    // context.read<MainCubit>().connectConveyor();
    super.initState();
  }
}
