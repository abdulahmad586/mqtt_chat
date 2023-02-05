import 'dart:async';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:chat/store/settings.dart';
import 'package:flutter/material.dart';
import 'package:chat/bloc/constants.dart';
import 'package:chat/bloc/conveyor/conveyor.dart';
import 'package:chat/bloc/db/hive_db.dart';
import 'package:chat/bloc/dtos/channels.dto.dart';
import 'package:chat/bloc/dtos/messages.dto.dart';
import 'package:chat/bloc/dtos/users.dto.dart';
import 'package:chat/bloc/state_management/main_state.dart';
import 'package:chat/models/channel.model.dart';
import 'package:chat/models/message.model.dart';
import 'package:chat/models/user.model.dart';

class MainCubit extends Cubit<MainState> {
  List<String> notifications = [];
  User? user;
  BuildContext? chatsCubitContext;
  Conveyor? conveyor;
//  String phone1Id = "709fc27cbab46ca7";
//  String phone2Id = "7fbed4ee012a6c45";

  String username = "";
  String password = "";
  bool loggedOut = false;

  MainCubit()
      : super(MainState(
            lastState: null,
            errorStr: "",
            error: false,
            updaterStarted: false,
            conveyorState: ConveyorState.disconnected,
            appState: null));

  connectConveyor() async {
    print("Calling conveyor connector");
    Settings.init().then((value) async {
      conveyor = Conveyor(
          host: value.host,
          port: value.port,
          username: value.username,
          onConnecting: () {
            emit(MainState(
                lastState: state, conveyorState: ConveyorState.connecting));
          },
          onConnected: () {
            if (conveyor != null) {
              conveyor!.publish('online');
            }
            emit(MainState(
                lastState: state, conveyorState: ConveyorState.connected));
          },
          onError: (dynamic error) {
            emit(MainState(
                lastState: state,
                conveyorState: ConveyorState.connection_error,
                appState: AppState.networkError,
                error: true,
                errorStr: error.toString()));
          });

      await conveyor!.connect();
    });

    // conveyor!.initConnection();
  }

  Future<bool> sendMessage(String message) async {
    if (conveyor != null) {
      if (state.conveyorState == ConveyorState.connected) {
        conveyor!.publish(message);
        return Future.value(true);
      } else {
        return Future.error(
            'Unable to subscribe to topic because client is not connected');
      }
    } else {
      return Future.error('Client is offline');
    }
  }

  Future<bool> subscribe(String user2, Function(Message) onMessage) {
    if (conveyor != null) {
      if (state.conveyorState == ConveyorState.connected) {
        return conveyor!.subscribe(user2, onMessage);
      } else {
        return Future.error(
            'Unable to subscribe to topic because client is not connected');
      }
    } else {
      return Future.error('Client is offline');
    }
  }

  Future<User> login(String username, String password) {
    Completer<User> completer = Completer();
    this.username = username;
    this.password = password;
    print("logging in...");
    User user = new User(name: 'John Doe', fname: 'John', id: 12312);

    emit(MainState(
        lastState: state,
        conveyorState: ConveyorState.connected,
        appState: AppState.loggedIn,
        error: false,
        user: user,
        errorStr: null));
    return Future.value(user);
    // if (conveyor != null && conveyor!.connected) {
    //   UserDTO userDTO = UserDTO(conveyor: conveyor!);
    //   userDTO.login(username, password).then((value) {
    //     print("Logged in");
    //     user = value as User?;
    //     emit(MainState(
    //         lastState: state,
    //         conveyorState: ConveyorState.connected,
    //         appState: AppState.loggedIn,
    //         error: false,
    //         user: user,
    //         errorStr: null));
    //     if (user != null) {
    //       HiveDBMan().saveUserData(user!);
    //       HiveDBMan().saveKey(password);
    //     }
    //     completer.complete(user);
    //   }).onError((error, stackTrace) {
    //     print("Login error: " + error.toString());
    //     emit(MainState(
    //         lastState: state,
    //         appState: AppState.loggedOut,
    //         conveyorState: ConveyorState.connected,
    //         error: true,
    //         errorStr: error.toString()));
    //     completer.completeError(error.toString());
    //   });
    // } else {
    //   completer.completeError("Sorry conveyor is not connected ");
    //   print("Sorry conveyor is not connected");
    //   if (conveyor != null) {
    //     conveyor!.initConnection();
    //   }
    // }

    // return completer.future;
  }

