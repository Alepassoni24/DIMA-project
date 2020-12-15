import 'dart:io';

import 'package:dima_project/model/user_obj.dart';
import 'package:dima_project/services/database.dart';
import 'package:dima_project/shared/constants.dart';
import 'package:dima_project/shared/form_validators.dart';
import 'package:dima_project/shared/loading.dart';
import 'package:dima_project/shared/warning_alert.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;

class UserSettings extends StatefulWidget {
  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  bool firstBuilt = true;
  final picker = ImagePicker();

  //key to identify the form
  final _formKey = GlobalKey<FormState>();
  File image;
  String username, profilePhotoURL, message;

  @override
  Widget build(BuildContext context) {
    final databaseService = Provider.of<DatabaseService>(context);

    void _showChoosingPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FlatButton(
                    onPressed: () => getImgFromCamera(),
                    child: Row(
                      children: [
                        Icon(Icons.camera_enhance),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Take a picture',
                          ),
                        ),
                      ],
                    ),
                  ),
                  FlatButton(
                    onPressed: () => getImgFromGallery(),
                    child: Row(
                      children: [
                        Icon(Icons.photo),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Select from gallery',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
    }

    return StreamBuilder<UserData>(
        stream: databaseService.userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (firstBuilt) {
              username = snapshot.data.username;
              profilePhotoURL = snapshot.data.profilePhotoURL;
              firstBuilt = false;
            }
            return Scaffold(
              backgroundColor: Colors.orange[50],
              appBar: AppBar(
                backgroundColor: Colors.orange[400],
                title: Text('User settings'),
                elevation: 0,
                actions: [
                  IconButton(
                    icon: Icon(Icons.save),
                    onPressed: () async {
                      if (image != null) await uploadImage();
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
                        InkWell(
                          child: profilePhotoURL == null
                              ? Icon(
                                  Icons.account_circle_outlined,
                                  size: 175,
                                  color: Colors.grey[600],
                                )
                              : CircleAvatar(
                                  radius: 87.5,
                                  backgroundImage:
                                      NetworkImage(profilePhotoURL),
                                ),
                          onTap: () => _showChoosingPanel(),
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

  Future getImgFromGallery() async {
    PickedFile img = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      image = File(img.path);
      profilePhotoURL = img.path;
    });
  }

  Future getImgFromCamera() async {
    PickedFile img = await picker.getImage(source: ImageSource.camera);
    setState(() {
      image = File(img.path);
      profilePhotoURL = img.path;
    });
  }

  Future uploadImage() async {
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('profilePhoto/${Path.basename(image.path)}');
    UploadTask uploadTask = storageReference.putFile(image);
    await uploadTask;
    storageReference.getDownloadURL().then((imgUrl) => {
          setState(() {
            profilePhotoURL = imgUrl;
          })
        });
  }
}
