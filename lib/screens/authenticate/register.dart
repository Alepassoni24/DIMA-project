import 'package:flutter/material.dart';
import 'package:dima_project/services/auth.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();

  //piece of state to store value inserted into the form
  String username = '';
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.orangeAccent[100],
        appBar: AppBar(
          backgroundColor: Colors.orangeAccent[400],
          elevation: 0.0,
          title: Text('Register to CookingTime'),
        ),
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Form(
              child: Column(
                children: [
                  SizedBox(
                    height: 20.0,
                  ),
                  //field for username
                  TextFormField(
                    //val represent whatever will be into the field
                    onChanged: (val) {
                      setState(() => username = val);
                    },
                  ),
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
                      'Register',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      print(username);
                      print(email);
                      print(password);
                    },
                  )
                ],
              ),
            )));
  }
}
