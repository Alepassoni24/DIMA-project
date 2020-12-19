import 'dart:io';

import 'package:dima_project/model/recipe_obj.dart';
import 'package:dima_project/screens/writeRecipe/write_ingredient_view.dart';
import 'package:dima_project/screens/writeRecipe/write_step_view.dart';
import 'package:dima_project/shared/add_image_button.dart';
import 'package:dima_project/shared/app_icons.dart';
import 'package:dima_project/shared/constants.dart';
import 'package:dima_project/shared/section_divider.dart';
import 'package:flutter/material.dart';

class WriteRecipeView extends StatefulWidget {

  @override
  WriteRecipeViewState createState() => WriteRecipeViewState();
}

class WriteRecipeViewState extends State<WriteRecipeView> {
  final RecipeData _recipeData = new RecipeData(difficulty: 0);
  final List<IngredientData> _ingredientsData = List<IngredientData>();
  final List<StepData> _stepsData = List<StepData>();
  File _recipeImage;
  
  @override
  void initState() {
    super.initState();
    _ingredientsData.add(IngredientData(id: "1"));
    _stepsData.add(StepData(id: "1"));
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
            AddImageButton(setFatherImage: setRecipeImage, image: _recipeImage, height: 300, elevation: 5, borderRadius: 5),
            SectionDivider(),
            TextFormFieldShort("Title", setRecipeTitle),
            SectionDivider(),
            TextFormFieldShort("Subtitle", setRecipeSubtitle),
            SectionDivider(),
            TextFormFieldLong("Description", setRecipeDescription),
            SectionDivider(),
            TimeRow(setRecipeTime),
            SectionDivider(),
            ServingsRow(setRecipeServings),
            SectionDivider(),
            Difficulty(_recipeData.difficulty, setRecipeDifficulty),
            SectionDivider(),
            CategoryDropdown(_recipeData, setRecipeCategory, setRecipeVegan, setRecipeVegetarian, setRecipeGlutenFree, setRecipeLactoseFree),
            SectionDivider(),
            ...getIngredientsWidgetList(),
            SectionDivider(),
            ...getStepsWidgetList(),
            SectionDivider(),
            FlatButton(child: Text("SUBMIT RECIPE", style: titleStyle), color: Colors.orange[300], onPressed: submitRecipe),
          ]
        )
      )
    );
  }

  List<Widget> getIngredientsWidgetList() {
    List<Widget> _ingredients = [];

    // Title
    _ingredients.add(Padding(padding: EdgeInsets.only(left: 2.5, right: 2.5), child: Text("Ingredients:", style: titleStyle)));

    // All ingredients
    for(int i = 0; i < _ingredientsData.length; i++) {
      _ingredients.add(WriteIngredientView(i+1, setIngredientQuantity, setIngredientUnit, setIngredientName));
    }

    // Add button
    _ingredients.add(Padding(
      padding: EdgeInsets.only(left: 2.5, right: 2.5),
      child: FlatButton(child: Icon(Icons.add_outlined), onPressed: addIngredient)
    ));
    return _ingredients;
  }

  List<Widget> getStepsWidgetList() {
    List<Widget> _steps = [];
    
    // Title
    _steps.add(Padding(padding: EdgeInsets.only(left: 2.5, right: 2.5), child: Text("Procedure:", style: titleStyle)));

    // All steps with a divider but the last
    for(int i = 0; i < _stepsData.length-1; i++) {
      _steps.add(WriteStepView(i+1, _stepsData[i].imageFile, setStepTitle, setStepDescription, setStepImageFile(i)));
      _steps.add(SectionDivider());
    }
    _steps.add(WriteStepView(_stepsData.length, _stepsData[_stepsData.length-1].imageFile,
      setStepTitle, setStepDescription, setStepImageFile(_stepsData.length-1)));

    // Add button
    _steps.add(Padding(
      padding: EdgeInsets.only(left: 2.5, right: 2.5),
      child: FlatButton(child: Icon(Icons.add_outlined), onPressed: addStep),
    ));
    return _steps;
  }

  void submitRecipe() {
    // TODO: Submit recipe
  }

  // Recipe setters
  void setRecipeImage(File _image) => setState(() => _recipeImage = _image);
  void setRecipeTitle(String text) => setState(() => _recipeData.title = text);
  void setRecipeSubtitle(String text) => setState(() => _recipeData.subtitle = text);
  void setRecipeDescription(String text) => setState(() => _recipeData.description = text);
  void setRecipeTime(String text) => setState(() => _recipeData.time = text);
  void setRecipeServings(String text) => setState(() => _recipeData.servings = text);
  void setRecipeDifficulty(int val) => setState(() => _recipeData.difficulty = val);

  // Recipe categories
  void setRecipeCategory(String text) => setState(() => _recipeData.category = text);
  void setRecipeVegan(bool val) => setState(() => _recipeData.isVegan = val);
  void setRecipeVegetarian(bool val) => setState(() => _recipeData.isVegetarian = val);
  void setRecipeGlutenFree(bool val) => setState(() => _recipeData.isGlutenFree = val);
  void setRecipeLactoseFree(bool val) => setState(() => _recipeData.isLactoseFree = val);
  
  // Ingredient setters
  void addIngredient() => setState(() =>
    _ingredientsData.add(IngredientData(id: (_ingredientsData.length+1).toString(), quantity: "", unit: "", name: "")));
  void setIngredientQuantity(int id, String text) => setState(() => _ingredientsData[id].quantity = text);
  void setIngredientUnit(int id, String text) => setState(() => _ingredientsData[id].unit = text);
  void setIngredientName(int id, String text) => setState(() => _ingredientsData[id].name = text);

  // Step setters
  void addStep() => setState(() =>
    _stepsData.add(StepData(id: (_stepsData.length+1).toString(), title: "", description: "", imageURL: "")));
  void setStepTitle(int id, String text) => setState(() => _stepsData[id].title = text);
  void setStepDescription(int id, String text) => setState(() => _stepsData[id].description = text);
  Function(File) setStepImageFile(int id) => (File image) => setState(() => _stepsData[id].imageFile = image);
}

