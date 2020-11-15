import 'package:dima_project/services/auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.orangeAccent[100],
        appBar: AppBar(
          backgroundColor: Colors.orangeAccent[400],
          elevation: 0.0,
          title: Text('Sign In to CookingTime'),
        ),
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: RaisedButton(
              child: Text('Sign In'),
              onPressed: () async {
                dynamic result = await _auth.signInWithEmailAndPassword();
                if (result == null) {
                  print('error signing in');
                } else {
                  print('signed in');
                  print(result.uid);
                }
              },
            )));
  }
}
