import 'dart:io';

import 'package:dima_project/screens/writeRecipe/write_recipe_view.dart';
import 'package:dima_project/shared/add_image_button.dart';
import 'package:dima_project/shared/constants.dart';
import 'package:flutter/material.dart';

class WriteStepView extends StatelessWidget {

  final int id;
  File stepImage;
  final Function(int, String) setTitle, setDescription;
  final Function(File) setImageFile;

  WriteStepView(this.id, this.stepImage, this.setTitle, this.setDescription, this.setImageFile);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: CircleAvatar(
                child: Text(
                  id.toString(),
                  style: subtitleStyle),
                radius: 15,
                backgroundColor: Colors.orange[700],
                foregroundColor: Colors.black
              ),
            ),
            SizedBox(width: 5),
            Flexible(
              flex: 9,
              fit: FlexFit.tight,
              child: TextFormFieldShort("Step title", (val) => setTitle(id, val)),
            ),
          ],
        ),
        SizedBox(width: 5),
        AddImageButton(setFatherImage: setImageFile, image: stepImage, height: 200, width: double.infinity, elevation: 5, borderRadius: 2),
        SizedBox(width: 5), 
        TextFormFieldLong("Step description", (val) => setDescription(id, val)),
      ],
    );
  }
}
