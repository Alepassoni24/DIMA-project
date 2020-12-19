import 'dart:io';

import 'package:dima_project/model/user_obj.dart';
import 'package:dima_project/services/database.dart';
import 'package:dima_project/shared/constants.dart';
import 'package:dima_project/shared/form_validators.dart';
import 'package:dima_project/shared/loading.dart';
import 'package:dima_project/shared/warning_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  String username,
      profilePhotoURL,
      profilePhotoURI,
      oldProfilePhotoURL,
      newPassword,
      repeatedNewPassword,
      error;

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
              oldProfilePhotoURL = snapshot.data.profilePhotoURL;
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
                      if (newPassword != null) {
                        validateAndUpdatePassword();
                      }

                      if (image != null) {
                        await uploadImage();
                        await deleteOldImage();
                      }
                      await databaseService.updateUserData(
                          username, profilePhotoURL);

                      if (error == null) {
                        Navigator.of(context).pop();
                      }
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
                          warning: error,
                        ),
                        SizedBox(
                          height: 2.0,
                        ),
                        InkWell(
                          child:
                              profilePhotoURL == null && profilePhotoURI == null
                                  ? Icon(
                                      Icons.account_circle_outlined,
                                      size: 175,
                                      color: Colors.grey[600],
                                    )
                                  : profilePhotoURI != null
                                      ? CircleAvatar(
                                          radius: 87.5,
                                          backgroundImage: FileImage(image),
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
                        SizedBox(
                          height: 50,
                        ),
                        if (snapshot.data.userRegisteredWithMail)
                          Text(
                            'change your password',
                          ),

                        if (snapshot.data.userRegisteredWithMail)
                          //field to insert the new password
                          TextFormField(
                            validator: PasswordFieldValidator.validate,
                            decoration: textInputDecoration.copyWith(
                              hintText: 'new password',
                            ),
                            obscureText: true,
                            //val represent whatever will be into the field
                            onChanged: (val) {
                              setState(() => newPassword = val);
                            },
                          ),
                        if (snapshot.data.userRegisteredWithMail)
                          //field to insert the repeatition of the new password for checking purpose
                          TextFormField(
                            validator: PasswordFieldValidator.validate,
                            decoration: textInputDecoration.copyWith(
                              hintText: 'repeat new password',
                            ),
                            obscureText: true,
                            //val represent whatever will be into the field
                            onChanged: (val) {
                              setState(() => repeatedNewPassword = val);
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

  //Funtion to get a picture from the device gallery
  Future getImgFromGallery() async {
    //close the choosing dialog
    Navigator.of(context).pop();
    //get file from the camera
    PickedFile img = await picker.getImage(source: ImageSource.gallery);
    //set information into the widget state
    setState(() {
      image = File(img.path);
      profilePhotoURI = img.path;
    });
  }

  //Function to get a picture from the device camera
  Future getImgFromCamera() async {
    //close the choosing dialog
    Navigator.of(context).pop();
    //get file from the camera
    PickedFile img = await picker.getImage(source: ImageSource.camera);
    //set information into the widget state
    setState(() {
      image = File(img.path);
      profilePhotoURI = img.path;
    });
  }

  //Function to upload the new profile photo onto the storage
  Future uploadImage() async {
    //create a referenco fot the image into the storage
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('profilePhoto/${Path.basename(image.path)}');
    //upload file
    UploadTask uploadTask = storageReference.putFile(image);
    await uploadTask;
    //update the state of the widget
    await storageReference.getDownloadURL().then((imgUrl) => {
          setState(() {
            profilePhotoURI = null;
            profilePhotoURL = imgUrl;
          })
        });
  }

  //Function to delete the old profile picture of the user from the storage
  Future deleteOldImage() async {
    if (oldProfilePhotoURL != null) {
      //retrieve the path of the picture in the storage
      var path =
          '${Path.basename(oldProfilePhotoURL).replaceFirst("%2F", "/").split("?")[0]}';
      //create a reference of the file
      Reference fileRef = FirebaseStorage.instance.ref().child(path);
      //delete the file from the storage
      await fileRef.delete();
      //set the widget state
      setState(() {
        oldProfilePhotoURL = profilePhotoURL;
      });
    }
  }

  //Function to verify if the new provided passwords match and update in onto the database
  Future validateAndUpdatePassword() async {
    //get the current user from auth service
    User user = await FirebaseAuth.instance.currentUser;
    if (newPassword == repeatedNewPassword) {
      //update password and manage errors and for each outcome the widget state
      user
          .updatePassword(newPassword)
          .then((_) => {
                this.setState(() {
                  error = null;
                  newPassword = null;
                  repeatedNewPassword = null;
                })
              })
          .catchError((onError) {
        setState(() {
          error = 'something went wrong';
        });
      });
    } else {
      setState(() {
        error = 'passwords don\'t match';
      });
    }
  }
}
