import 'dart:typed_data';
import 'package:chat/bloc/state_management/main_cubit.dart';
import 'package:chat/bloc/state_management/main_state.dart';
import 'package:chat/views/shared/blank_page.dart';
import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:flutter/material.dart';
import 'package:chat/models/convo.model.dart';
import 'package:chat/models/message.model.dart';
import 'package:chat/theme/colors.dart';
import 'package:chat/theme/text_theme.dart';
import 'package:chat/views/utils/cib.dart';
import 'package:chat/views/utils/funcs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatefulWidget {
  ChatPage({required this.myUsername, required this.user2});

  String myUsername;
  String user2;

  List<IconData> statIcon = [
    Icons.send,
    Icons.done,
    Icons.done_all,
    Icons.message_rounded,
  ];

  List<String> statTexts = ['Sending', 'Sent', 'Delivered', 'Read'];

  @override
  State createState() {
    return _ChatPageState();
  }
}

class _ChatPageState extends State<ChatPage> {
  String myUsername = '';

  FocusNode _focusNode = FocusNode();
  bool _showRoomAdminMsgs = false;
  TextEditingController _controller = new TextEditingController();
  bool subscribed = false;

  List<ConvoData> _conversations = [];

  static List<IconData> statIcon = [
    Icons.send,
    Icons.done,
    Icons.done_all,
    Icons.message_rounded,
    Icons.refresh,
  ];

  static List<String> statTexts = [
    'Sending',
    'Sent',
    'Delivered',
    'Read',
    'Not sent'
  ];

  ScrollController mcontroller = ScrollController();
  bool isBlocked = false;

  @override
  void initState() {
    myUsername = widget.myUsername;
    _focusNode.addListener(() {
      _moveToBottom();
    });

    mcontroller.addListener(_scrollMListener);
    super.initState();
    joinRoom();
  }

  joinRoom() {
    BlocProvider.of<MainCubit>(context)
        .subscribe(widget.myUsername, incomingMessage)
        .then((value) {
      setState(() {
        subscribed = true;
      });
    });
  }

  _scrollMListener() {
    if (mcontroller != null) {
      if (mcontroller.offset >= mcontroller.position.maxScrollExtent &&
          mcontroller.position.outOfRange) {
        print("Reached bottom main");
      }

      if (mcontroller.offset <= mcontroller.position.minScrollExtent &&
          !mcontroller.position.outOfRange) {
        //reached the top
        print("REACHED THE TOP main");
        // loadConversations(lastId: _conversations.first.time);
      }
    }
  }

  void incomingMessage(Message message) {
    print("New message received " + message.toMap().toString());
    if (!mounted) return;

    if (message.type == Message.TYPE_BROADCAST ||
        message.type == Message.TYPE_PRIVATE) {
      _conversations.add(ConvoData(
          message: message.content,
          sender: message.sender,
          senderId: widget.user2,
          time: message.time,
          stat: ConvoData.STAT_SEEN));
      setState(() {});
      _moveToBottom();
    } else {}
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    mcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return body();
  }

  Widget body() {
    return Scaffold(
        body: BlocListener<MainCubit, MainState>(
      listener: (context, state) {
        if (state.conveyorState == ConveyorState.connected) {
          joinRoom();
          print("READY TO SUBSCRIBE");
        } else {
          print("STILL WAITING TO CONNECT");
        }
      },
      child: _body(),
    ));
  }

