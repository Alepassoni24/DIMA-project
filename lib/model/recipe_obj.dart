import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeData {
  String recipeId;
  String authorId;
  String title;
  String subtitle;
  String description;
  String imageURL;
  double rating;
  int time;
  int servings;
  Timestamp submissionTime;
  int difficulty;
  String category;
  bool isVegan;
  bool isVegetarian;
  bool isGlutenFree;
  bool isLactoseFree;
  int reviewNumber;
  File imageFile;
  bool validate = false;

  RecipeData({
    this.recipeId,
    this.authorId,
    this.title,
    this.subtitle,
    this.description,
    this.imageURL,
    this.rating,
    this.submissionTime,
    this.time,
    this.servings,
    this.difficulty,
    this.category = "First course",
    this.isVegan = false,
    this.isVegetarian = false,
    this.isGlutenFree = false,
    this.isLactoseFree = false,
    this.reviewNumber = 0,
  });
}

class IngredientData {
  int id;
  double quantity;
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
