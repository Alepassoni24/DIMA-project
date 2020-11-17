import 'package:dima_project/screens/recipes/recipeCard.dart';
import 'package:flutter/material.dart';

class LatestRecipes extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: getLatestRecipes(),
      )
    );
  }
  
  // Get latest (10?) recipes from the database
  List<Widget> getLatestRecipes() {
    return List<Widget>.generate(
      10,
      (i) => RecipeCard('Recipe title', 'Recipe subtitle', 'https://cdn.vega-direct.com/media/image/3d/ea/85/EMC-15167-schale-alessia_800x800.jpg'),
    );
  }
}
