import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/screens/recipes/recipeCard.dart';
import 'package:dima_project/services/database.dart';
import 'package:flutter/material.dart';

class LatestRecipes extends StatelessWidget{

  final DatabaseService databaseService = new DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: databaseService.getLastRecipes(10),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }
          return new ListView(
            padding: const EdgeInsets.all(8),
            children: snapshot.data.documents.map<Widget>(snapshotToRecipeCard).toList()
          );
        }
      )
    );
  }

  RecipeCard snapshotToRecipeCard(DocumentSnapshot document) {
    return RecipeCard(document.data()['title'], document.data()['subtitle'], document.data()['imageURL']);
  }
}
