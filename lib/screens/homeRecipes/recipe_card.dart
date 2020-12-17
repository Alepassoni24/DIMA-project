import 'package:dima_project/model/recipe_obj.dart';
import 'package:flutter/material.dart';

//The recipe must be obtained from a query to the database
class RecipeCard extends StatelessWidget{
  final RecipeData recipeData;
  
  RecipeCard(this.recipeData);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TitleListTile(recipeData.title, recipeData.subtitle, recipeData.rating),
              ImageContainer(recipeData.imageURL),
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

class TitleListTile extends StatelessWidget {
  final String cardTitle;
  final String cardSubtitle;
  final String cardRating;

  TitleListTile(this.cardTitle, this.cardSubtitle, this.cardRating);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.account_circle_outlined), // TODO: Change with author avatar
      title: Text(cardTitle),
      subtitle: Text(cardSubtitle),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(cardRating),
          Icon(
            Icons.star_half,
            color: Colors.orange[400],
          ),
        ],
      ),
    );
  }
}

class ImageContainer extends StatelessWidget {
  final String cardImageURL;

  ImageContainer(this.cardImageURL);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
        image: new DecorationImage(
          fit: BoxFit.fitWidth,
          alignment: Alignment.center,
          image: new NetworkImage(cardImageURL),
        )
      ),
    );
  }
}

//TODO: Remove this if only one button is enough
class ButtonRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        TextButton(
          child: const Text('READ'),
          onPressed: () {/* ... */},
        ),
        const SizedBox(width: 8),
        TextButton(
          child: const Text('COOK'),
          onPressed: () {/* ... */},
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
