import 'package:flutter/material.dart';

class FancyTextField extends StatelessWidget {

  FancyTextField({this.mController, this.icon, this.textStyle, this.minLines =1, this.onChanged, this.enabled =true,this.maxLines=1,this.keyboardType= TextInputType.name,this.label, this.labelStyle, this.isActive=false, this.hint, this.hintStyle, this.prefixText="", this.isPassword = false, this.validatorText="Please enter a correct value", required this.validator, this.paddingVertical=5.0, this.paddingHorizontal=20, this.textAlign});
  String? label, hint, prefixText, validatorText;
  final IconData? icon;
  bool isPassword=false;
  final TextEditingController? mController;
  final String? Function(String?) validator;
  bool isActive, enabled;
  TextStyle? hintStyle;
  TextStyle? labelStyle;
  TextStyle? textStyle;
  int minLines;
  int maxLines;

  double paddingVertical, paddingHorizontal;

  TextAlign? textAlign;
  Function(String)? onChanged;
  TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {

    if(mController !=null && mController!.text.isNotEmpty){
      this.label = hint;
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      padding: EdgeInsets.symmetric(vertical: paddingVertical, horizontal: paddingHorizontal),
      decoration: BoxDecoration(
          color: !isActive?Colors.white:Color.fromARGB(40, 0, 0, 0),
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(color:Colors.grey[200]!, blurRadius: 3, spreadRadius: 3, offset: Offset(-3,3))
          ]

      ),
      child: TextFormField(
        controller: mController,
        obscureText: isPassword,
        // The validator receives the text that the user has entered.
        validator: validator,
        onChanged: onChanged,
        textAlign: textAlign??TextAlign.left,
        style: textStyle?? const TextStyle(fontSize: 14),
        minLines: minLines,
        maxLines: maxLines,
        enabled: enabled,
        keyboardType: keyboardType,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintStyle: hintStyle ?? const TextStyle(fontSize: 14),
            labelStyle: labelStyle ?? const TextStyle(fontSize: 14),
            suffixIcon: icon == null?null:Icon(icon, size: 14),
            hintText: this.hint,
            prefixText: this.prefixText,
            labelText: this.label
        ),
      ),
    );

  }
}

class FancyCheckField extends StatelessWidget {

  FancyCheckField({this.icon, required this.onChanged, this.enabled =true, this.shadow=true,required this.label, this.labelStyle, this.hint, this.hintStyle});
  String? label, hint;
  final IconData? icon;
  bool enabled, shadow;
  TextStyle? hintStyle;
  TextStyle? labelStyle;
  Function(bool?) onChanged;

  @override
  Widget build(BuildContext context) {

    return Container(
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: shadow?[
              BoxShadow(color:Colors.grey[200]!, blurRadius: 3, spreadRadius: 3, offset: Offset(-3,3))
            ]:[]

        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                hint==null?SizedBox():Text(hint!, style: hintStyle),
                Text(label!, style: labelStyle),
              ],
            ),
            Checkbox(
              value: enabled,
              onChanged: onChanged,
              activeColor: Colors.orange,
            )
          ],
        )
    );

  }
}