import 'dart:ui';
import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context){
  return AppBar(
    title: Image.asset("assets/images/logo.png",height: 30,),
  );
}
InputDecoration bottomBorderBlueOnFocus(String inputText){
  return InputDecoration(
      hintText: inputText,
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue)
      ),
  );
}