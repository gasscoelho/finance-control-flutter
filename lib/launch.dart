import 'package:finance_control/activities/about.dart';
import 'package:finance_control/activities/config.dart';
import 'package:finance_control/activities/home.dart';
import 'package:finance_control/util/colors_arsenal.dart';
import 'package:finance_control/widgets/drawer_menu.dart';
import 'package:flutter/material.dart';

class Launch extends StatelessWidget {
  final _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: null,
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: Text("Finance Control"),
            backgroundColor: ColorsArsenal.primaryColor,
          ),
          body: Home(),
          drawer: DrawerMenu(_pageController),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Finance Control"),
            backgroundColor: ColorsArsenal.primaryColor,
          ),
          body: Config(),
          drawer: DrawerMenu(_pageController),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Finance Control"),
            backgroundColor: ColorsArsenal.primaryColor,
          ),
          body: About(),
          drawer: DrawerMenu(_pageController),
        ),
      ],
    );
  }
}
