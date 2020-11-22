import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeObj {
  final String recipeId;

  RecipeObj({this.recipeId});
}

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
