import 'dart:io';

import 'package:dima_project/model/recipe_obj.dart';
import 'package:dima_project/screens/writeRecipe/write_ingredient_view.dart';
import 'package:dima_project/shared/add_image_button.dart';
import 'package:dima_project/shared/constants.dart';
import 'package:flutter/material.dart';

class WriteRecipeView extends StatefulWidget {

  @override
  WriteRecipeViewState createState() => WriteRecipeViewState();
}

class WriteRecipeViewState extends State<WriteRecipeView> {
  final RecipeData _recipeData = new RecipeData();
  final List<IngredientData> _ingredientsData = List<IngredientData>();
  final List<StepData> _stepsData = List<StepData>();
  File _recipeImage;
  
  @override
  void initState() {
    super.initState();
    _ingredientsData.add(IngredientData(id: "1", quantity: "", unit: "", name: ""));
    _stepsData.add(StepData(id: "1", title: "", description: "", imageURL: ""));
  }

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
            TimeRow(setRecipeTime),
            Divider(color: Colors.orange[900], thickness: 1.5, indent: 2.5, endIndent: 2.5),
            ServingsRow(setRecipeServings),
            Divider(color: Colors.orange[900], thickness: 1.5, indent: 2.5, endIndent: 2.5),
            ...getIngredientsWidgetList(),
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

  List<Widget> getIngredientsWidgetList() {
    List<Widget> _ingredients = [];
    _ingredients.add(Padding(padding: EdgeInsets.only(left: 2.5, right: 2.5), child: Text("Ingredients:")));
    for(int i = 0; i < _ingredientsData.length; i++) {
      _ingredients.add(WriteIngredientView(i+1, setIngredientQuantity, setIngredientUnit, setIngredientName));
    }
    _ingredients.add(Padding(
      padding: EdgeInsets.only(left: 2.5, right: 2.5),
      child: FlatButton(child: Icon(Icons.add_outlined), onPressed: addIngredient)
    ));
    return _ingredients;
  }

  // Recipe setters
  void setRecipeImage(File _image) => setState(() => _recipeImage = _image);
  void setRecipeTitle(String text) => setState(() => _recipeData.title = text);
  void setRecipeDescription(String text) => setState(() => _recipeData.description = text);
  void setRecipeTime(String text) => setState(() => _recipeData.time = text);
  void setRecipeServings(String text) => setState(() => _recipeData.servings = text);
  
  void addIngredient() => setState(() {
    _ingredientsData.add(IngredientData(id: (_ingredientsData.length+1).toString(), quantity: "", unit: "", name: "")); });
  void setIngredientQuantity(int id, String text) => setState(() => _ingredientsData[id].quantity = text);
  void setIngredientUnit(int id, String text) => setState(() => _ingredientsData[id].unit = text);
  void setIngredientName(int id, String text) => setState(() => _ingredientsData[id].name = text);
}

class MainPhoto extends StatelessWidget {

  final Function(File) setRecipeImage;

  MainPhoto(this.setRecipeImage);

  @override
  Widget build(BuildContext context) {
      return AddImageButton(setFatherImage: setRecipeImage, height: 300, elevation: 5, borderRadius: 5);
  }
}

class TextFormFieldShort extends StatelessWidget {
  final String hintText;
  final Function(String) setText;

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
  final Function(String) setText;

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

class TimeRow extends StatelessWidget {

  final Function(String) setRecipeTime;

  TimeRow(this.setRecipeTime);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 2.5),
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: Text("Time:"),
            fit: FlexFit.tight,
          ),
          Flexible(
            flex: 3,
            child: TextFormFieldShort("30-40 minutes", setRecipeTime),
            fit: FlexFit.tight,
          ),
        ],
      ),
    );
  }
}

class ServingsRow extends StatelessWidget {

  final Function(String) setRecipeServings;

  ServingsRow(this.setRecipeServings);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 2.5),
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: Text("Servings:"),
            fit: FlexFit.tight,
          ),
          Flexible(
            flex: 3,
            child: TextFormFieldShort("4 people", setRecipeServings),
            fit: FlexFit.tight,
          ),
        ],
      ),
    );
  }
}
