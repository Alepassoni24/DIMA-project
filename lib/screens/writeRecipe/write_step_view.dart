import 'dart:io';

import 'package:dima_project/model/recipe_obj.dart';
import 'package:dima_project/screens/writeRecipe/text_form_fields.dart';
import 'package:dima_project/screens/writeRecipe/add_image_button.dart';
import 'package:dima_project/shared/circle_number.dart';
import 'package:dima_project/shared/constants.dart';
import 'package:dima_project/shared/form_validators.dart';
import 'package:flutter/material.dart';

// Show a single step form of the recipe, that allows the user
// to specify title, image and description of the step
class WriteStepView extends StatelessWidget {
  final StepData stepData;
  final Function(int, String) setTitle, setDescription;
  final Function(File) setImageFile;
  final Function(int) deleteStep;

  WriteStepView(this.stepData, this.setTitle, this.setDescription,
      this.setImageFile, this.deleteStep);

  @override
  Widget build(BuildContext context) {
    return Column(
      key: stepData.key,
      children: [
        Row(
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: CircleNumber(stepData.id.toString()),
            ),
            SizedBox(width: 5),
            // Form for title
            Flexible(
              flex: 8,
              fit: FlexFit.tight,
              child: TextFormFieldShort(
                  "Step title",
                  stepData.title,
                  (val) => setTitle(stepData.id, val),
                  TitleFieldValidator.validate),
            ),
            Flexible(
                flex: 1,
                child: IconButton(
                  icon: Icon(Icons.cancel, color: errorColor),
                  onPressed: () => deleteStep(stepData.id),
                )),
          ],
        ),
        SizedBox(width: 5),
        // Imagepicker for image
        AddImageButton(
            setFatherImage: setImageFile,
            imageFile: stepData.imageFile,
            imageURL: stepData.imageURL,
            height: 200,
            width: double.infinity,
            elevation: 5,
            borderRadius: 2),
        if (stepData.validate &&
            stepData.imageFile == null &&
            stepData.imageURL == null)
          Container(
              child: Text("Enter an image", style: errorStyle),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 5)),
        SizedBox(width: 5),
        // Form for description
        TextFormFieldLong(
            "Step description",
            stepData.description,
            (val) => setDescription(stepData.id, val),
            DescriptionFieldValidator.validate),
      ],
    );
  }
}
