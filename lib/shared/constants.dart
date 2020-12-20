import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.orangeAccent,
      width: 2.0,
    ),
  ),
);

const TextStyle titleStyle = TextStyle(fontSize: 25, fontWeight: FontWeight.bold);

const TextStyle subtitleStyle = TextStyle(fontSize: 17.5, fontWeight: FontWeight.bold);

final TextStyle errorStyle = TextStyle(fontSize: 12, color: Colors.red[700]);

const List<String> categories = [
  "First course",
  "Second course",
  "Single course",
  "Side dish",
  "Dessert",
];
