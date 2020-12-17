import 'package:dima_project/model/recipe_obj.dart';
import 'package:dima_project/screens/singleRecipe/ingredients_view.dart';
import 'package:dima_project/screens/singleRecipe/steps_view.dart';
import 'package:dima_project/services/database.dart';
import 'package:dima_project/shared/section_divider.dart';
import 'package:flutter/material.dart';

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
            SectionDivider(),
            Description(recipeData.description),
            SectionDivider(),
            Time(recipeData.time),
            SectionDivider(),
            Servings(recipeData.servings),
            SectionDivider(),
            IngredientsView(databaseService, recipeData.recipeId),
            SectionDivider(),
            StepsView(databaseService, recipeData.recipeId),
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
        borderRadius: BorderRadius.circular(5),
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
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        recipeDescription,
        style: TextStyle(fontSize: 18),
      )
    );
  }
}

class Time extends StatelessWidget {
  final String recipeTime;

  Time(this.recipeTime);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.timer_outlined),
          SizedBox(width: 10),
          Text("Time: " + recipeTime),
        ],
      ),
    );
  }
}

class Servings extends StatelessWidget {
  final String servingNumber;

  Servings(this.servingNumber);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline),
          SizedBox(width: 10),
          Text("Servings: " + servingNumber),
        ],
      ),
    );
  }
}
