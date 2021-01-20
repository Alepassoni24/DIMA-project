import 'dart:io';

import 'package:dima_project/model/recipe_obj.dart';
import 'package:dima_project/screens/writeRecipe/text_form_fields.dart';
import 'package:dima_project/screens/writeRecipe/write_ingredient_view.dart';
import 'package:dima_project/screens/writeRecipe/write_step_view.dart';
import 'package:dima_project/screens/writeRecipe/add_image_button.dart';
import 'package:dima_project/services/database.dart';
import 'package:dima_project/shared/app_icons.dart';
import 'package:dima_project/shared/constants.dart';
import 'package:dima_project/shared/form_validators.dart';
import 'package:dima_project/shared/section_divider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;

class WriteRecipeView extends StatefulWidget {
  @override
  WriteRecipeViewState createState() => WriteRecipeViewState();
}

class WriteRecipeViewState extends State<WriteRecipeView> {
  RecipeData _recipeData;
  List<IngredientData> _ingredientsData;
  List<StepData> _stepsData;
  final _formKey = GlobalKey<FormState>();
  final DatabaseService databaseService =
      DatabaseService(uid: FirebaseAuth.instance.currentUser.uid);

  @override
  Widget build(BuildContext context) {
    // The first time this widget is called check if it is a new recipe...
    if (_recipeData == null &&
        ModalRoute.of(context).settings.arguments == null) {
      _recipeData = RecipeData();
      _ingredientsData = [IngredientData(id: 1)];
      _stepsData = [StepData(id: 1)];
    }
    // ... or if a  recipe is beeing edited, in this case query the data
    else if (_recipeData == null) {
      _recipeData = ModalRoute.of(context).settings.arguments;
      _ingredientsData = [];
      databaseService
          .getRecipeIngredients(_recipeData.recipeId)
          .forEach((query) {
        query.docs.forEach((doc) => setState(() {
              _ingredientsData
                  .add(databaseService.ingredientsDataFromSnapshot(doc));
            }));
      });
      _stepsData = [];
      databaseService.getRecipeSteps(_recipeData.recipeId).forEach((query) {
        query.docs.forEach((doc) => setState(() {
              _stepsData.add(databaseService.stepsDataFromSnapshot(doc));
            }));
      });
    }

    // Return the widget
    return Scaffold(
        backgroundColor: Colors.orange[50],
        appBar: AppBar(
          backgroundColor: Colors.orange[400],
          elevation: 0,
          title: Text('Write a recipe'),
          actions: [
            DeleteIcon(deleteRecipe),
          ],
        ),
        body: Center(
            child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                    padding: EdgeInsets.all(10),
                    child: Column(children: [
                      AddImageButton(
                          setFatherImage: setRecipeImage,
                          imageFile: _recipeData.imageFile,
                          imageURL: _recipeData.imageURL,
                          height: 300,
                          width: double.infinity,
                          elevation: 5,
                          borderRadius: 5),
                      if (_recipeData.validate &&
                          _recipeData.imageFile == null &&
                          _recipeData.imageURL == null)
                        Container(
                            child: Text("Enter an image", style: errorStyle),
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 5)),
                      SectionDivider(),
                      TextFormFieldShort("Title", _recipeData.title,
                          setRecipeTitle, TitleFieldValidator.validate),
                      SectionDivider(),
                      TextFormFieldShort("Subtitle", _recipeData.subtitle,
                          setRecipeSubtitle, SubtitleFieldValidator.validate),
                      SectionDivider(),
                      TextFormFieldLong(
                          "Description",
                          _recipeData.description,
                          setRecipeDescription,
                          DescriptionFieldValidator.validate),
                      SectionDivider(),
                      TimeRow(_recipeData, setRecipeTime),
                      SectionDivider(),
                      ServingsRow(_recipeData, setRecipeServings),
                      SectionDivider(),
                      Difficulty(_recipeData, setRecipeDifficulty),
                      SectionDivider(),
                      CategoryDropdown(
                          _recipeData,
                          setRecipeCategory,
                          setRecipeVegan,
                          setRecipeVegetarian,
                          setRecipeGlutenFree,
                          setRecipeLactoseFree),
                      SectionDivider(),
                      ...getIngredientsWidgetList(),
                      SectionDivider(),
                      ...getStepsWidgetList(),
                      SectionDivider(),
                      FlatButton(
                          child: Text("SUBMIT RECIPE", style: titleStyle),
                          color: Colors.orange[300],
                          minWidth: double.infinity,
                          onPressed: submitRecipe),
                    ])))));
  }

  List<Widget> getIngredientsWidgetList() {
    List<Widget> _ingredients = [];

    // Title
    _ingredients.add(Padding(
        padding: EdgeInsets.only(left: 2.5, right: 2.5),
        child: Text("Ingredients", style: titleStyle)));

    // All ingredients
    for (int i = 0; i < _ingredientsData.length; i++) {
      _ingredients.add(WriteIngredientView(
          _ingredientsData[i],
          setIngredientQuantity,
          setIngredientUnit,
          setIngredientName,
          deleteIngredient));
    }
    _ingredients.add(SizedBox(height: 5));
    if (_ingredientsData.length == 0) {
      _ingredients.add(Container(
          child: Text("Enter at least one ingredient", style: errorStyle),
          alignment: Alignment.center));
    }

    // Add button
    _ingredients.add(Padding(
        padding: EdgeInsets.only(left: 2.5, right: 2.5),
        child: FlatButton(
            child: Icon(Icons.add_outlined),
            minWidth: double.infinity,
            onPressed: addIngredient)));
    return _ingredients;
  }

  List<Widget> getStepsWidgetList() {
    List<Widget> _steps = [];

    // Title
    _steps.add(Padding(
        padding: EdgeInsets.only(left: 2.5, right: 2.5),
        child: Text("Procedure", style: titleStyle)));

    // All steps with a divider but the last
    for (int i = 0; i < _stepsData.length; i++) {
      _steps.add(WriteStepView(_stepsData[i], setStepTitle, setStepDescription,
          setStepImageFile(i), deleteStep));
      _steps.add(SizedBox(height: 5));
    }
    if (_stepsData.length == 0) {
      _steps.add(SizedBox(height: 5));
      _steps.add(Container(
          child: Text("Enter at least one step", style: errorStyle),
          alignment: Alignment.center));
    }

    // Add button
    _steps.add(Padding(
      padding: EdgeInsets.only(left: 2.5, right: 2.5),
      child: FlatButton(
          child: Icon(Icons.add_outlined),
          minWidth: double.infinity,
          onPressed: addStep),
    ));
    return _steps;
  }

  void submitRecipe() async {
    // Check if all forms and imagepicker are not empty
    setRecipeValidate();
    bool canSubmit =
        (_recipeData.imageFile != null || _recipeData.imageURL != null) &&
            _ingredientsData.length > 0 &&
            _stepsData.length > 0;
    for (StepData stepData in _stepsData) {
      setStepValidate(stepData.id);
      canSubmit &= (stepData.imageFile != null || stepData.imageURL != null);
    }
    if (_formKey.currentState.validate() && canSubmit) {
      // Submit recipe
      _recipeData.authorId = FirebaseAuth.instance.currentUser.uid;
      _recipeData.submissionTime = DateTime.now();
      if (_recipeData.imageFile != null) {
        // Delete the old recipe image if updating
        if (_recipeData.imageURL != null) {
          deleteImage(_recipeData.imageURL);
        }
        _recipeData.imageURL =
            await uploadImage(_recipeData.imageFile, 'recipe/');
      }
      // If the user is writing a new recipe add it to the database...
      if (_recipeData.recipeId == null) {
        _recipeData.recipeId = await databaseService.addRecipe(_recipeData);
      }
      // ... otherwise if the user is editing update the recipe and remove extra ingredients
      else {
        await databaseService.updateRecipe(_recipeData);
        databaseService.removeIngredientsAfter(
            _recipeData.recipeId, _ingredientsData.length);
        databaseService.removeStepsAfter(
            _recipeData.recipeId, _stepsData.length);
      }

      // Submit all ingredients
      for (IngredientData ingredientData in _ingredientsData) {
        databaseService.addIngredient(ingredientData, _recipeData.recipeId);
      }

      // Submit all steps
      for (StepData stepData in _stepsData) {
        if (stepData.imageFile != null) {
          // Delete the old step image if updating
          if (stepData.imageURL != null) {
            deleteImage(stepData.imageURL);
          }
          stepData.imageURL = await uploadImage(stepData.imageFile, 'step/');
        }
        databaseService.addStep(stepData, _recipeData.recipeId);
      }

      // Update author recipeNumber
      databaseService.updateUserRecipe(1);

      // Show the view of the recipe and then reset the form
      Navigator.pushNamed(context, '/recipeView', arguments: _recipeData)
          .then((_) => resetData());
    }
  }

  // Upload a generic image to Firebase Storage
  Future<String> uploadImage(File image, String path) async {
    Reference storageReference =
        FirebaseStorage.instance.ref().child(path + Path.basename(image.path));
    await storageReference.putFile(image);
    return await storageReference.getDownloadURL();
  }

  // Delete an image from Firebase Storage
  Future<void> deleteImage(String imageURL) async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    return await firebaseStorage.refFromURL(imageURL).delete();
  }

  // Reset form data after submitting a recipe
  void resetData() {
    setState(() {
      _recipeData = RecipeData(difficulty: 0);
      _ingredientsData = [IngredientData(id: 1)];
      _stepsData = [StepData(id: 1)];
    });
    _formKey.currentState.reset();
  }

  // Delete recipe from Firebase Firestore if the user was editing one and reset the forms data
  void deleteRecipe() {
    if (_recipeData.recipeId != null) {
      deleteImage(_recipeData.imageURL);
      for (StepData stepData in _stepsData) {
        deleteImage(stepData.imageURL);
      }
      databaseService.recipeCollection.doc(_recipeData.recipeId).delete();
      databaseService.updateUserRecipe(-1);
    }
    resetData();
  }

  // Recipe setters
  void setRecipeImage(File _image) =>
      setState(() => _recipeData.imageFile = _image);
  void setRecipeTitle(String text) => setState(() => _recipeData.title = text);
  void setRecipeSubtitle(String text) =>
      setState(() => _recipeData.subtitle = text);
  void setRecipeDescription(String text) =>
      setState(() => _recipeData.description = text);
  void setRecipeTime(String text) =>
      setState(() => _recipeData.time = int.tryParse(text) ?? 0);
  void setRecipeServings(String text) =>
      setState(() => _recipeData.servings = int.tryParse(text) ?? 0);
  void setRecipeDifficulty(int val) =>
      setState(() => _recipeData.difficulty = val);
  void setRecipeValidate() => setState(() => _recipeData.validate = true);

  // Recipe categories
  void setRecipeCategory(String text) =>
      setState(() => _recipeData.category = text);
  void setRecipeVegan(bool val) => setState(() => _recipeData.isVegan = val);
  void setRecipeVegetarian(bool val) =>
      setState(() => _recipeData.isVegetarian = val);
  void setRecipeGlutenFree(bool val) =>
      setState(() => _recipeData.isGlutenFree = val);
  void setRecipeLactoseFree(bool val) =>
      setState(() => _recipeData.isLactoseFree = val);

  // Ingredient setters
  void addIngredient() => setState(() =>
      _ingredientsData.add(IngredientData(id: _ingredientsData.length + 1)));
  void setIngredientQuantity(int id, String text) => setState(
      () => _ingredientsData[id - 1].quantity = double.tryParse(text) ?? 0.0);
  void setIngredientUnit(int id, String text) =>
      setState(() => _ingredientsData[id - 1].unit = text);
  void setIngredientName(int id, String text) =>
      setState(() => _ingredientsData[id - 1].name = text);
  void deleteIngredient(int id) => setState(() {
        // Remove the specified ingredient and update the other ids
        for (int i = id; i < _ingredientsData.length; i++) {
          _ingredientsData[i].id -= 1;
        }
        _ingredientsData.removeAt(id - 1);
        FocusScope.of(context)
            .unfocus(); // Remove text focus, focus the wrong element otherwise
      });

  // Step setters
  void addStep() =>
      setState(() => _stepsData.add(StepData(id: _stepsData.length + 1)));
  void setStepTitle(int id, String text) =>
      setState(() => _stepsData[id - 1].title = text);
  void setStepDescription(int id, String text) =>
      setState(() => _stepsData[id - 1].description = text);
  Function(File) setStepImageFile(int id) =>
      (File image) => setState(() => _stepsData[id].imageFile = image);
  void setStepValidate(int id) =>
      setState(() => _stepsData[id - 1].validate = true);
  void deleteStep(int id) => setState(() {
        // Remove the specified ingredient and update the other ids
        for (int i = id; i < _stepsData.length; i++) {
          _stepsData[i].id -= 1;
        }
        _stepsData.removeAt(id - 1);
        FocusScope.of(context)
            .unfocus(); // Remove text focus, focus the wrong element otherwise
      });
}

