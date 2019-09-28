import 'package:finance_control/activities/about.dart';
import 'package:finance_control/activities/config.dart';
import 'package:finance_control/activities/home.dart';
import 'package:finance_control/helpers/authentication_helper.dart';
import 'package:finance_control/util/colors_arsenal.dart';
import 'package:finance_control/widgets/drawer_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Launch extends StatelessWidget {
  final FirebaseUser user;
  final _pageController = PageController();

  Launch(this.user);

  @override
  Widget build(BuildContext context) {
    void _logout(){
      AuthenticationHelper().signOut();
      Navigator.pop(context);
    }
    return PageView(
      controller: null,
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: Text("Finance Control"),
            backgroundColor: ColorsArsenal.primaryColor,
            actions: <Widget>[
              IconButton(
                onPressed: _logout,
                icon: Icon(Icons.exit_to_app),
                color: ColorsArsenal.backgroundColorLight,
              )
            ],
          ),
          body: Home(),
          drawer: DrawerMenu(_pageController, user: user),
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
