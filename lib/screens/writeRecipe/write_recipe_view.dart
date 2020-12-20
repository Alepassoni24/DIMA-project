import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/model/recipe_obj.dart';
import 'package:dima_project/screens/writeRecipe/text_form_fields.dart';
import 'package:dima_project/screens/writeRecipe/write_ingredient_view.dart';
import 'package:dima_project/screens/writeRecipe/write_step_view.dart';
import 'package:dima_project/shared/add_image_button.dart';
import 'package:dima_project/shared/app_icons.dart';
import 'package:dima_project/shared/constants.dart';
import 'package:dima_project/shared/form_validators.dart';
import 'package:dima_project/shared/section_divider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;

class WriteRecipeView extends StatefulWidget {

  @override
  WriteRecipeViewState createState() => WriteRecipeViewState();
}

class WriteRecipeViewState extends State<WriteRecipeView> {
  final RecipeData _recipeData = new RecipeData(difficulty: 0);
  final List<IngredientData> _ingredientsData = List<IngredientData>();
  final List<StepData> _stepsData = List<StepData>();
  final _formKey = GlobalKey<FormState>();
  
  @override
  void initState() {
    super.initState();
    _ingredientsData.add(IngredientData(id: 1));
    _stepsData.add(StepData(id: 1));
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
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
            child: Column(
              children: [
                AddImageButton(setFatherImage: setRecipeImage, image: _recipeData.imageFile, height: 300, width: double.infinity, elevation: 5, borderRadius: 5),
                if(_recipeData.validate && _recipeData.imageFile == null)
                  Container(child: Text("Enter an image", style: errorStyle), alignment: Alignment.centerLeft, padding: EdgeInsets.only(left: 5)),
                SectionDivider(),
                TextFormFieldShort("Title", _recipeData.title, setRecipeTitle, TitleFieldValidator.validate),
                SectionDivider(),
                TextFormFieldShort("Subtitle", _recipeData.subtitle, setRecipeSubtitle, SubtitleFieldValidator.validate),
                SectionDivider(),
                TextFormFieldLong("Description", _recipeData.description, setRecipeDescription, DescriptionFieldValidator.validate),
                SectionDivider(),
                TimeRow(_recipeData, setRecipeTime),
                SectionDivider(),
                ServingsRow(_recipeData, setRecipeServings),
                SectionDivider(),
                Difficulty(_recipeData, setRecipeDifficulty),
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
      _ingredients.add(WriteIngredientView(_ingredientsData[i], setIngredientQuantity, setIngredientUnit, setIngredientName));
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
      _steps.add(WriteStepView(_stepsData[i], setStepTitle, setStepDescription, setStepImageFile(i)));
      _steps.add(SectionDivider());
    }
    _steps.add(WriteStepView(_stepsData[_stepsData.length-1], setStepTitle, setStepDescription, setStepImageFile(_stepsData.length-1)));

    // Add button
    _steps.add(Padding(
      padding: EdgeInsets.only(left: 2.5, right: 2.5),
      child: FlatButton(child: Icon(Icons.add_outlined), onPressed: addStep),
    ));
    return _steps;
  }

  void submitRecipe() async {
    // Check if all forms and imagepicker are not empty
    setRecipeValidate();
    bool canSubmit = _recipeData.imageFile != null;
    for(StepData stepData in _stepsData) {
      setStepValidate(stepData.id);
      canSubmit &= stepData.imageFile != null;
    }
    if (_formKey.currentState.validate() && canSubmit) {
      // Submit recipe
      _recipeData.imageURL = await uploadImage(_recipeData.imageFile, 'recipe/');
      String recipeId = await sendRecipe(_recipeData);
      // Submit all ingredients
      for(IngredientData ingredientData in _ingredientsData) {
        sendIngredient(ingredientData, recipeId);
      }
      // Submit all steps
      for(StepData stepData in _stepsData) {
        stepData.imageURL = await uploadImage(stepData.imageFile, 'step/');
        sendStep(stepData, recipeId);
      }
      // Show the view of the recipe
      Navigator.pushNamed(context, '/recipeView', arguments: _recipeData);
    }
  }

  // Upload a generic image to Firebase Storage
  Future<String> uploadImage(File image, String path) async {
    Reference storageReference = FirebaseStorage.instance.ref()
      .child(path + Path.basename(image.path));
    await storageReference.putFile(image);
    return await storageReference.getDownloadURL();
  }

  // Add a recipe document to Cloud Firestore
  Future<String> sendRecipe(RecipeData recipeData) async
  {
    DocumentReference docRef =
      await FirebaseFirestore.instance.collection('recipe').add({
        'title': recipeData.title,
        'subtitle': recipeData.subtitle,
        'description': recipeData.description,
        'imageURL': recipeData.imageURL,
        'rating': 0,
        'time': recipeData.time,
        'servings': recipeData.servings,
        'submissionTime': FieldValue.serverTimestamp(),
        'difficulty': recipeData.difficulty,
        'category': recipeData.category,
        'isVegan': recipeData.isVegan,
        'isVegetarian': recipeData.isVegetarian,
        'isGlutenFree': recipeData.isGlutenFree,
        'isLactoseFree': recipeData.isLactoseFree,
    });
    return docRef.id;
  }

  // Add a ingredient document, under a recipe, to Cloud Firestore
  Future<void> sendIngredient(IngredientData ingredientData, String recipeId) async
  {
    FirebaseFirestore.instance.collection('recipe').doc(recipeId)
      .collection('ingredient').doc(ingredientData.id.toString()).set({
        'quantity': ingredientData.quantity,
        'unit': ingredientData.unit,
        'name': ingredientData.name,
    });
  }

  // Add a step document, under a recipe, to Cloud Firestore
  Future<void> sendStep(StepData stepData, String recipeId) async
  {
    FirebaseFirestore.instance.collection('recipe').doc(recipeId)
      .collection('step').doc(stepData.id.toString()).set({
        'title': stepData.title,
        'description': stepData.description,
        'imageURL': stepData.imageURL,
    });
  }

  // Recipe setters
  void setRecipeImage(File _image) => setState(() => _recipeData.imageFile = _image);
  void setRecipeTitle(String text) => setState(() => _recipeData.title = text);
  void setRecipeSubtitle(String text) => setState(() => _recipeData.subtitle = text);
  void setRecipeDescription(String text) => setState(() => _recipeData.description = text);
  void setRecipeTime(String text) => setState(() => _recipeData.time = text);
  void setRecipeServings(String text) => setState(() => _recipeData.servings = text);
  void setRecipeDifficulty(int val) => setState(() => _recipeData.difficulty = val);
  void setRecipeValidate() => setState(() => _recipeData.validate = true);

  // Recipe categories
  void setRecipeCategory(String text) => setState(() => _recipeData.category = text);
  void setRecipeVegan(bool val) => setState(() => _recipeData.isVegan = val);
  void setRecipeVegetarian(bool val) => setState(() => _recipeData.isVegetarian = val);
  void setRecipeGlutenFree(bool val) => setState(() => _recipeData.isGlutenFree = val);
  void setRecipeLactoseFree(bool val) => setState(() => _recipeData.isLactoseFree = val);
  
  // Ingredient setters
  void addIngredient() => setState(() =>
    _ingredientsData.add(IngredientData(id: _ingredientsData.length+1, quantity: "", unit: "", name: "")));
  void setIngredientQuantity(int id, String text) => setState(() => _ingredientsData[id-1].quantity = text);
  void setIngredientUnit(int id, String text) => setState(() => _ingredientsData[id-1].unit = text);
  void setIngredientName(int id, String text) => setState(() => _ingredientsData[id-1].name = text);

  // Step setters
  void addStep() => setState(() =>
    _stepsData.add(StepData(id: _stepsData.length+1, title: "", description: "", imageURL: "")));
  void setStepTitle(int id, String text) => setState(() => _stepsData[id-1].title = text);
  void setStepDescription(int id, String text) => setState(() => _stepsData[id-1].description = text);
  Function(File) setStepImageFile(int id) => (File image) => setState(() => _stepsData[id].imageFile = image);
  void setStepValidate(int id) => setState(() => _stepsData[id-1].validate = true);
}

class TimeRow extends StatelessWidget {