  Future<User> register(String username, String password, String fullname) {
    Completer<User> completer = Completer();
    this.username = username;
    this.password = password;
    if (conveyor != null && conveyor!.connected) {
      UserDTO userDTO = UserDTO(conveyor: conveyor!);
      userDTO.register(username, password, fullname).then((user) {
        print("Registered successfully");
        emit(MainState(
            lastState: state,
            conveyorState: ConveyorState.connected,
            appState: AppState.loggedIn,
            error: false,
            user: user,
            errorStr: null));
        if (user != null) {
          HiveDBMan().saveUserData(user);
          HiveDBMan().saveKey(password);
        }
        completer.complete(user);
      }).onError((error, stackTrace) {
        print("Registration error " + error.toString());
        emit(MainState(
            lastState: state,
            appState: AppState.loggedOut,
            conveyorState: ConveyorState.connected,
            error: true,
            errorStr: error.toString()));
        completer.completeError(error.toString());
      });
    } else {
      completer.completeError("Sorry conveyor is not connected ");
      print("Sorry conveyor is not connected ");
      // conveyor?.initConnection();
    }
    return completer.future;
  }

  Future<List<Channel>> getChannels({String query = ""}) {
    ChannelDTO channelDTO = ChannelDTO(conveyor: conveyor!);
    return channelDTO.getChannels(query: query);
  }

  Future<Channel> createChannel(String channelName, String desc) {
    if (conveyor == null || !conveyor!.connected) {
      return Future.error(
          "Conveyor is offline, please check your network connection");
    }

    Channel channel = Channel(name: channelName, desc: desc);

    ChannelDTO channelDTO = ChannelDTO(conveyor: conveyor!);
    return channelDTO.createChannel(channel);
  }

  /*
  Future<bool> joinRoom(String name,{bool isChannel = false, Function(Message message, {Uint8List? buffer})? onMessage}) {
    Completer<bool> completer = Completer();
    if (conveyor==null || !conveyor!.connected) {
        completer.completeError("Conveyor is offline, please check your network connection");
        return completer.future;
    }
    if (isChannel) {
      ChannelDTO channelDTO = ChannelDTO(conveyor: conveyor!);
      channelDTO.subscribe(name).then((value){
        conveyor!.chatRoomMessage = onMessage;
        print("Incoming message handler of conveyor changed to public");
        completer.complete(true);
      }).onError((error, stackTrace) {
        completer.completeError(error.toString());
      });
    } else {
      UserDTO userDTO = UserDTO(conveyor: conveyor!);
      conveyor!.chatRoomMessage = onMessage;
      print("Incoming message handler of conveyor changed to private");
      userDTO.getUser(name).then((value){
        UserDTO.saveUserToDB(conveyor!.dman, value);
      });
      completer.complete(true);
    }
    return completer.future;
  }

  Future<bool> unjoinRoom(String name,{bool isChannel = false}) {
    Completer<bool> completer = Completer();
    conveyor!.chatRoomMessage = null;
    if (conveyor==null || !conveyor!.connected) {
       completer.completeError("Conveyor is offline, please check your network connection");
      return completer.future;
    }
    if (isChannel) {
      ChannelDTO channelDTO = ChannelDTO(conveyor: conveyor!);
      return channelDTO.unsubscribe(name);
    }
    return completer.future;
  }
*/
  Future<List<User>> getUsers(
      {int lastContact = 9000000000000, int limit = 20}) async {
    UserDTO userDTO = UserDTO(conveyor: conveyor!);
    return userDTO.getUsersFromDB(lastContact: lastContact, limit: limit);
  }

  void changeToRegisterState() {
    emit(MainState(lastState: state, shouldLogin: false));
  }

  void changeToLoginState() {
    emit(MainState(lastState: state, shouldLogin: true));
  }

  /*
  Future<bool> sendMessage(String text, List<String> to, {bool isChannel=false}) {
    if (conveyor==null || !conveyor!.connected) {
        return Future.error("Conveyor is offline, please check your network connection");
    }

    MessageDTO messageDTO = MessageDTO(conveyor: conveyor!);
    if(isChannel){
      return messageDTO.sendBroadcast(text, to);
    }else{
      return messageDTO.sendPrivate(text, to);
    }
  }

  Future<List<User>> getChannelUsers(String channelName) {
    UserDTO userDTO = UserDTO(conveyor: conveyor!);
    return userDTO.getUsersOnChannel(channelName);

  }

  void reattachChatroomHandler(void Function(Message message, {Uint8List? buffer}) incomingMessage) {
    if(conveyor!=null){
      conveyor!.chatRoomMessage = incomingMessage;
      print("Handler reattached");
    }
  }
  */
  Future<bool> logout() {
    Completer<bool> completer = Completer();
    loggedOut = true;
    HiveDBMan hiveDBMan = HiveDBMan();
    hiveDBMan.saveKey(null);
    hiveDBMan.saveUserData(null);
    username = "";
    password = "";

    user = null;
    if (conveyor == null) {
      completer.completeError("Conveyor not initialised");
    } else {
      UserDTO userDto = UserDTO(conveyor: conveyor!);
      userDto.logout().then((value) {
        emit(MainState(lastState: state, appState: AppState.loggedOut));
        completer.complete(true);
      }).onError((error, stackTrace) {
        completer.completeError((error.toString()));
      });
    }
    return completer.future;
  }
}
