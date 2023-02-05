import 'dart:async';

import 'package:flutter/material.dart';

class BlankPage extends StatefulWidget{
  BlankPage({Key? key, this.message, this.heading, this.image, this.action, this.useDefaultActions= false, this.positiveActionText, this.negativeActionText}) : super(key: key);
  String? message, heading;
  Widget? image, action;
  bool useDefaultActions;

  Function()? positiveAction, negativeAction;
  String? positiveActionText, negativeActionText;

  @override
  State<StatefulWidget> createState() {

    return _BlankPageState();
  }


}

class _BlankPageState extends State<BlankPage>{
  bool _initialised = false;
//  late AppState appState;

  @override
  Widget build(BuildContext context) {
//    appState = Provider.of<AppState>(context);
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                widget.image ??Image.asset("assets/images/logo.png", width: 120),
                const SizedBox(height: 20,),
                Padding(padding: const EdgeInsets.all(20), child: Text(widget.heading??"RESOURCE NOT FOUND", textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold))),
                Padding(padding: const EdgeInsets.all(5), child: Text(widget.message ?? "Please try again later", textAlign: TextAlign.center,style:  const TextStyle(fontSize: 12, color: Colors.grey),)),
                widget.useDefaultActions? defaultAction():(widget.action??SizedBox())
              ]
          ),
        ),),
    );
  }

  Widget defaultAction(){
    return Column(
        children:[
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.orange),
                  ),
                  onPressed: widget.positiveAction,
                  child: Container(
                      padding: EdgeInsets.all(7),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Text(widget.positiveActionText??"Okay",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                        SizedBox(width: 10),
                        Icon(Icons.arrow_forward, size: 17)
                      ]))),
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  onPressed: widget.negativeAction??() async {
                    Navigator.pop(context);
                  },
                  child: Container(
                      padding: EdgeInsets.all(7),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Text(widget.negativeActionText??"BACK",
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            )),
                        SizedBox(width: 10),
                        Icon(Icons.arrow_back, size: 17, color: Colors.black)
                      ]))),
            ],
          )
        ]
    );
  }

}