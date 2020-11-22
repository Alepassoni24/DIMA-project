import 'package:dima_project/model/recipe_obj.dart';
import 'package:flutter/material.dart';

class RecipeView extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final RecipeData recipeData = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        backgroundColor: Colors.orange[400],
        elevation: 0.0,
        title: Text(recipeData.title),
        actions: [
          SaveIcon(),
          ShareIcon(),
        ],
      ),
      body: Center(
        child: ListView(
          children: [
            MainPhoto(recipeData.imageURL),
            Divider(color: Colors.orange[900], thickness: 1.5, indent: 10, endIndent: 10),
            Description(recipeData.description),
            Divider(color: Colors.orange[900], thickness: 1.5, indent: 10, endIndent: 10),
            Time(recipeData.timeInMinutes),
            Divider(color: Colors.orange[900], thickness: 1.5, indent: 10, endIndent: 10),
            Ingredients(),
            Divider(color: Colors.orange[900], thickness: 1.5, indent: 10, endIndent: 10),
            Steps(),
          ],
        ),
      ),
    );
  }
}

class SaveIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.bookmark_outline),
      onPressed: () {
        /* TODO */
      },
    );
  }
}

class ShareIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.share),
      onPressed: () {
        /* TODO */
      },
    );
  }
}

class MainPhoto extends StatelessWidget {
  final String imageURL;

  MainPhoto(this.imageURL);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: new BoxDecoration(
        image: new DecorationImage(
          fit: BoxFit.cover,
          alignment: Alignment.center,
          image: new NetworkImage(imageURL),
        )
      ),
    );
  }
}

class Description extends StatelessWidget {
  final String recipeDescription;

  Description(this.recipeDescription);
  @override
  Widget build(BuildContext context) {
    return Text(
      recipeDescription,
      style: TextStyle(fontSize: 18),
    );
  }
}

class Time extends StatelessWidget {
  final String recipeTimeInMinutes;

  Time(this.recipeTimeInMinutes);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.timer_outlined),
          SizedBox(width: 10),
          Text(recipeTimeInMinutes + ' minutes'),
        ],
      ),
    );
  }
}

class Ingredients extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class Steps extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
