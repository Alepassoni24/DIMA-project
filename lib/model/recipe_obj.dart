import 'dart:io';
import 'package:flutter/material.dart';

// Struct class representing all the data of a single recipe
class RecipeData {
  // Document id of the recipe in Firebase Firestore
  String recipeId;
  // Document id of the author in Firebase Firestore
  String authorId;
  // Title of the recipe
  String title;
  // Subtitle of the recipe
  String subtitle;
  // Description of the recipe
  String description;
  // Average rating of the recipe
  double rating;
  // Suggested preparation time of the recipe
  int time;
  // Suggested servings of the recipe
  int servings;
  // First submission date of the recipe
  DateTime submissionTime;
  // Difficulty of the recipe
  int difficulty;
  // Category of the recipe
  String category;
  // Vegan checkmark
  bool isVegan;
  // Vegetarian checkmark
  bool isVegetarian;
  // Gluten free checkmark
  bool isGlutenFree;
  // Lactose free checkmark
  bool isLactoseFree;
  // Total number of reviews received, used to update the average rating
  int reviewNumber;
  // URL of the recipe image (not null only if editing a recipe)
  String imageURL;
  // File of the recipe image (not null only if taken with the ImagePicker)
  File imageFile;
  // Boolean used to validate the image when writing a new recipe
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

// Struct class representing all the data of a single ingredient
class IngredientData {
  // Unique key required for Flutter to manage deletion
  // of ingredients while writing a recipe in WriteRecipeView
  final Key key = UniqueKey();
  // Progressive id of the document in Firebase Firestore, from 1 to 30
  int id;
  // Quantity of the ingredient
  double quantity;
  // Measurement unit of the ingredient
  String unit;
  // Name of the ingredient
  String name;

  IngredientData({this.id, this.quantity, this.unit, this.name});
}

// Struct class representing all the data of a single step
class StepData {
  // Unique key required for Flutter to manage deletion
  // of steps while writing a recipe in WriteRecipeView
  final Key key = UniqueKey();
  // Progressive id of the document in Firebase Firestore, from 1 to 20
  int id;
  // Title of the step
  String title;
  // Description of the step
  String description;
  // URL of the step image step (not null only if editing a recipe)
  String imageURL;
  // File of the step image (not null only if taken with the ImagePicker)
  File imageFile;
  // Boolean used to validate the image when writing a new recipe
  bool validate = false;

  StepData({this.id, this.title, this.description, this.imageURL});
}

class ReviewData {
  // Document id of the review in Firebase Firestore
  String reviewId;
  // Document id of the author in Firebase Firestore
  String authorId;
  // Comment of the review
  String comment;
  // Rating of the review
  int rating;
  // Submission date of the review
  DateTime submissionTime;

  ReviewData({
    this.reviewId,
    this.authorId,
    this.comment,
    this.rating = 0,
    this.submissionTime,
  });
}
