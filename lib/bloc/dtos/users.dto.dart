import 'dart:async';

import 'package:chat/bloc/constants.dart';
import 'package:chat/bloc/conveyor/conveyor.dart';
import 'package:chat/bloc/db/litesql_db.dart';
import 'package:chat/models/message.model.dart';
import 'package:chat/models/rating.model.dart';
import 'package:chat/models/user.model.dart';
import 'package:platform_device_id/platform_device_id.dart';

class UserDTO {
  Conveyor conveyor;

  UserDTO({required this.conveyor});

  Future<User> register(
      String username, String password, String fullname) async {
    Completer<User> completer = Completer();
    User myData = User(
        name: username,
        id: 1234,
        fname: fullname,
        deviceId: await PlatformDeviceId.getDeviceId ?? 'NO ID');
    var map = myData.toMap();
    map["pass"] = password;
    map["appVersion"] = Constants.VERSION_CODE;
    Message query = Message(
        isReq: true,
        sender: "",
        receivers: ["Server"],
        type: Message.TYPE_COMMAND,
        content: "REGISTER",
        payload: map);
    // conveyor.addToQueue(query, (Message result) {
    //   if (result.content == 'success') {
    //     completer.complete(User.parseUser(result.payload));
    //   } else {
    //     completer.completeError(result.payload);
    //   }
    // });
    return completer.future;
  }

  Future<User> login(String username, String password) async {
    Completer<User> completer = Completer();

    User myData = User(
        name: username,
        id: 1234,
        deviceId: await PlatformDeviceId.getDeviceId ?? 'NO ID');
    var map = myData.toMap();
    map["pass"] = password;
    map["appVersion"] = Constants.VERSION_CODE;
    Message query = Message(
        isReq: true,
        sender: "",
        receivers: ["Server"],
        type: Message.TYPE_COMMAND,
        content: "LOGIN",
        payload: map);
    // conveyor.addToQueue(query, (Message result) {
    //   if (result.content == 'success') {
    //     completer.complete(User.parseUser(result.payload));
    //   } else {
    //     completer.completeError(result.payload ?? "");
    //   }
    // });
    completer.complete(myData);

    return completer.future;
  }

  Future<bool> logout() {
    Completer<bool> completer = Completer();

    Message query = Message(
        isReq: true,
        sender: "",
        receivers: ["Server"],
        type: Message.TYPE_COMMAND,
        content: "LOGOUT");
    // conveyor.addToQueue(query, (Message result) {
    //   if (result.content == 'success') {
    //     completer.complete(result.payload);
    //   } else {
    //     completer.completeError(result.content);
    //   }
    // });
    return completer.future;
  }

  Future<bool> blockUser(String username) {
    Completer<bool> completer = Completer();

    Message query = Message(
        isReq: true,
        sender: "",
        receivers: ["Server"],
        type: Message.TYPE_COMMAND,
        content: "BLOCK_USER",
        payload: username);
    // conveyor.addToQueue(query, (Message result) {
    //   if (result.content == 'success') {
    //     completer.complete(true);
    //   } else {
    //     completer.completeError(result.content);
    //   }
    // });
    return completer.future;
  }

  Future<bool> unblockUser(String username) {
    Completer<bool> completer = Completer();

    Message query = Message(
        isReq: true,
        sender: "",
        receivers: ["Server"],
        type: Message.TYPE_COMMAND,
        content: "UNBLOCK_USER",
        payload: username);
    // conveyor.addToQueue(query, (Message result) {
    //   if (result.content == 'success') {
    //     completer.complete(true);
    //   } else {
    //     completer.completeError(result.content);
    //   }
    // });

    return completer.future;
  }

  Future<bool> updateUser(String name, String about) {
    Completer<bool> completer = Completer();

    Message query = Message(
        isReq: true,
        sender: "",
        receivers: ["Server"],
        type: Message.TYPE_COMMAND,
        content: "UPDATE_USER",
        payload: {"fname": name, "about": about});
    // conveyor.addToQueue(query, (Message result) {
    //   if (result.content == 'success') {
    //     completer.complete(true);
    //   } else {
    //     completer.completeError(result.content);
    //   }
    // });

    return completer.future;
  }

