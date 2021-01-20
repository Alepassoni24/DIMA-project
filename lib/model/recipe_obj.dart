import 'dart:io';
import 'package:uuid/uuid.dart';

class RecipeData {
  final String key = Uuid().v4();
  String recipeId;
  String authorId;
  String title;
  String subtitle;
  String description;
  String imageURL;
  double rating;
  int time;
  int servings;
  DateTime submissionTime;
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
    this.rating = 0.0,
    this.submissionTime,
    this.time,
    this.servings,
    this.difficulty = 0,
    this.category = "First course",
    this.isVegan = false,
    this.isVegetarian = false,
    this.isGlutenFree = false,
    this.isLactoseFree = false,
    this.reviewNumber = 0,
  });
}

class IngredientData {
  final String key = Uuid().v4();
  int id;
  double quantity;
  String unit;
  String name;

  IngredientData({this.id, this.quantity, this.unit, this.name});
}

class StepData {
  final String key = Uuid().v4();
  int id;
  String title;
  String description;
  String imageURL;
  File imageFile;
  bool validate = false;

  StepData({this.id, this.title, this.description, this.imageURL});
}

class ReviewData {
  final String key = Uuid().v4();
  String reviewId;
  String authorId;
  String comment;
  int rating;
  DateTime submissionTime;

  ReviewData({
    this.reviewId,
    this.authorId,
    this.comment,
    this.rating = 0,
    this.submissionTime,
  });
}
