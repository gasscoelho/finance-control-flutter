import 'package:finance_control/activities/sign_in.dart';
import 'package:finance_control/helpers/authentication_helper.dart';
import 'package:finance_control/launch.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class RootManager extends StatefulWidget {
  @override
  _RootManagerState createState() => _RootManagerState();
}

class _RootManagerState extends State<RootManager> {
  FirebaseUser _user;

  @override
  void initState() {
    super.initState();
    AuthenticationHelper().signOut();
    print('Hey');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthenticationHelper().currentUser(),
      builder: (context, snapshot) {
        return snapshot.data == null ? SignIn() : Launch(snapshot.data);
      },
    );
  }
}
