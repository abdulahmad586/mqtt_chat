import 'package:chat/bloc/conveyor/conveyor.dart';
import 'package:chat/models/user.model.dart';

enum ConveyorState { disconnected, connecting, connected, connection_error }

enum AppState { loggedIn, loggedOut, networkError }

class MainState {
  bool? error, updaterStarted = false, state, shouldLogin = true;
  String? errorStr = "";
  MainState? lastState;
  AppState? appState;
  ConveyorState? conveyorState;
  Conveyor? conveyor;
  User? user;

  MainState(
      {required this.lastState,
      this.error,
      this.updaterStarted,
      this.errorStr,
      this.user,
      this.shouldLogin = true,
      this.appState,
      this.conveyorState,
      this.conveyor}) {
    if (lastState != null) {
      error ??= lastState!.error!;
      updaterStarted ??= lastState!.updaterStarted!;
      errorStr ??= lastState!.errorStr!;
      appState ??= lastState!.appState;
      conveyorState ??= lastState!.conveyorState;
      conveyor ??= lastState!.conveyor;
      user ??= lastState!.user;
      shouldLogin ??= lastState!.shouldLogin;
    }
  }
}
