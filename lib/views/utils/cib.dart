import 'package:flutter/material.dart';

class ColorIconButton extends StatelessWidget{

  final String label;
  final IconData icon;
  final Color color;
  final Color iconColor, textColor;
  final Color? borderColor;
  final double iconSize, textSize;
  final Function() onPressed;
  final Widget? badge, child;
  final bool showShadow;
  final String? imageIcon;
  final BoxShape shape;

  ColorIconButton(this.label, this.icon, this.color, {this.borderColor, this.child, this.iconColor=Colors.white, this.textColor=Colors.black, this.iconSize=25, this.textSize=13, required this.onPressed, this.badge, this.shape = BoxShape.circle, this.showShadow=true, this.imageIcon});

  @override
  Widget build(BuildContext context) {

    return Stack(

        children:[
          InkWell(
            borderRadius: BorderRadius.all(Radius.circular(40.0)),

            splashColor: color,
            onTap: onPressed,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(.37*iconSize),
                  child: imageIcon==null ? Center(child: child!=null?child:Icon(
                    icon,
                    color: iconColor,
                    size: iconSize,
                  )):Container(),
                  decoration:
                  BoxDecoration(
                      border: borderColor==null?null:Border.all(color: borderColor!),
                      color: color,
                      shape: shape,
                      borderRadius: shape==BoxShape.circle?null:BorderRadius.all(Radius.circular(10)),
                      boxShadow: showShadow?[
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.15),
                          blurRadius: 10.0,
                        ),BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.15),
                          blurRadius: 10.0,
                        ),

                      ]:[],

                      image: imageIcon !=null ? DecorationImage(image: Image.network(imageIcon!).image, fit:BoxFit.cover):null
                  ),

                ),

                SizedBox(
                  height: (label==null || label.isEmpty)?0:5.0,
                ),
                (label==null || label.isEmpty?SizedBox():Text(label, style: TextStyle(color: textColor, fontSize: textSize),)),
              ],
            ),
          ),
          (this.badge==null?Container():this.badge!)
        ]
    );
  }

}
class ColorIconButton2 extends StatelessWidget{

  final String label;
  final IconData icon;
  final Color color;
  final Color iconColor, textColor;
  final Color? borderColor;
  final double iconSize, textSize;
  final Widget? badge, child;
  final bool showShadow;
  final String? imageIcon;
  final BoxShape shape;

  ColorIconButton2(this.label, this.icon, this.color, {this.borderColor, this.child, this.iconColor=Colors.white, this.textColor=Colors.black, this.shape=BoxShape.circle, this.iconSize=25, this.textSize=13, this.badge, this.showShadow=true, this.imageIcon});

  @override
  Widget build(BuildContext context) {

    return Stack(
        children:[
          Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(.37*iconSize),
                child: imageIcon==null ? Center(child: child!=null?child:Icon(
                  icon,
                  color: iconColor,
                  size: iconSize,
                )):Container(),
                decoration:
                BoxDecoration(
                    border: borderColor==null?null:Border.all(color: borderColor!),
                    color: color,
                    shape: shape,
                    borderRadius: shape==BoxShape.circle?null:BorderRadius.all(Radius.circular(10)),
                    boxShadow: showShadow?[
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.15),
                        blurRadius: 10.0,
                      ),BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.15),
                        blurRadius: 10.0,
                      ),

                    ]:[],

                    image: imageIcon !=null ? DecorationImage(image: Image.network(imageIcon!).image, fit:BoxFit.cover):null
                ),
              ),

              (label==null || label.isEmpty)?SizedBox():SizedBox(
                height: 5.0,
              ),
              (label==null || label.isEmpty?SizedBox():Text(label, style: TextStyle(color: textColor, fontSize: textSize),)),
            ],
          ),

          (this.badge==null?Container():this.badge!)
        ]
    );
  }

}

class MyButton extends StatelessWidget{

  MyButton({Key? key, this.text = "", this.icon,required this.onPressed}) : super(key: key);
  String text;
  Function() onPressed;
  IconData? icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor:
          MaterialStateProperty.all(Colors.white),
        ),
        onPressed: onPressed,
        child: Container(
            padding: EdgeInsets.all(7),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Text(text,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  )),
                  icon==null?SizedBox():SizedBox(width: 10),
                  icon==null?SizedBox():Icon(icon,
                  size: 17, color: Colors.blue)
            ]
            )
        )
    );
  }

}