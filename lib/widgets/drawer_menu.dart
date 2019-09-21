import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
  final PageController _pageController;

  DrawerMenu(this._pageController);

  @override
  Widget build(BuildContext context) {
    final _background = Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[Color(0xff4285F4), Color(0xff9fc1f9)])),
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
                  currentAccountPicture: CircleAvatar(
                    radius: 50.0,
                    backgroundImage: NetworkImage(
                        'https://avatars3.githubusercontent.com/u/33602013?s=400&u=67e085abb0eae2db24ce05c35da8252217c84e43&v=4'),
                  ),
                  accountEmail: Text('gaaucocoelho@gmail.com'),
                  accountName: Text('Gabriel Coelho'),
                ),
              ),
              ListTile(
                title: Text('Home'),
                onTap: () {
                  _pageController.jumpToPage(0);
                },
              ),
              ListTile(
                title: Text('Config'),
                onTap: () {
                  _pageController.jumpToPage(1);
                },
              ),
              ListTile(
                title: Text('About'),
                onTap: () {
                  _pageController.jumpToPage(2);
                },
              ),
              ListTile(
                title: Text('Logout'),
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
