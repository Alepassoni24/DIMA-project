import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/model/recipe_obj.dart';
import 'package:dima_project/model/user_obj.dart';
import 'package:dima_project/services/database.dart';
import 'package:dima_project/shared/app_icons.dart';
import 'package:dima_project/shared/constants.dart';
import 'package:dima_project/shared/loading.dart';
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
              TitleListTile(recipeData),
              ImageContainer(recipeData.imageURL),
              SizedBox(height: 5),
              BottomRow(recipeData),
              SizedBox(height: 5),
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

// This ListTile contains the author profile image and the recipe title, subtitle, rating
class TitleListTile extends StatelessWidget {
  final DatabaseService databaseService = new DatabaseService();
  final RecipeData recipeData;

  TitleListTile(this.recipeData);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: databaseService.getUser(recipeData.authorId),
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return Text('Something went wrong');
        if (snapshot.connectionState == ConnectionState.waiting)
          return Loading();
        if (!snapshot.hasData)
          return Text('User does not exists');
        
        final UserData user = databaseService.userDataFromSnapshot(snapshot.data);
        
        return ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(user.profilePhotoURL),
          ),
          title: Text(recipeData.title),
          subtitle: Text(recipeData.subtitle),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(recipeData.rating.toStringAsFixed(1)),
              Icon(
                Icons.star_half,
                color: Colors.orange[400],
              ),
            ],
          ),
        );
      }
    );
  }
}

// This image container shows the main image of the recipe
class ImageContainer extends StatelessWidget {
  final String cardImageURL;

  ImageContainer(this.cardImageURL);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: new BoxDecoration(
        image: new DecorationImage(
          fit: BoxFit.fitWidth,
          alignment: Alignment.center,
          image: new NetworkImage(cardImageURL),
        )
      ),
    );
  }
}

// This Row shows the checkmarks and the difficulty of the recipe
class BottomRow extends StatelessWidget {
  final RecipeData recipeData;

  BottomRow(this.recipeData);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 10),
        recipeData.isVegan ? Icon(AppIcons.vegan, size: 25) : SizedBox(width: 25),
        SizedBox(width: 10),
        recipeData.isVegetarian ? Icon(AppIcons.vegan, size: 25) : SizedBox(width: 25),
        SizedBox(width: 10),
        recipeData.isGlutenFree ? Icon(AppIcons.gluten_free, size: 25) : SizedBox(width: 25),
        SizedBox(width: 10),
        recipeData.isLactoseFree ? Icon(AppIcons.lactose_free, size: 25) : SizedBox(width: 25),
        SizedBox(width: 10),
        Spacer(),
        Icon(AppIcons.chef_hat, size: 25, color: difficultyColors[recipeData.difficulty]),
        SizedBox(width: 10),
        Icon(AppIcons.chef_hat, size: 25, color: recipeData.difficulty >= 1 ? difficultyColors[recipeData.difficulty] : difficultyBaseColor),
        SizedBox(width: 10),
        Icon(AppIcons.chef_hat, size: 25, color: recipeData.difficulty >= 2 ? difficultyColors[recipeData.difficulty] : difficultyBaseColor),
        SizedBox(width: 10),
      ],
    );
  }
}