  Future<bool> rateUser(String username, double rating,
      {String review = ""}) async {
    Completer<bool> completer = Completer();
    // DatabaseManager dman = conveyor.dman;
    // if (!dman.isOpen) {
    //   await dman.init();
    // }

    // int currentTime = (DateTime.now().millisecondsSinceEpoch / 1000).ceil();
    // const int allowedRatingInterval = 3600; //in seconds
    // bool hasRatedRecently = await dman.itemExists(DatabaseManager.TABLE_RATINGS,
    //     "user = '$username' AND time > ${currentTime - allowedRatingInterval}");
    // if (hasRatedRecently) {
    //   completer.completeError("You have already rated this user!");
    // } else {
    //   Message query = Message(
    //       isReq: true,
    //       sender: "",
    //       receivers: ["Server"],
    //       type: Message.TYPE_COMMAND,
    //       content: "RATE_USER",
    //       payload: {"rating": rating, "review": review});
    //   // conveyor.addToQueue(query, (Message result) {
    //   //   if (result.content == 'success') {
    //   //     dman.addData(
    //   //         DatabaseManager.TABLE_RATINGS,
    //   //         Rating(
    //   //             user: username,
    //   //             rating: rating,
    //   //             id: currentTime,
    //   //             time: currentTime));
    //   //     dman.deleteItemsWhere(DatabaseManager.TABLE_RATINGS,
    //   //         where: "time < ${currentTime - allowedRatingInterval}");
    //   //     completer.complete(true);
    //   //   } else {
    //   //     completer.completeError(result.content);
    //   //   }
    //   // });
    // }
    return completer.future;
  }

  Future<User> getUser(String username) {
    Completer<User> completer = Completer();

    Message query = Message(
        isReq: true,
        sender: "",
        receivers: ["Server"],
        type: Message.TYPE_COMMAND,
        content: "GET_USER",
        payload: username);
    // conveyor.addToQueue(query, (Message result) {
    //   if (result.content == 'success') {
    //     completer.complete(User.parseUser(result.payload));
    //   } else {
    //     completer.complete(result.content);
    //   }
    // });
    return completer.future;
  }

  Future<List<User>> getUsersOnChannel(String channelname) {
    Completer<List<User>> completer = Completer();
    Message query = Message(
        isReq: true,
        sender: "",
        receivers: ["Server"],
        type: Message.TYPE_COMMAND,
        content: "GET_SUBSCRIBERS",
        payload: channelname);
    // conveyor.addToQueue(query, (Message result) {
    //   if (result.content == 'success') {
    //     List<User> users = [];
    //     for (int i = 0; i < result.payload.length; i++) {
    //       users.add(User.parseUser(result.payload[i]));
    //     }
    //     completer.complete(users);
    //   } else {
    //     completer.completeError(result.content);
    //   }
    // });
    return completer.future;
  }

  Future<List<User>> searchUsers({String query = ""}) {
    Completer<List<User>> completer = Completer();
    Message query = Message(
        isReq: true,
        sender: "",
        receivers: ["Server"],
        type: Message.TYPE_COMMAND,
        content: "SEARCH_USERS");
    // conveyor.addToQueue(query, (Message result) {
    //   if (result.content == 'success') {
    //     List<User> users = User.parseMany(result.payload);
    //     completer.complete(users);
    //   } else {
    //     completer.completeError(result.content);
    //   }
    // });
    return completer.future;
  }

  Future<List<User>> getUsersFromDB(
      {int lastContact = 9000000000000, limit = 20}) async {
    // DatabaseManager dman = conveyor.dman;
    // if (!dman.isOpen) {
    //   await dman.init();
    // }
    // print("Getting users");
    // var result = await dman.queryItems(DatabaseManager.TABLE_USERS,
    //     where: "lastContact < $lastContact",
    //     order: "lastContact DESC",
    //     limit: limit);
    // //userMap["lastMessage"] = await dman.queryItem(DatabaseManager.TABLE_MESSAGES, where: "sender = ${userMap["name"]} OR receivers LIKE '%${userMap["name"]}%' ");
    // return User.parseMany(result);
    return [];
  }

  static Future<User?> getUserFromDB(
      DatabaseManager dman, String username) async {
    if (!dman.isOpen) {
      await dman.init();
    }
    var result = await dman.queryItem(DatabaseManager.TABLE_USERS,
        where: "name = $username");
    return result == null ? null : User.parseUser(result);
  }

  static Future<bool> saveUserToDB(DatabaseManager dman, User user) async {
    if (!dman.isOpen) {
      await dman.init();
    }
    return await dman.addData(DatabaseManager.TABLE_USERS, user);
  }
}
