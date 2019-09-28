import 'package:finance_control/activities/home.dart';
import 'package:finance_control/activities/sign_in.dart';
import 'package:finance_control/helpers/authentication_helper.dart';
import 'package:finance_control/helpers/root_manager.dart';
import 'package:finance_control/launch.dart';
import 'package:finance_control/util/colors_arsenal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: ColorsArsenal.primaryColorDark, // status bar color
  ));
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        primaryColor: ColorsArsenal.primaryColor,
        accentColor: ColorsArsenal.primaryColor,
        cursorColor: ColorsArsenal.primaryColor),
    home: SignIn(),
  ));
}