// Generic one line text form field
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
          contentPadding: EdgeInsets.only(left: 2.5, right: 2.5),
        ),
        onChanged: setText,
      ),
    );
  }
}

// Generic multi line text form field
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
          contentPadding: EdgeInsets.only(left: 2.5, right: 2.5),
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
            flex: 4,
            child: Text("Total time:", style: subtitleStyle),
            fit: FlexFit.tight,
          ),
          Flexible(
            flex: 2,
            child: TextFormFieldShort("30", setRecipeTime),
            fit: FlexFit.tight,
          ),
          Flexible(
            flex: 2,
            child: Text("minutes"),
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
            flex: 4,
            child: Text("Servings:", style: subtitleStyle),
            fit: FlexFit.tight,
          ),
          Flexible(
            flex: 2,
            child: TextFormFieldShort("4", setRecipeServings),
            fit: FlexFit.tight,
          ),
          Flexible(
            flex: 2,
            child: Text("people"),
            fit: FlexFit.tight,
          ),
        ],
      ),
    );
  }
}

class Difficulty extends StatelessWidget {

  final List<Color> colors = [Colors.yellow, Colors.orange, Colors.red];
  final Color baseColor = Colors.grey;

  final int difficulty;
  final Function(int) setDifficulty;

  Difficulty(this.difficulty, this.setDifficulty);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 2.5),
      child: Row(
        children: [
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: Text("Difficulty:", style: subtitleStyle),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: RawMaterialButton(
              onPressed: () => setDifficulty(0),
              shape: CircleBorder(),
              child: Image(
                image: AssetImage("assets/chef_hat.png"),
                height: 50,
                color: colors[difficulty],
              ),
            ),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: RawMaterialButton(
              onPressed: () => setDifficulty(1),
              shape: CircleBorder(),
              child: Image(
                image: AssetImage("assets/chef_hat.png"),
                height: 50,
                color: difficulty >= 1 ? colors[difficulty] : baseColor,
              ),
            ),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: RawMaterialButton(
              onPressed: () => setDifficulty(2),
              shape: CircleBorder(),
              child: Image(
                image: AssetImage("assets/chef_hat.png"),
                height: 50,
                color: difficulty >= 2 ? colors[difficulty] : baseColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryDropdown extends StatelessWidget {

  final RecipeData recipeData;
  final Function(String) setCategory;
  final Function(bool) setVegan, setVegetarian, setGlutenFree, setLactoseFree;

  CategoryDropdown(this.recipeData, this.setCategory, this.setVegan, this.setVegetarian, this.setGlutenFree, this.setLactoseFree);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 2.5),
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: Text("Category:", style: subtitleStyle),
              ),
              Flexible(
                flex: 3,
                fit: FlexFit.tight,
                child: DropdownButton<String>(
                  elevation: 16,
                  isExpanded:true,
                  onChanged: setCategory,
                  value: recipeData.category == null ? categories[0] : recipeData.category,
                  items: categories
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ]
          ),
          CheckboxListTile(
            title: Text("Vegan"),
            secondary: Icon(AppIcons.vegan),
            activeColor: Colors.orange,
            value: recipeData.isVegan == null ? false : recipeData.isVegan,
            onChanged: setVegan,
          ),
          CheckboxListTile(
            title: Text("Vegetarian"),
            secondary: Icon(AppIcons.vegan),
            activeColor: Colors.orange,
            value: recipeData.isVegetarian == null ? false : recipeData.isVegetarian,
            onChanged: setVegetarian,
          ),
          CheckboxListTile(
            title: Text("Gluten free"),
            secondary: Icon(AppIcons.gluten_free),
            activeColor: Colors.orange,
            value: recipeData.isGlutenFree == null ? false : recipeData.isGlutenFree,
            onChanged: setGlutenFree,
          ),
          CheckboxListTile(
            title: Text("Lactose free"),
            secondary: Icon(AppIcons.lactose_free),
            activeColor: Colors.orange,
            value: recipeData.isLactoseFree == null ? false : recipeData.isLactoseFree,
            onChanged: setLactoseFree,
          ),
        ],
      ),
    );
  }
}
