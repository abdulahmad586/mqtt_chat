import 'dart:async';

import 'package:chat/bloc/conveyor/conveyor.dart';
import 'package:chat/bloc/db/litesql_db.dart';
import 'package:chat/models/channel.model.dart';
import 'package:chat/models/message.model.dart';

class ChannelDTO {
  Conveyor conveyor;

  ChannelDTO({required this.conveyor});

  Future<Channel> subscribe(String channelName) {
    Completer<Channel> completer = Completer();
    Message query = Message(
        isReq: true,
        sender: "",
        receivers: ["Server"],
        type: Message.TYPE_COMMAND,
        content: "SUB_CHANNEL",
        payload: channelName);
    // conveyor.addToQueue(query, (Message result) {
    //   if (result.content.toString() == 'success') {
    //     completer.complete(Channel.parseChannel(result.payload));
    //   } else {
    //     completer.completeError(result.content.toString());
    //   }
    // });

    return completer.future;
  }

  Future<bool> unsubscribe(String channelName) {
    Completer<bool> completer = Completer();
    Message query = Message(
        isReq: true,
        sender: "",
        receivers: ["Server"],
        type: Message.TYPE_COMMAND,
        content: "UNSUB_CHANNEL",
        payload: channelName);
    // conveyor.addToQueue(query, (Message result) {
    //   if (result.content.toString() == 'success') {
    //     completer.complete(true);
    //   } else {
    //     completer.completeError(result.content);
    //   }
    // });
    return completer.future;
  }

  Future<List<Channel>> getChannels({String query = ""}) {
    Completer<List<Channel>> completer = Completer();
    Message query = Message(
        isReq: true,
        sender: "",
        receivers: ["Server"],
        type: Message.TYPE_COMMAND,
        content: "LIST_CHANS");
    // conveyor.addToQueue(query, (Message result) {
    //   if (result.content == 'success') {
    //     List<Channel> channels = Channel.parseMany(result.payload);

    //     completer.complete(channels);
    //   } else {
    //     completer.completeError(result.content);
    //   }
    // });
    return completer.future;
  }

  Future<Channel> createChannel(Channel channel) {
    Completer<Channel> completer = Completer();

    Message query = Message(
        isReq: true,
        sender: "",
        receivers: ["Server"],
        type: Message.TYPE_COMMAND,
        content: "CREATE_CHAN",
        payload: channel.toMap());
    // conveyor.addToQueue(query, (Message result) {
    //   if (result.content == 'success') {
    //     completer.complete(Channel.parseChannel(result.payload));
    //   } else {
    //     completer.completeError(result.content);
    //   }
    // });

    return completer.future;
  }

  Future<bool> removeChannel(String channelName) {
    Completer<bool> completer = Completer();

    Message query = Message(
        isReq: true,
        sender: "",
        receivers: ["Server"],
        type: Message.TYPE_COMMAND,
        content: "REMOVE_CHAN",
        payload: channelName);
    // conveyor.addToQueue(query, (Message result) {
    //   if (result.content == 'success') {
    //     completer.complete(true);
    //   } else {
    //     completer.completeError(result.payload);
    //   }
    // });
    return completer.future;
  }

  Future<Channel> getChannel(String channelName) {
    Completer<Channel> completer = Completer();
    Message query = Message(
        isReq: true,
        sender: "",
        receivers: ["Server"],
        type: Message.TYPE_COMMAND,
        content: "GET_CHAN",
        payload: channelName);

    // conveyor.addToQueue(query, (Message result) {
    //   if (result.content == 'success') {
    //     completer.complete(Channel.parseChannel(result.payload));
    //   } else {
    //     completer.completeError(result.content);
    //   }
    // });

    return completer.future;
  }

  static Future<List<Channel>> getChannelsFromDB(DatabaseManager dman,
      {int lastId = 9000000000000, int limit = 20}) async {
    if (!dman.isOpen) {
      await dman.init();
    }
    var result = await dman.queryItems(DatabaseManager.TABLE_CHANNELS,
        where: "id < $lastId", limit: limit, order: "id DESC");
    return Channel.parseMany(result);
  }

  static Future<Channel?> getChannelFromDB(
      DatabaseManager dman, String channelname) async {
    var result = await dman.queryItem(DatabaseManager.TABLE_CHANNELS,
        where: "name = $channelname");
    return result == null ? null : Channel.parseChannel(result);
  }

  static Future<bool> saveToDB(DatabaseManager dman, Channel channel) async {
    if (!dman.isOpen) {
      await dman.init();
    }
    return await dman.addData(DatabaseManager.TABLE_CHANNELS, channel);
  }
}
