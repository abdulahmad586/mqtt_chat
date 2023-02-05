import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {

  ImageCard({this.title="", required this.onPressed, required this.imageString, this.subtitle="", this.showMediaIcon=false, this.width=170.0, this.textColor=Colors.grey, this.hideDetails=false});
  final GestureTapCallback onPressed;
  final String title, subtitle;
  final String imageString;
  final bool showMediaIcon, hideDetails;
  final double width;
  final Color textColor;

  @override
  Widget build(BuildContext context) {

    return InkWell(
        splashColor: Colors.white10,
        onTap: onPressed,
        child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Container(
              width: this.width,
//                          color: Colors.yellow,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: this.width,
                      height: (.59*this.width),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12), bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                        color: Colors.white,
                        image: DecorationImage(fit:BoxFit.cover,image: Image.network(this.imageString).image),

                      ),
                      child: Stack(
                        children: [
                          (this.showMediaIcon?Center(
                            child: IconButton(color: Colors.grey,icon:Icon(Icons.play_circle_fill, color:Colors.black), onPressed:(){print('Play media');},),
                          ):SizedBox()),
                        ],
                      )
                  ),
                  hideDetails?SizedBox():Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Text(this.title, style: TextStyle(fontWeight: FontWeight.bold, color: this.textColor),overflow: TextOverflow.ellipsis)
                  ),
                  hideDetails?SizedBox():Padding(
                      padding: EdgeInsets.all(0),
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [SizedBox(width: 70.0, child:Text(this.subtitle, style: TextStyle(color: this.textColor, fontSize: 12),overflow: TextOverflow.ellipsis)), Row(children: [
                          Icon(Icons.visibility, color:this.textColor, size: 15,),
                          Text('4.0',style: TextStyle(color: this.textColor, fontSize: 12),),
                          Icon(Icons.favorite, color: this.textColor, size: 15,),
                          Text('4.1k',style: TextStyle(color: this.textColor, fontSize: 12),),
                        ],)],
                      )
                  )
                ],
              ),
            )
        )
    );
  }
}