import 'package:flutter/material.dart';
import 'package:dima_project/services/auth.dart';

class Register extends StatefulWidget {
  final Function toogleView;

  Register({this.toogleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  //key to identify the form
  final _formKey = GlobalKey<FormState>();

  //piece of state to store value inserted into the form
  String username = '';
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.orangeAccent[100],
        appBar: AppBar(
          backgroundColor: Colors.orangeAccent[400],
          elevation: 0.0,
          title: Text('Register to CookingTime'),
          actions: [
            FlatButton.icon(
                onPressed: () {
                  //we take the function from the widget
                  widget.toogleView();
                },
                icon: Icon(Icons.arrow_back),
                label: Text('back')),
          ],
        ),
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Form(
              key: _formKey,
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
                    validator: (val) => val.isEmpty ? 'Enter an email' : null,
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
                    validator: (val) => val.length < 8
                        ? 'Enter a password of at least 8 characters'
                        : null,
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
                      if (_formKey.currentState.validate()) {
                        dynamic result =
                            _auth.registerWithEmailAndPassword(email, password);
                        if (result == null) {
                          setState(() => error = 'please supply a valid email');
                        }
                      }
                    },
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  Text(
                    error,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            )));
  }
}