  Widget _body() {
    return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: GestureDetector(
          onTap: () {
            _focusNode.unfocus();
          },
          child: Container(
            padding: EdgeInsets.all(5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ListView(
                      controller: mcontroller,
                      children: List.generate(_conversations.length, (i) {
                        ConvoData conversation = _conversations[i];

                        return _textWidget(conversation, i);
                        ;
                      })),
                ),
                Column(children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * .80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey[300]!, blurRadius: 10.0),
                            ],
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: 12.0),
                              Expanded(
                                child: TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  focusNode: _focusNode,
                                  minLines: 1,
                                  maxLines: 4,
                                  controller: _controller,
                                  decoration: InputDecoration(
                                    hintText: "Send a message",
                                    hintStyle:
                                        TextStyle(color: Colors.grey[350]),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ColorIconButton(
                          "",
                          Icons.send,
                          Colors.orange,
                          iconColor: Colors.black,
                          iconSize: 25,
                          onPressed: () {
                            if (_controller.text.isEmpty) return;
                            int convoId = _conversations.length;
                            _conversations.add(ConvoData(
                              message: _controller.text,
                              time: DateTime.now().millisecondsSinceEpoch,
                              senderId: myUsername,
                            ));
                            setState(() {});
                            _moveToBottom();
                            sendMessage(_controller.text, convoId);
                            _controller.text = "";
                          },
                        )
                      ]),
                ]),
              ],
            ),
          ),
        ));
  }

  Widget _roomMessage(ConvoData conversation, int pos) {
    return Container(
        padding: EdgeInsets.all(10.0),
        child: Center(
            child: Column(children: [
          Text(
            conversation.message,
            style: MyTextTheme().normalTextStyle.copyWith(
                fontStyle: FontStyle.italic,
                fontSize: 12,
                color: AppColors().hintText),
          ),
//      Text(conversation.timeStr, style: MyTextTheme().normalTextStyle.copyWith(fontStyle: FontStyle.italic, fontSize: 10, color: AppColors().hintText),)
        ])));
  }

  Widget _textWidget(ConvoData conversation, int pos) {
    return conversation.type != ConvoData.TYPE_TEXT
        ? SizedBox()
        : Container(
            padding: EdgeInsets.all(10.0),
            child: Align(
                alignment: conversation.senderId != myUsername
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    if (conversation.stat == ConvoData.STAT_ERROR) {
                      sendMessage(conversation.message, pos);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * .7),
                    width: conversation.message.length < 40
                        ? (11.0 * conversation.message.length) + 50
                        : null,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(color: Colors.grey[300]!, blurRadius: 10.0)
                        ],
                        color: conversation.senderId != myUsername
                            ? Colors.white
                            : Colors.orange,
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        )),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(conversation.message,
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[700])),
                        Align(
                            alignment: Alignment.bottomRight,
                            child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(statIcon[conversation.stat],
                                      size: 10,
                                      color: conversation.stat !=
                                              ConvoData.STAT_ERROR
                                          ? (conversation.senderId != myUsername
                                              ? Colors.grey[400]
                                              : Colors.white)
                                          : Colors.red),
                                  SizedBox(width: 3.0),
                                  Text(
                                      conversation.stat != ConvoData.STAT_ERROR
                                          ? conversation.timeStr
                                          : "Message not sent",
                                      style: TextStyle(
                                          fontSize: 8,
                                          color: conversation.stat !=
                                                  ConvoData.STAT_ERROR
                                              ? (conversation.senderId !=
                                                      myUsername
                                                  ? Colors.grey[400]
                                                  : Colors.white)
                                              : Colors.red))
                                ])),
                      ],
                    ),
                  ),
                )),
          );
  }

  void sendMessage(String message, int convoId) {
    Future.delayed(const Duration(seconds: 1)).then((value) {
      setState(() {
        _conversations[convoId].stat = ConvoData.STAT_SENT;
        BlocProvider.of<MainCubit>(context).sendMessage(message);
      });
    }).onError((error, stackTrace) {
      Functions.s(context, error.toString());
      setState(() {
        _conversations[convoId].stat = ConvoData.STAT_ERROR;
      });
    });
  }

  void loadConversations({int lastId = 9000000000000}) async {
    // MessageDTO messageDTO =
    //     MessageDTO(conveyor: context.read<MainCubit>().conveyor!);
  }

  _moveToBottom({bool withAnimation = true}) {
    //Future.delayed(Duration(seconds:2), (){
    try {
      if (mcontroller != null) {
        if (withAnimation) {
          mcontroller.animateTo(mcontroller.position.maxScrollExtent,
              curve: Curves.linear, duration: Duration(milliseconds: 500));
        } else {
          mcontroller.jumpTo(mcontroller.position.maxScrollExtent);
        }
      }
    } catch (e) {
      print("Error in moveToBottom: ${e.toString()}");
    }
    //});
  }
}
