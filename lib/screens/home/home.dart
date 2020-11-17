import 'package:dima_project/services/auth.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  //value to manage the authentication particulr sign out phase, would be moved if sign out function is implemented somewhere else
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //temporary in order to test functionalities
      appBar: AppBar(
        actions: [
          FlatButton(
              onPressed: () {
                _auth.signOut();
              },
              child: Text('Sign out'))
        ],
      ),
      backgroundColor: Colors.orangeAccent[100],
      body: Text('Home'),
    );
  }
}
