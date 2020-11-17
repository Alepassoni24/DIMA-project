import 'package:dima_project/shared/constants.dart';
import 'package:dima_project/shared/loading.dart';
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
  bool loading = false;

  //piece of state to store value inserted into the form
  String username = '';
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.orange[50],
            appBar: AppBar(
              backgroundColor: Colors.orange[400],
              elevation: 0.0,
              title: Text('Register to CookingTime'),
              actions: [
                FlatButton(
                    onPressed: () {
                      //we take the function from the widget
                      widget.toogleView();
                    },
                    child: Text(
                      'back',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )),
              ],
            ),
            body: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 15.0,
                      ),
                      //field for username
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                          hintText: 'username',
                        ),
                        //val represent whatever will be into the field
                        onChanged: (val) {
                          setState(() => username = val);
                        },
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      //field for email
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                          hintText: 'email',
                        ),
                        validator: (val) =>
                            val.isEmpty ? 'Enter an email' : null,
                        //val represent whatever will be into the field
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      //field for password
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                          hintText: 'password',
                        ),
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
                        height: 15.0,
                      ),
                      RaisedButton(
                        color: Colors.orange[400],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            side: BorderSide(color: Colors.orangeAccent)),
                        child: Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() => loading = true);
                            dynamic result = _auth.registerWithEmailAndPassword(
                                email, password);
                            if (result == null) {
                              setState(() {
                                loading = false;
                                error = 'please supply a valid email';
                              });
                            }
                          }
                        },
                      ),
                    ],
                  ),
                )));
  }
}
