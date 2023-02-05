import 'package:flutter/material.dart';
import 'package:chat/bloc/db/litesql_db.dart';
import 'package:chat/models/message.model.dart';
import 'package:chat/models/user.model.dart';
import 'package:chat/views/interfaces/secondary/generic_list_item.dart';
import 'package:chat/views/shared/unit/app_bar.dart';
import 'package:chat/views/utils/funcs.dart';

class TestPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TestPageState();
  }
}

class _TestPageState extends State<TestPage> {
  DatabaseManager dman = DatabaseManager();

  late List<Map<String, dynamic>> testCases;
  User testUser = User(
    id: 213213,
    name: "Hamza",
    isBlocked: false,
    deviceId: "000432000432-2432",
    rating: User.defaultRating,
    about: "Gentle soul in a chaotic mind",
  );

  Message testMessage = Message(
      sender: "Hamza",
      receivers: ["Sani"],
      type: Message.TYPE_PRIVATE,
      payload: {
        "data": [213, 432, 43, 21, 23]
      },
      content: "Hello sani u there?",
      time: 165465476435,
      id: 165465476435,
      isReq: false);

  @override
  void initState() {
    super.initState();
    testCases = [
      {
        'title': 'Database Initialisation',
        'function': () async {
          await dman.init();
          Functions.s(context, "Database initialised");
        },
      },
      {
        'title': 'User creation',
        'function': () async {
          //add new user
          if (await dman.addData(DatabaseManager.TABLE_USERS, testUser)) {
            Functions.s(context, "User added successfully");
          } else {
            Functions.s(context, "Error adding user");
          }
        }
      },
      {
        'title': 'Users retrieval',
        'function': () async {
          //get users
          var usersMap = await dman.queryItems(DatabaseManager.TABLE_USERS);
          print("Gotten users " + usersMap.toString());
        }
      },
      {
        'title': 'Message creation',
        'function': () async {
          //add new user
          if (await dman.addData(DatabaseManager.TABLE_MESSAGES, testMessage)) {
            Functions.s(context, "Message added successfully");
          } else {
            Functions.s(context, "Error adding user");
          }
        }
      },
      {
        'title': 'Message retrieval',
        'function': () async {
          //get messages
          var usersMap = await dman.queryItems(DatabaseManager.TABLE_MESSAGES);
          print("Gotten Messages " + usersMap.toString());
        }
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(context: context, titleText: "TEST PAGE"),
      body: Container(
        child: ListView(
          children: List.generate(testCases.length, (index) {
            return GenericListItem(data: {
              'icon': Icons.info,
              'title': testCases[index]['title'],
              'desc': 'Nada',
              'onPressed': testCases[index]['function'],
            });
          }),
        ),
      ),
    );
  }
}
