import 'package:dima_project/services/auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();

  //piece of state to store value inserted into the form
  String email = '';
  String password = '';

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
            child: Form(
              child: Column(
                children: [
                  SizedBox(
                    height: 20.0,
                  ),
                  //field for email
                  TextFormField(
                    //val represent whatever will be into the field
                    onChanged: (val) {
                      setState(() => email = val);
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  //field for password
                  TextFormField(
                    obscureText: true,
                    //val represent whatever will be into the field
                    onChanged: (val) {
                      setState(() => password = val);
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  RaisedButton(
                    color: Colors.orangeAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side: BorderSide(color: Colors.orangeAccent)),
                    child: Text(
                      'Sign in',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      print(email);
                      print(password);
                    },
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text('If do not have an account register here'),
                ],
              ),
            )));
  }
}
