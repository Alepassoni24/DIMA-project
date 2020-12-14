import 'dart:io';

import 'package:dima_project/model/recipe_obj.dart';
import 'package:dima_project/shared/add_image_button.dart';
import 'package:dima_project/shared/constants.dart';
import 'package:flutter/material.dart';

class WriteRecipeView extends StatefulWidget {

  @override
  WriteRecipeViewState createState() => WriteRecipeViewState();
}

class WriteRecipeViewState extends State<WriteRecipeView> {
  RecipeData _recipeData = new RecipeData();
  List<IngredientData> _ingredientsData;
  List<StepData> _stepsData;
  File _recipeImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        backgroundColor: Colors.orange[400],
        elevation: 0,
        title: Text('Write a recipe'),
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
          children: [
            MainPhoto(setRecipeImage),
            Divider(color: Colors.orange[900], thickness: 1.5, indent: 2.5, endIndent: 2.5),
            TextFormFieldShort("Title", setRecipeTitle),
            Divider(color: Colors.orange[900], thickness: 1.5, indent: 2.5, endIndent: 2.5),
            TextFormFieldLong("Description", setRecipeDescription),
            Divider(color: Colors.orange[900], thickness: 1.5, indent: 2.5, endIndent: 2.5),
            TextFormFieldShort("Time", setRecipeTime),
            Divider(color: Colors.orange[900], thickness: 1.5, indent: 2.5, endIndent: 2.5),
            TextFormFieldShort("Servings", setRecipeServings),
            Divider(color: Colors.orange[900], thickness: 1.5, indent: 2.5, endIndent: 2.5),
            // TODO: Ingredients
            // TODO: Button to add an ingredient row
            Divider(color: Colors.orange[900], thickness: 1.5, indent: 2.5, endIndent: 2.5),
            // TODO: Steps
            // TODO: Button to add a step row
            Divider(color: Colors.orange[900], thickness: 1.5, indent: 2.5, endIndent: 2.5),
            // TODO: Button to submit recipe
          ]
        )
      )
    );
  }

  // Recipes setters
  void setRecipeImage(File _image) => setState(() => _recipeImage = _image);
  void setRecipeTitle(String text) => setState(() => _recipeData.title = text);
  void setRecipeDescription(String text) => setState(() => _recipeData.description = text);
  void setRecipeTime(String text) => setState(() => _recipeData.time = text);
  void setRecipeServings(String text) => setState(() => _recipeData.servings = text);
}

class MainPhoto extends StatelessWidget {

  final Function setRecipeImage;

  MainPhoto(this.setRecipeImage);

  @override
  Widget build(BuildContext context) {
      return AddImageButton(setFatherImage: setRecipeImage, height: 300, elevation: 5, borderRadius: 5);
  }
}

class TextFormFieldShort extends StatelessWidget {
  final String hintText;
  final Function setText;

  TextFormFieldShort(this.hintText, this.setText);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 2.5, right: 2.5),
      child: TextFormField(
        decoration: textInputDecoration.copyWith(
          hintText: hintText,
        ),
        onChanged: setText,
      ),
    );
  }
}

class TextFormFieldLong extends StatelessWidget {
  final String hintText;
  final Function setText;

  TextFormFieldLong(this.hintText, this.setText);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 2.5, right: 2.5),
      child: TextFormField(
        decoration: textInputDecoration.copyWith(
          hintText: hintText,
        ),
        keyboardType: TextInputType.multiline,
        maxLines: null,
        onChanged: setText,
      ),
    );
  }
}
