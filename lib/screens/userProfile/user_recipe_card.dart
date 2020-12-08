import 'package:dima_project/model/recipe_obj.dart';
import 'package:flutter/material.dart';

//wideget to display a cards of user recipes
class UserRecipeCard extends StatelessWidget {
  //data of the recipe
  final RecipeData recipeData;

  UserRecipeCard(this.recipeData);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: InkWell(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ImageContainer(recipeData.imageURL),
                  ),
                  TitleListTile(
                      recipeData.title,
                      recipeData.rating,
                      DateTime.fromMicrosecondsSinceEpoch(
                          recipeData.submissionTime.microsecondsSinceEpoch)),
                ],
              )
            ],
          ),
          onTap: () {
            Navigator.pushNamed(context, '/recipeView', arguments: recipeData);
          },
        ),
      ),
    );
  }
}

//TODO verify the layout
//class for the title of the recipe card
class TitleListTile extends StatelessWidget {
  final String cardTitle;
  final String cardRating;
  final DateTime dateOfSubmission;
  //final String numOfReviwes;

  TitleListTile(this.cardTitle, this.cardRating, this.dateOfSubmission);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(cardTitle),
        Row(
          children: [
            Text(dateOfSubmission.day.toString() +
                '-' +
                dateOfSubmission.month.toString() +
                '-' +
                dateOfSubmission.year.toString()),
            SizedBox(
              width: 5,
            ),
            Text('##'),

            ///TODO
            Icon(
              Icons.message,
              color: Colors.grey[600],
            ),
            SizedBox(
              width: 5,
            ),
            Text(cardRating),
            Icon(
              Icons.star_half,
              color: Colors.orange[400],
            ),
          ],
        ),
      ],
    );
  }
}

//TODO put this class in a shared part in order to save from code repetition
//class to display a small picture of the recipe
class ImageContainer extends StatelessWidget {
  final String cardImageURL;

  ImageContainer(this.cardImageURL);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 90,
      decoration: new BoxDecoration(
        image: new DecorationImage(
          fit: BoxFit.fitWidth,
          alignment: Alignment.center,
          image: new NetworkImage(cardImageURL),
        ),
      ),
    );
  }
}
