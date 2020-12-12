import 'package:dima_project/model/user_obj.dart';
import 'package:dima_project/services/database.dart';
import 'package:dima_project/shared/constants.dart';
import 'package:dima_project/shared/form_validators.dart';
import 'package:dima_project/shared/loading.dart';
import 'package:dima_project/shared/warning_alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserSettings extends StatefulWidget {
  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  //key to identify the form
  final _formKey = GlobalKey<FormState>();

  String username;
  String profilePhotoURL;
  String message;

  @override
  Widget build(BuildContext context) {
    final databaseService = Provider.of<DatabaseService>(context);

    return StreamBuilder<UserData>(
        stream: databaseService.userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            username = snapshot.data.username;
            profilePhotoURL = snapshot.data.profilePhotoURL;
            return Scaffold(
              backgroundColor: Colors.orange[50],
              appBar: AppBar(
                backgroundColor: Colors.orange[400],
                title: Text('User settings'),
                elevation: 0,
                actions: [
                  IconButton(
                    icon: Icon(Icons.save),
                    onPressed: () {
                      databaseService.updateUserData(username, profilePhotoURL);
                    },
                  )
                ],
              ),
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
                        SizedBox(
                          height: 2.0,
                        ),
                        WarningAlert(
                          warning: message,
                        ),
                        SizedBox(
                          height: 2.0,
                        ),
                        if (profilePhotoURL == null)
                          Icon(
                            Icons.account_circle_outlined,
                            size: 175,
                            color: Colors.grey[600],
                          ),
                        if (profilePhotoURL != null)
                          CircleAvatar(
                            radius: 87.5,
                            backgroundImage: NetworkImage(profilePhotoURL),
                          ),
                        SizedBox(
                          height: 10.0,
                        ),
                        //field for username
                        TextFormField(
                          validator: UsernameFieldValidator.validate,
                          initialValue: username,
                          decoration: textInputDecoration.copyWith(
                            hintText: 'username',
                          ),
                          //val represent whatever will be into the field
                          onChanged: (val) {
                            setState(() => username = val);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
