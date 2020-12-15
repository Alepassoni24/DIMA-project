import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeData {
  String recipeId;
  String title;
  String subtitle;
  String description;
  String imageURL;
  String rating;
  String time;
  String servings;
  Timestamp submissionTime;
  
  RecipeData({this.recipeId, this.title, this.subtitle, this.description, this.imageURL, this.rating, this.submissionTime, this.time, this.servings});
}

class IngredientData {
  String id;
  String quantity;
  String unit;
  String name;

  IngredientData({this.id, this.quantity, this.unit, this.name});
}

class StepData {
  String id;
  String title;
  String description;
  String imageURL;
  File imageFile;

  StepData({this.id, this.title, this.description, this.imageURL, this.imageFile});
}
