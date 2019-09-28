import 'package:finance_control/helpers/authentication_helper.dart';
import 'package:finance_control/launch.dart';
import 'package:finance_control/util/colors_arsenal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _titleGoogle = Text(
    'Sign in with Google',
    style: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.w700,
        color: ColorsArsenal.textColorDark),
  );
  final _imageSignInGoogle =
      Image.asset('assets/images/google.png', height: 72.0);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthenticationHelper().currentUser(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Material(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: _titleGoogle,
                ),
                GestureDetector(
                  onTap: signInWithGoogle,
                  child: _imageSignInGoogle,
                )
              ],
            ),
          );
        } else {
          return Launch(snapshot.data);
        }
      },
    );
  }

  void signInWithGoogle() async {
    try {
      AuthenticationHelper auth = AuthenticationHelper();
      final _user = await auth.signInWithGoogle();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Launch(_user)));
    } catch (e) {
      debugPrint('Error Google: ' + e.toString());
    } finally {}
  }
}
