import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeData {
  final String recipeId;

  final String title;
  final String subtitle;
  final String description;
  final String imageURL;
  final String rating;
  final String timeInMinutes;
  final Timestamp submissionTime;
  
  RecipeData({this.recipeId, this.title, this.subtitle, this.description, this.imageURL, this.rating, this.submissionTime, this.timeInMinutes});
}

class IngredientData {
  final String id;
  final String quantity;
  final String unit;
  final String name;

  IngredientData({this.id, this.quantity, this.unit, this.name});
}

class RecipesData {
  final List<Step> steps;

  RecipesData({this.steps});
}

class Step {
  final String id;
  final String title;
  final String description;
  final String imageURL;

  Step({this.id, this.title, this.description, this.imageURL});
}
