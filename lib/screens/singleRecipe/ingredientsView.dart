import 'package:dima_project/model/recipe_obj.dart';
import 'package:dima_project/services/database.dart';
import 'package:flutter/material.dart';

class IngredientsView extends StatelessWidget {
  final DatabaseService databaseService;
  final String recipeId;

  IngredientsView(this.databaseService, this.recipeId);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: databaseService.getRecipeIngredients(recipeId),
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return Text('Something went wrong');
        if (snapshot.connectionState == ConnectionState.waiting)
          return Text("Loading");
        
        return new Column(
          children: [
            Text("Ingredients:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            ...snapshot.data.documents.map<Widget>((document) =>
            IngredientView(databaseService.ingredientsDataFromSnapshot(document))).toList()
          ]
        );
      }
    );
  }
}

class IngredientView extends StatelessWidget {
  final IngredientData ingredientsData;

  IngredientView(this.ingredientsData);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(ingredientsData.quantity + " ", style: TextStyle(fontWeight: FontWeight.bold),),
        Text(ingredientsData.unit + " ", style: TextStyle(fontWeight: FontWeight.bold),),
        Text(ingredientsData.name),
      ]
    );
  }
}