  final RecipeData recipeData;
  final Function(String) setRecipeTime;

  TimeRow(this.recipeData, this.setRecipeTime);

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
          // Form for recipe time
          Flexible(
            flex: 2,
            child: TextFormFieldShort("30", recipeData.time, setRecipeTime, NumberFieldValidator.validate),
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

  final RecipeData recipeData;
  final Function(String) setRecipeServings;

  ServingsRow(this.recipeData, this.setRecipeServings);

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
          // Form for recipe servings
          Flexible(
            flex: 2,
            child: TextFormFieldShort("4", recipeData.servings, setRecipeServings, NumberFieldValidator.validate),
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

  final RecipeData recipeData;
  final Function(int) setDifficulty;

  Difficulty(this.recipeData, this.setDifficulty);

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
          // Three chef hats to simbolize the difficulty
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: RawMaterialButton(
              onPressed: () => setDifficulty(0),
              shape: CircleBorder(),
              child: Image(
                image: AssetImage("assets/chef_hat.png"),
                height: 50,
                color: colors[recipeData.difficulty],
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
                color: recipeData.difficulty >= 1 ? colors[recipeData.difficulty] : baseColor,
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
                color: recipeData.difficulty >= 2 ? colors[recipeData.difficulty] : baseColor,
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
              // Dropdown menu for category
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
          // Four checkbox for options
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
