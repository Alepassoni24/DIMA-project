import 'package:dima_project/services/auth.dart';
import 'package:dima_project/shared/constants.dart';
import 'package:dima_project/shared/form_validators.dart';
import 'package:dima_project/shared/loading.dart';
import 'package:dima_project/shared/warning_alert.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  //key to identify the form
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  //piece of state to store value inserted into the form
  String email = '';
  String password = '';
  String error;

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : SafeArea(
            child: Scaffold(
                backgroundColor: Colors.orange[50],
                body: Center(
                  child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 50.0,
                      ),
                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 2.0,
                              ),
                              WarningAlert(
                                warning: error,
                              ),
                              SizedBox(
                                height: 2.0,
                              ),
                              Image(
                                image:
                                    AssetImage("assets/cookingTime_logo.png"),
                                height: 150.0,
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              //field for email
                              TextFormField(
                                validator: EmailFieldValidator.validate,
                                decoration: textInputDecoration.copyWith(
                                  hintText: 'email',
                                ),
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
                                validator: PasswordFieldValidator.validate,
                                decoration: textInputDecoration.copyWith(
                                  hintText: 'password',
                                ),
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
                                    side:
                                        BorderSide(color: Colors.orange[400])),
                                child: Text(
                                  'Sign in',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  ),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    setState(() => loading = true);
                                    dynamic result =
                                        await _auth.signInWithEmailAndPassword(
                                            email, password);
                                    //show error must be defined differently
                                    if (result == null) {
                                      setState(() {
                                        error =
                                            'please supply valid credential';
                                        loading = false;
                                      });
                                    }
                                  }
                                },
                              ),
                              FlatButton(
                                child: Text(
                                  'Forgot password?',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/resetPsw');
                                },
                              ),
                              FlatButton(
                                child: Text(
                                  'If do not have an account register here',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/register');
                                },
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: new Container(
                                      margin: const EdgeInsets.only(
                                        right: 20.0,
                                      ),
                                      child: Divider(
                                        color: Colors.grey[900],
                                        height: 36,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "or",
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  Expanded(
                                    child: new Container(
                                        margin: const EdgeInsets.only(
                                          left: 20.0,
                                        ),
                                        child: Divider(
                                          color: Colors.grey[900],
                                          height: 36,
                                        )),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              ButtonTheme(
                                minWidth: 225.0,
                                child: RaisedButton(
                                  color: Colors.blueAccent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      side:
                                          BorderSide(color: Colors.blueAccent)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image(
                                        image: AssetImage("assets/fb_logo.png"),
                                        height: 20.0,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Text(
                                          'Sign in with Facebook',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  onPressed: () async {
                                    setState(() => loading = true);
                                    dynamic result =
                                        await _auth.signInWithFacebook();
                                    if (result == null) {
                                      setState(() {
                                        loading = false;
                                        error =
                                            'An error occured during you Facebook login';
                                      });
                                    }
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              ButtonTheme(
                                minWidth: 225.0,
                                child: RaisedButton(
                                  color: Colors.red[300],
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      side: BorderSide(color: Colors.red[300])),
                                  child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image(
                                          image: AssetImage(
                                              "assets/signin_google.png"),
                                          height: 20.0,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 10.0,
                                            right: 20.0,
                                          ),
                                          child: Text(
                                            'Sign in with Google',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ]),
                                  onPressed: () async {
                                    setState(() => loading = true);
                                    dynamic result =
                                        await _auth.signInWithGoogle();
                                    if (result == null) {
                                      setState(() {
                                        loading = false;
                                        error =
                                            'An error occured during you Google login';
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                )),
          );
  }
}
