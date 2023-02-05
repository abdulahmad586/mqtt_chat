import 'dart:async';
import 'dart:typed_data';
import 'package:chat/bloc/conveyor/conveyor.dart';
import 'package:chat/bloc/db/litesql_db.dart';
import 'package:chat/models/message.model.dart';

class MessageDTO {
  Conveyor conveyor;

  MessageDTO({required this.conveyor});

  Future<bool> sendPrivate(String msg, List<String> receivers) async {
    Completer<bool> completer = Completer();
    Message query = Message(
        isReq: true,
        sender: "",
        receivers: receivers,
        type: Message.TYPE_PRIVATE,
        content: msg);
    // conveyor.addToQueue(query, (Message result) async {
    //   if (result.content == 'success') {
    //     if (!conveyor.dman.isOpen) {
    //       await conveyor.dman.init();
    //     }
    //     conveyor.dman.addData(DatabaseManager.TABLE_MESSAGES, query);
    //     completer.complete(true);
    //   } else {
    //     completer.completeError(result.content);
    //   }
    // });

    return completer.future;
  }

  Future<bool> sendBroadcast(String msg, List<String> channels) {
    Completer<bool> completer = Completer();
    Message query = Message(
        isReq: true,
        sender: "",
        receivers: channels,
        type: Message.TYPE_BROADCAST,
        content: msg);
    // conveyor.addToQueue(query, (Message result) async {
    //   if (result.content == 'success') {
    //     completer.complete(true);
    //     if (!conveyor.dman.isOpen) {
    //       await conveyor.dman.init();
    //     }
    //     conveyor.dman.addData(DatabaseManager.TABLE_MESSAGES, query);
    //   } else {
    //     completer.completeError(result.content, null);
    //   }
    // });
    return completer.future;
  }

  bool sendBuffer(
      Uint8List buffer, List<String> recepients, Map<String, dynamic> payload) {
    Message message = Message(
        isReq: false,
        sender: "",
        receivers: recepients,
        type: Message.TYPE_DATA_TRANSFER,
        payload: payload);
    // return conveyor.sendMessage(message, buffer);
    return true;
  }

  Future<List<Message>> getChannelMessages() {
    Completer<List<Message>> completer = Completer();
    completer.complete([
      Message(
          sender: '132132',
          receivers: ['receivers'],
          type: Message.TYPE_PRIVATE)
    ]);
    // Message query = Message(
    //     isReq: true,
    //     sender: "",
    //     receivers: ["Server"],
    //     type: Message.TYPE_COMMAND,
    //     content: "LIST_CHAN_MSGS");
    // conveyor.addToQueue(query, (Message result) {
    //   if (result.content == 'success') {
    //     List<Message> messages = [];
    //     for (var i = 0; i < result.payload.length; i++) {
    //       messages.add(Message.parseMessage(result.payload[i]));
    //     }

    //     completer.complete(messages);
    //   } else {
    //     completer.completeError(result.content);
    //   }
    // });
    return completer.future;
  }

  Future<List<Message>> getOfflineMessages() {
    Completer<List<Message>> completer = Completer();
    Message query = Message(
        isReq: true,
        sender: "",
        receivers: ["Server"],
        type: Message.TYPE_COMMAND,
        content: "GET_USER_MSGS");
    // conveyor.addToQueue(query, (Message result) {
    //   if (result.content == 'success') {
    //     List<Message> messages = Message.parseMany(result.payload);
    //     completer.complete(messages);
    //   } else {
    //     completer.completeError(result.content);
    //   }
    // });
    return completer.future;
  }

  Future<bool> clearOfflineMessages() {
    Completer<bool> completer = Completer();
    Message query = Message(
        isReq: true,
        sender: "",
        receivers: ["Server"],
        type: Message.TYPE_COMMAND,
        content: "CLEAR_USER_MSGS");
    // conveyor.addToQueue(query, (Message result) async {
    //   if (result.content == 'success') {
    //     completer.complete(true);
    //     print("Cleared offline messages");
    //   } else {
    //     print("Unable to clear offline messages");
    //     completer.completeError(result.content, null);
    //   }
    // });
    return completer.future;
  }

  Future<List<Message>> getMessagesFromDB(String receiver,
      {int lastId = 9000000000000, int limit = 20}) async {
    Completer<List<Message>> result = Completer();
    // if (conveyor != null) {
    //   if (!conveyor.dman.isOpen) {
    //     await conveyor.dman.init();
    //   }
    //   var result = await conveyor.dman.queryItems(
    //       DatabaseManager.TABLE_MESSAGES,
    //       where:
    //           "(sender = '$receiver' OR receivers LIKE '%$receiver%') AND id < $lastId",
    //       order: "id DESC",
    //       limit: limit);
    //   return Message.parseMany(result);
    // } else {
    //   return Future.error("Conveyor has not been initialised");
    // }
    return [];
  }

  Future<bool> clearConversation(String handle) async {
    return true;
  }
}
