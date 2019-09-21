import 'package:finance_control/activities/about.dart';
import 'package:finance_control/activities/config.dart';
import 'package:finance_control/activities/home.dart';
import 'package:finance_control/widgets/drawer_menu.dart';
import 'package:flutter/material.dart';

class Inicio extends StatelessWidget {
  final _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: null,
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: Text("Finance Control"),
            backgroundColor: Color(0xff4285F4),
          ),
          body: Home(),
          drawer: DrawerMenu(_pageController),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Finance Control"),
            backgroundColor: Color(0xff4285F4),
          ),
          body: Config(),
          drawer: DrawerMenu(_pageController),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Finance Control"),
            backgroundColor: Color(0xff4285F4),
          ),
          body: About(),
          drawer: DrawerMenu(_pageController),
        ),
      ],
    );
  }
}
