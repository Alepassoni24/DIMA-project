import 'package:dima_project/model/recipe_obj.dart';
import 'package:dima_project/shared/constants.dart';
import 'package:flutter/material.dart';

class WriteReviewView extends StatelessWidget {
  final RecipeData recipeData;

  WriteReviewView(this.recipeData);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text("Your review", style: titleStyle)
        ),
        // TODO
      ],
    );
  }
}
