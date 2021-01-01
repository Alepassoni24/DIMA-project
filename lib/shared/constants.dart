import 'package:flutter/material.dart';

// Input decoration for TextFormFields
const textInputDecoration = InputDecoration(
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.orangeAccent,
      width: 2.0,
    ),
  ),
);

// Text styles for different types of text widgets
const TextStyle titleStyle =
    TextStyle(fontSize: 25, fontWeight: FontWeight.bold);
const TextStyle subtitleStyle =
    TextStyle(fontSize: 17.5, fontWeight: FontWeight.bold);
const TextStyle descriptionStyle = TextStyle(fontSize: 17.5);
final TextStyle errorStyle = TextStyle(fontSize: 12, color: Colors.red[700]);

// List of possible categories for a recipe
const List<String> categories = [
  "First course",
  "Second course",
  "Single course",
  "Side dish",
  "Dessert",
];

// Colors for the recipe fields
const difficultyBaseColor = Colors.grey;
const List<Color> difficultyColors = [Colors.yellow, Colors.orange, Colors.red];
final Color ratingStarColor = Colors.orange[500];
