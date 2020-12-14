import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddImageButton extends StatefulWidget {

  final double height, width, elevation, borderRadius;

  const AddImageButton ({
    Key key,
    this.height = 50,
    this.width = 50,
    this.elevation = 0,
    this.borderRadius = 0,
  }): super(key: key);

  @override
  AddImageButtonState createState() => AddImageButtonState(height, width, elevation, borderRadius);
}

class AddImageButtonState extends State<AddImageButton> {
  
  File _image;
  final _picker = ImagePicker();
  final double height, width, elevation, borderRadius;

  AddImageButtonState(this.height, this.width, this.elevation, this.borderRadius);

  Future getImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.height,
      width: this.width,
      child: Card(
        elevation: this.elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: InkWell(
          child: _image == null
            ? Icon(Icons.add_a_photo_outlined)
            : ImageContainer(_image),
          onTap: getImage
        ),
      ),
    );
  }
}

class ImageContainer extends StatelessWidget {
  
  final File _image;

  ImageContainer(this._image);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        image: new DecorationImage(
          fit: BoxFit.fitWidth,
          alignment: Alignment.center,
          image: FileImage(_image),
        )
      ),
    );
  }
}
