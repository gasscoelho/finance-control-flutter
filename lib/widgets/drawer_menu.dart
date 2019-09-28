import 'package:finance_control/util/colors_arsenal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
  final PageController _pageController;
  final FirebaseUser user;

  DrawerMenu(this._pageController, {this.user});

  @override
  Widget build(BuildContext context) {
    final _background = Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
            ColorsArsenal.backgroundColorLight,
            ColorsArsenal.backgroundColorLight
          ])),
    );

    return Drawer(
        child: SafeArea(
      child: Stack(
        children: <Widget>[
          _background,
          ListView(
            children: <Widget>[
              Container(
                child: UserAccountsDrawerHeader(
                  margin: EdgeInsets.only(bottom: 0.0),
                  decoration: BoxDecoration(
                      color: ColorsArsenal.backgroundColorLight,
                      border: Border(
                          bottom:
                              BorderSide(width: 1, color: Color(0x15000000)))),
                  currentAccountPicture: CircleAvatar(
                    radius: 50.0,
                    backgroundColor: ColorsArsenal.backgroundColorLight,
                    backgroundImage: NetworkImage(
                        user.photoUrl),
                  ),
                  accountEmail: Text(
                    user.email,
                    style: TextStyle(
                        color: ColorsArsenal.textColorDark, fontSize: 16.0),
                  ),
                  accountName: Text(
                    user.displayName,
                    style: TextStyle(
                        color: ColorsArsenal.textColorDark,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Home',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  _pageController.jumpToPage(0);
                },
              ),
              ListTile(
                title: Text(
                  'Config',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  _pageController.jumpToPage(1);
                },
              ),
              ListTile(
                title: Text(
                  'About',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  _pageController.jumpToPage(2);
                },
              ),
              ListTile(
                title: Text(
                  'Logout',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          )
        ],
      ),
    ));
  }
}
