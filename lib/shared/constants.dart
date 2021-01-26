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
final TextStyle errorStyle = TextStyle(fontSize: 12, color: errorColor);
//main button text style
final TextStyle textButtonStyle = TextStyle(
  fontSize: 16.0,
  color: Colors.white,
  fontWeight: FontWeight.w500,
);
//text style for user page
final TextStyle numberDataStyle = TextStyle(
  color: Colors.grey[600],
  fontSize: 20,
);

final TextStyle informationDataStyle = TextStyle(
  color: Colors.grey[600],
  fontSize: 17,
  fontWeight: FontWeight.bold,
);

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

final Color errorColor = Colors.red[700];

//Colors of main app component
final Color backgroundColor = Colors.orange[50];
final Color mainAppColor = Colors.orange[400];
final RoundedRectangleBorder roundedBorder = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15.0),
    side: BorderSide(color: mainAppColor));

//orange divider for profile page
final Divider orangeDivider = Divider(
  color: mainAppColor,
  thickness: 1.5,
  indent: 15,
  endIndent: 15,
);
