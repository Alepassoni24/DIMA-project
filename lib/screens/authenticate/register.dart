import 'package:dima_project/shared/constants.dart';
import 'package:dima_project/shared/form_validators.dart';
import 'package:dima_project/shared/loading.dart';
import 'package:dima_project/shared/warning_alert.dart';
import 'package:flutter/material.dart';
import 'package:dima_project/services/auth.dart';

class Register extends StatefulWidget {
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
  String error;

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : SafeArea(
            child: Scaffold(
                backgroundColor: backgroundColor,
                appBar: AppBar(
                  backgroundColor: mainAppColor,
                  elevation: 0.0,
                  title: Text('Register to CookingTime'),
                ),
                body: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(height: 2.0),
                            WarningAlert(
                              warning: error,
                            ),
                            SizedBox(height: 2.0),
                            Image(
                              image: AssetImage("assets/cookingTime_logo.png"),
                              height: 150.0,
                            ),
                            SizedBox(height: 20.0),
                            //field for username
                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                hintText: 'username',
                              ),
                              validator: UsernameFieldValidator.validate,
                              //val represent whatever will be into the field
                              onChanged: (val) {
                                setState(() => username = val);
                              },
                            ),
                            SizedBox(height: 15.0),
                            //field for email
                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                hintText: 'email',
                              ),
                              validator: EmailFieldValidator.validate,
                              //val represent whatever will be into the field
                              onChanged: (val) {
                                setState(() => email = val);
                              },
                            ),
                            SizedBox(height: 15.0),
                            //field for password
                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                hintText: 'password',
                              ),
                              validator: PasswordFieldValidator.validate,
                              obscureText: true,
                              //val represent whatever will be into the field
                              onChanged: (val) {
                                setState(() => password = val);
                              },
                            ),
                            SizedBox(height: 15.0),
                            //button for the registration routine
                            RaisedButton(
                              color: mainAppColor,
                              shape: roundedBorder,
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
                                  dynamic result =
                                      await _auth.registerWithEmailAndPassword(
                                          email, password, username);
                                  if (result == null) {
                                    setState(() {
                                      loading = false;
                                      error = 'please supply a valid email';
                                    });
                                  } else {
                                    setState(() {
                                      loading = false;
                                      Navigator.pop(context);
                                    });
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ))),
          );
  }
}
