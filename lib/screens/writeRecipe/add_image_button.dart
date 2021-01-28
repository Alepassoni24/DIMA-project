import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddImageButton extends StatelessWidget {
  final File imageFile;
  final String imageURL;
  final ImagePicker _picker = ImagePicker();
  final Function(File) setFatherImage;
  final double height, width, elevation, borderRadius;

  AddImageButton({
    this.setFatherImage,
    this.imageFile,
    this.imageURL,
    this.height,
    this.width,
    this.elevation,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.height,
      width: this.width,
      child: Card(
        elevation: this.elevation,
        color: Colors.grey[50],
        child: InkWell(
            borderRadius: BorderRadius.circular(borderRadius),
            child: imageFile != null
                ? PickedImageContainer(FileImage(imageFile), borderRadius)
                : (imageURL != null
                    ? PickedImageContainer(NetworkImage(imageURL), borderRadius)
                    : Icon(Icons.add_a_photo_outlined)),
            onTap: () => showChoosingPanel(context)),
      ),
    );
  }

  void showChoosingPanel(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                FlatButton(
                    onPressed: () => getImage(context, ImageSource.camera),
                    child: Row(children: [
                      Icon(Icons.camera_enhance),
                      Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Take a picture',
                          )),
                    ])),
                FlatButton(
                    onPressed: () => getImage(context, ImageSource.gallery),
                    child: Row(children: [
                      Icon(Icons.photo),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          'Select from gallery',
                        ),
                      ),
                    ])),
              ]));
        });
  }

  Future<void> getImage(BuildContext context, ImageSource imageSource) async {
    Navigator.of(context).pop();
    final PickedFile pickedFile = await _picker.getImage(source: imageSource);
    if (pickedFile != null) {
      setFatherImage(File(pickedFile.path));
    }
  }
}

class PickedImageContainer extends StatelessWidget {
  final ImageProvider _image;
  final double borderRadius;

  PickedImageContainer(this._image, this.borderRadius);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          image: new DecorationImage(
              fit: BoxFit.cover, alignment: Alignment.center, image: _image)),
    );
  }
}
