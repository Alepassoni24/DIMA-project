import 'package:flutter/material.dart';

//The recipe must be obtained from a query to the database
class RecipeCard extends StatelessWidget{
  final String cardTitle;
  final String cardSubtitle;
  final String cardImageURL;
  
  RecipeCard(this.cardTitle, this.cardSubtitle, this.cardImageURL);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TitleListTile(cardTitle, cardSubtitle),
            ImageContainer(cardImageURL),
            ButtonRow(),
          ],
        ),
      ),
    );
  }
}

class TitleListTile extends StatelessWidget {
  final String cardTitle;
  final String cardSubtitle;

  TitleListTile(this.cardTitle, this.cardSubtitle);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.food_bank_outlined),
      title: Text(cardTitle),
      subtitle: Text(cardSubtitle),
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
      margin: const EdgeInsets.only(left: 5.0, right: 5.0),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        image: new DecorationImage(
          fit: BoxFit.fitWidth,
          alignment: Alignment.center,
          image: new NetworkImage(cardImageURL),
        )
      ),
    );
  }
}

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
