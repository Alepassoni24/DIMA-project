import 'package:dima_project/services/auth.dart';
import 'package:dima_project/shared/constants.dart';
import 'package:dima_project/shared/loading.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toogleView;

  SignIn({this.toogleView});

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
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.orange[50],
            //appBar: AppBar(
            //  backgroundColor: Colors.orange[400],
            //  elevation: 0.0,
            //  title: Text('Sign In to CookingTime'),
            //),
            body: Center(
              child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 50.0,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20.0,
                        ),
                        //field for email
                        TextFormField(
                          validator: (val) =>
                              val.isEmpty ? 'Enter an email' : null,
                          decoration: textInputDecoration.copyWith(
                            hintText: 'email',
                          ),
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
                          height: 20.0,
                        ),
                        RaisedButton(
                          color: Colors.orange[400],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              side: BorderSide(color: Colors.orange[400])),
                          child: Text(
                            'Sign in',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() => loading = true);
                              dynamic result = _auth.signInWithEmailAndPassword(
                                  email, password);
                              //show error must be defined differently
                              if (result == null) {
                                setState(() {
                                  //error = 'please supply valid credential';
                                  loading = false;
                                });
                              }
                            }
                          },
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        FlatButton(
                          child:
                              Text('If do not have an account register here'),
                          onPressed: () {
                            widget.toogleView();
                          },
                        ), //put into a row with text and flatbutton
                        SizedBox(
                          height: 25.0,
                        ),
                        Row(
                          children: [
                            Divider(
                              height: 5.0,
                              thickness: 5,
                              color: Colors.grey[500],
                            ),
                            Text('or'),
                            Divider(
                              height: 5.0,
                              thickness: 5,
                              color: Colors.grey[500],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 25.0,
                        ),
                        RaisedButton(
                          color: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              side: BorderSide(color: Colors.blueAccent)),
                          child: Text(
                            'Sign in with Facebook',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                            ),
                          ),
                          onPressed: () {},
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        RaisedButton(
                          color: Colors.redAccent[200],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              side: BorderSide(color: Colors.redAccent[200])),
                          child: Text(
                            'Sign in with Google',
                            style: TextStyle(
                              fontSize: 17.0,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  )),
            ));
  }
}
