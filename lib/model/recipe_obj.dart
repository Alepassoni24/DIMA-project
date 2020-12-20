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
  int difficulty;
  String category;
  bool isVegan;
  bool isVegetarian;
  bool isGlutenFree;
  bool isLactoseFree;
  File imageFile;
  bool validate = false;
  
  RecipeData({
    this.recipeId,
    this.title,
    this.subtitle,
    this.description,
    this.imageURL,
    this.rating,
    this.submissionTime,
    this.time,
    this.servings,
    this.difficulty,
    this.category,
    this.isVegan,
    this.isVegetarian,
    this.isGlutenFree,
    this.isLactoseFree,
  });
}

class IngredientData {
  int id;
  String quantity;
  String unit;
  String name;

  IngredientData({this.id, this.quantity, this.unit, this.name});
}

class StepData {
  int id;
  String title;
  String description;
  String imageURL;
  File imageFile;
  bool validate = false;

  StepData({this.id, this.title, this.description, this.imageURL});
}
