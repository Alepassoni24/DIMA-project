import 'package:dima_project/screens/authenticate/register.dart';
import 'package:dima_project/screens/authenticate/sign_in.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  @override
  bool showSignIn = true;

  void toogleView() {
    setState(() => showSignIn = !showSignIn);
  }

  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(toogleView: toogleView);
    } else {
      return Register(toogleView: toogleView);
    }
  }
}