class DeleteIcon extends StatelessWidget {
  final Function() deleteRecipe;

  DeleteIcon(this.deleteRecipe);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.delete, color: errorColor),
      onPressed: () {
        showDeleteDialog(context);
      },
    );
  }

  // Show a popup to ask confirmation of the deletion of the recipe
  Future<void> showDeleteDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure you want to delete this recipe?'),
          actions: <Widget>[
            TextButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            TextButton(
                child: Text('Yes'),
                onPressed: () {
                  deleteRecipe();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }),
          ],
        );
      },
    );
  }
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
            child: TextFormFieldShort(
                "30",
                recipeData.time == null ? "" : recipeData.time.toString(),
                setRecipeTime,
                NumberFieldValidator.validate,
                keyboardType: TextInputType.number),
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
            child: TextFormFieldShort(
                "4",
                recipeData.servings == null
                    ? ""
                    : recipeData.servings.toString(),
                setRecipeServings,
                NumberFieldValidator.validate,
                keyboardType: TextInputType.number),
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
            child: IconButton(
              onPressed: () => setDifficulty(0),
              iconSize: 38,
              splashRadius: 35,
              icon: Icon(
                AppIcons.chef_hat,
                color: difficultyColors[recipeData.difficulty],
              ),
            ),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: IconButton(
              onPressed: () => setDifficulty(1),
              iconSize: 38,
              splashRadius: 35,
              icon: Icon(
                AppIcons.chef_hat,
                color: recipeData.difficulty >= 1
                    ? difficultyColors[recipeData.difficulty]
                    : difficultyBaseColor,
              ),
            ),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: IconButton(
              onPressed: () => setDifficulty(2),
              iconSize: 38,
              splashRadius: 33,
              icon: Icon(
                AppIcons.chef_hat,
                color: recipeData.difficulty >= 2
                    ? difficultyColors[recipeData.difficulty]
                    : difficultyBaseColor,
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

  CategoryDropdown(this.recipeData, this.setCategory, this.setVegan,
      this.setVegetarian, this.setGlutenFree, this.setLactoseFree);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 2.5),
      child: Column(
        children: [
          Row(children: [
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
                isExpanded: true,
                onChanged: setCategory,
                value: recipeData.category == null
                    ? categories[0]
                    : recipeData.category,
                items: categories.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ]),
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
            value: recipeData.isVegetarian == null
                ? false
                : recipeData.isVegetarian,
            onChanged: setVegetarian,
          ),
          CheckboxListTile(
            title: Text("Gluten free"),
            secondary: Icon(AppIcons.gluten_free),
            activeColor: Colors.orange,
            value: recipeData.isGlutenFree == null
                ? false
                : recipeData.isGlutenFree,
            onChanged: setGlutenFree,
          ),
          CheckboxListTile(
            title: Text("Lactose free"),
            secondary: Icon(AppIcons.lactose_free),
            activeColor: Colors.orange,
            value: recipeData.isLactoseFree == null
                ? false
                : recipeData.isLactoseFree,
            onChanged: setLactoseFree,
          ),
        ],
      ),
    );
  }
}
