import 'package:dima_project/model/recipe_obj.dart';
import 'package:dima_project/services/database.dart';
import 'package:dima_project/shared/loading.dart';
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
          return Loading();
        
        return new Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Ingredients:", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))
            ),
            SizedBox(height: 10),
            ...snapshot.data.documents.map<Widget>((document) =>
              IngredientView(databaseService.ingredientsDataFromSnapshot(document))).toList()
          ]
        );
      }
    );
  }
}

class IngredientView extends StatelessWidget {
  final IngredientData ingredientData;

  IngredientView(this.ingredientData);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(ingredientData.quantity + " ", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(ingredientData.unit + " ", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(ingredientData.name),
          ]
        ),
        SizedBox(height: 5),
      ]
    );
  }
}
