import 'package:chat/bloc/conveyor/conveyor.dart';
import 'package:chat/models/channel.model.dart';
import 'package:chat/models/user.model.dart';

enum RoomState { roaming, in_room, in_private, conn_err }

class ChatsState {
  ChatsState? lastState;
  RoomState? roomState;
  int? currentTab;
  int? lastPrivateMessageId;
  int? lastChannelMessageId;
  List<User>? subscribedUsers = [];
  List<Channel>? subscribedChannels = [];
  Map<String, int>? unreadMessages = {};

  ChatsState(
      {required this.lastState,
      this.roomState = RoomState.roaming,
      this.currentTab = 0,
      this.lastPrivateMessageId = 0,
      this.lastChannelMessageId = 0,
      this.subscribedUsers,
      this.subscribedChannels,
      this.unreadMessages}) {
    if (lastState != null) {
      roomState ??= lastState!.roomState;
      subscribedUsers ??= lastState!.subscribedUsers;
      subscribedChannels ??= lastState!.subscribedChannels;
      currentTab ??= lastState!.currentTab;
      unreadMessages ??= lastState!.unreadMessages;
      lastPrivateMessageId ??= lastState!.lastPrivateMessageId;
      lastChannelMessageId ??= lastState!.lastChannelMessageId;
    }
  }
}
