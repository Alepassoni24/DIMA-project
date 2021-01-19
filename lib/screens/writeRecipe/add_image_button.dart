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

  Future getImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setFatherImage(File(pickedFile.path));
    }
  }

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
                ? ImageContainer(FileImage(imageFile), borderRadius)
                : (imageURL != null
                    ? ImageContainer(NetworkImage(imageURL), borderRadius)
                    : Icon(Icons.add_a_photo_outlined)),
            onTap: getImage),
      ),
    );
  }
}

class ImageContainer extends StatelessWidget {
  final ImageProvider _image;
  final double borderRadius;

  ImageContainer(this._image, this.borderRadius);

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
