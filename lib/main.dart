import 'package:finance_control/inicio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';


void main(){
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Color(0xff0b51c1), // status bar color
  ));
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Inicio(),
  ));
}
