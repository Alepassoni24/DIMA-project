import 'package:dima_project/model/recipe_obj.dart';
import 'package:dima_project/services/database.dart';
import 'package:flutter/material.dart';

import 'ingredientsView.dart';

class RecipeView extends StatelessWidget{
  final DatabaseService databaseService = new DatabaseService();
  
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
          padding: EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
          children: [
            MainPhoto(recipeData.imageURL),
            Divider(color: Colors.orange[900], thickness: 1.5, indent: 5, endIndent: 5),
            Description(recipeData.description),
            Divider(color: Colors.orange[900], thickness: 1.5, indent: 5, endIndent: 5),
            Time(recipeData.timeInMinutes),
            Divider(color: Colors.orange[900], thickness: 1.5, indent: 5, endIndent: 5),
            IngredientsView(databaseService, recipeData.recipeId),
            Divider(color: Colors.orange[900], thickness: 1.5, indent: 5, endIndent: 5),
            Steps(databaseService, recipeData.recipeId),
          ],
        ),
      ),
    );
  }
}

class SaveIcon extends StatefulWidget {

  @override
  SaveIconState createState() => SaveIconState();
}

class SaveIconState extends State<SaveIcon> {
  IconData icon = Icons.bookmark_outline;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      onPressed: () {
        // TODO: Add actual behavior
        setState(() => {
          if(icon == Icons.bookmark_outline)
            icon = Icons.bookmark
          else
            icon = Icons.bookmark_outline});
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
        borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
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
          Text(recipeTimeInMinutes),
        ],
      ),
    );
  }
}

class Steps extends StatelessWidget {
  final DatabaseService databaseService;
  final String recipeId;

  Steps(this.databaseService, this.recipeId);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
