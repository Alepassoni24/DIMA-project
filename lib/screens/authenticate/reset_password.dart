import 'package:dima_project/services/auth.dart';
import 'package:dima_project/shared/constants.dart';
import 'package:dima_project/shared/form_validators.dart';
import 'package:dima_project/shared/loading.dart';
import 'package:dima_project/shared/warning_alert.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final AuthService _auth = AuthService();
  //key to identify the form
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  //piece of state to store value inserted into the form
  String email = '';
  String message;

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text('Forgot password'),
              backgroundColor: mainAppColor,
              elevation: 0.0,
            ),
            backgroundColor: backgroundColor,
            body: Container(
              padding: EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 50.0,
              ),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 2.0),
                      WarningAlert(
                        warning: message,
                      ),
                      SizedBox(height: 20.0),
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
                      SizedBox(height: 15.0),
                      //button to activate the forgotten password procedure
                      RaisedButton(
                        color: Colors.orange[400],
                        shape: roundedBorder,
                        child: Text(
                          'Send reset password email',
                          style: textButtonStyle,
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() => loading = true);
                            dynamic result = await _auth.resetPassword(email);
                            //show error must be defined differently
                            if (result == null) {
                              setState(() {
                                message =
                                    'Something went wrong, check your email and try again';
                                loading = false;
                              });
                            } else {
                              setState(() {
                                message = 'An email was sent to $email';
                                loading = false;
                              });
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
