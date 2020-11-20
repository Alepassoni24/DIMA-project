import 'package:dima_project/model/user_obj.dart';
import 'package:dima_project/screens/authenticate/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dima_project/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //we are trying to receive a UserObj data and we pass the context
    //so we know what stream we are going to listen to
    final user = Provider.of<UserObj>(context);

    //return either Home or Authenticate widget depending on the value of user
    //null means the user is not authenticated otherwise we have an instance of UserObj
    if (user == null) {
      return SignIn();
    } else {
      return Home();
    }
  }
}
