import 'dart:convert';

import 'package:chat/bloc/utils/string.utils.dart';

class Message {
  static int TYPE_RESPONSE = 0;
  static int TYPE_COMMAND = 1;
  static int TYPE_BROADCAST = 2;
  static int TYPE_PRIVATE = 3;
  static int TYPE_DATA_TRANSFER = 4;

  String sender;
  List<String> receivers;
  dynamic content;
  dynamic payload;
  int type, time, id;
  String reqId;
  bool isReq;

  Message(
      {required this.sender,
      required this.receivers,
      this.content,
      this.payload,
      required this.type,
      this.time = 0,
      this.id = 0,
      this.reqId = "",
      this.isReq = false}) {
    if (isReq) {
      reqId = StringUtils().getRandomString(6);
    }
    if (time != 0) {
      id = time;
    }
  }

  static parseMessage(Map<String, dynamic> obj) {
    return Message(
      reqId: obj.containsKey("reqId") ? obj["reqId"] : '',
      sender: obj.containsKey("sender") ? obj["sender"] : '',
      receivers: obj.containsKey("receivers")
          ? List<String>.from(obj["receivers"] is String
              ? jsonDecode(obj["receivers"])
              : obj["receivers"])
          : [],
      type: obj.containsKey("type") ? obj["type"] : TYPE_BROADCAST,
      time: obj.containsKey("time") ? obj["time"] : 0,
      content: obj.containsKey("content") ? obj["content"] : null,
      payload: obj.containsKey("payload") ? obj["payload"] : null,
    );
  }

  static List<Message> parseMany(List<Map<String, dynamic>> items) {
    return List.generate(items.length, (index) => parseMessage(items[index]));
  }

  toMap({toDb = false}) {
    return {
      "reqId": reqId,
      "id": id,
      "sender": sender,
      "receivers": toDb ? jsonEncode(receivers) : receivers,
      "type": type,
      "time": time,
      "content": content,
      "payload": toDb ? jsonEncode(payload) : payload,
    };
  }
}
