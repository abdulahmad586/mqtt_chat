import 'dart:async';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:chat/bloc/conveyor/conveyor.dart';
import 'package:chat/bloc/dtos/channels.dto.dart';
import 'package:chat/bloc/dtos/messages.dto.dart';
import 'package:chat/bloc/dtos/users.dto.dart';
import 'package:chat/bloc/state_management/chats_state.dart';
import 'package:chat/models/channel.model.dart';
import 'package:chat/models/message.model.dart';
import 'package:chat/models/user.model.dart';

class ChatsCubit extends Cubit<ChatsState> {
  Conveyor conveyor;

  ChatsCubit(this.conveyor)
      : super(ChatsState(
            lastState: null,
            subscribedChannels: [],
            subscribedUsers: [],
            unreadMessages: {})) {
    getOfflineMessages();
    setupMessageLogger();
  }

  void setupMessageLogger() {
    conveyor.messageLogger = onMessage;
  }

  void onMessage(Message message) {
    if (message.type == Message.TYPE_PRIVATE) {
      emit(ChatsState(lastState: state, lastPrivateMessageId: message.id));
    } else if (message.type == Message.TYPE_BROADCAST) {
      emit(ChatsState(lastState: state, lastChannelMessageId: message.id));
    }
  }

  void getOfflineMessages() {
    if (!conveyor.connected) {
      checkConveyor();
    }
    MessageDTO messageDTO = MessageDTO(conveyor: conveyor);
    messageDTO.getChannelMessages().then((value) {
      if (value.isEmpty) {
        print("No offline messages");
      }
      for (var element in value) {
        // conveyor.onMessageReceived(element, Uint8List.fromList([]));
      }
      messageDTO.clearOfflineMessages();
    }).onError((error, stackTrace) {
      print("Error getting offline messages");
    });
  }

  checkConveyor() {
    if (!conveyor.connected) {
      emit(ChatsState(lastState: state, roomState: RoomState.conn_err));
    }
  }

  Future<bool> joinRoom(String name,
      {bool isChannel = false,
      Function(Message message, {Uint8List? buffer})? onMessage}) {
    Completer<bool> completer = Completer();
    if (!conveyor.connected) {
      checkConveyor();
      completer.completeError(
          "Conveyor is offline, please check your network connection");
      return completer.future;
    }
    if (isChannel) {
      ChannelDTO channelDTO = ChannelDTO(conveyor: conveyor);
      channelDTO.subscribe(name).then((value) {
        try {
          conveyor.chatRoomMessage = onMessage;
          completer.complete(true);
          List<Channel> channels = List.from(state.subscribedChannels ?? []);
//            List<Channel> channels = List.from(state.subscribedChannels??[]);
          int index = channels.indexWhere((element) {
            return element.name == value.name;
          });
          if (index == -1) {
            print("We have a new channel, adding to " +
                channels.length.toString());
            channels.add(value);
            emit(ChatsState(lastState: state, subscribedChannels: channels));
            // ChannelDTO.saveToDB(conveyor.dman, value);
          } else {
            print("Channel already on the list");
          }
        } catch (e) {
          print("Gotcha!! " + e.toString());
        }
      }).onError((error, stackTrace) {
        if (!completer.isCompleted) {
          completer.completeError(error.toString());
        } else {
          print("Channel subscription has completed but with error " +
              error.toString());
        }
      });
    } else {
      UserDTO userDTO = UserDTO(conveyor: conveyor);
      conveyor.chatRoomMessage = onMessage;
//      print("Incoming message handler of conveyor changed to private");
      userDTO.getUser(name).then((value) {
        List<User> users = List.from(state.subscribedUsers ?? []);
        int index = users.indexWhere((element) {
          return element.name == value.name;
        });
        if (index == -1) {
          users.add(value);
          emit(ChatsState(lastState: state, subscribedUsers: users));
        }
        // UserDTO.saveUserToDB(conveyor.dman, value);
      });
      completer.complete(true);
    }
    return completer.future;
  }

  Future<bool> unjoinRoom(Object room, {bool isChannel = false}) {
    Completer<bool> completer = Completer();
    conveyor.chatRoomMessage = null;
    if (!conveyor.connected) {
      checkConveyor();
      completer.completeError(
          "Conveyor is offline, please check your network connection");
      return completer.future;
    }
    if (isChannel) {
      ChannelDTO channelDTO = ChannelDTO(conveyor: conveyor);
      channelDTO.unsubscribe((room as Channel).name).then((value) {
        state.subscribedChannels!.remove((room));
        emit(ChatsState(
            lastState: state, subscribedChannels: state.subscribedChannels));
        completer.complete(true);
      });
    } else {
      state.subscribedUsers!.remove(room as User);
      emit(
          ChatsState(lastState: state, subscribedUsers: state.subscribedUsers));
      completer.complete(true);
    }
    return completer.future;
  }

  Future<bool> sendMessage(String text, List<String> to,
      {bool isChannel = false}) {
    if (!conveyor.connected) {
      return Future.error(
          "Conveyor is offline, please check your network connection");
    }

    MessageDTO messageDTO = MessageDTO(conveyor: conveyor);
    if (isChannel) {
      return messageDTO.sendBroadcast(text, to);
    } else {
      return messageDTO.sendPrivate(text, to);
    }
  }

  Future<List<User>> getChannelUsers(String channelName) {
    UserDTO userDTO = UserDTO(conveyor: conveyor);
    return userDTO.getUsersOnChannel(channelName);
  }

  void reattachChatroomHandler(
      void Function(Message message, {Uint8List? buffer}) incomingMessage) {
//    if(conveyor!=null){
    conveyor.chatRoomMessage = incomingMessage;
//      print("Handler reattached");
//    }
  }

  void addUnreadMessages(String handle, int num) {
    if (state.unreadMessages!.containsKey(handle)) {
      state.unreadMessages![handle] = state.unreadMessages![handle]! + num;
    } else {
      state.unreadMessages![handle] = num;
    }
    emit(ChatsState(lastState: state, unreadMessages: state.unreadMessages));
  }

  int getUnreadMessages(String handle) {
    return state.unreadMessages![handle] ?? 0;
  }

  List<Channel> getActiveChannels() {
    return state.subscribedChannels ?? [];
  }

  void changeTab(int index) {
    emit(ChatsState(lastState: state, currentTab: index));
  }
}
