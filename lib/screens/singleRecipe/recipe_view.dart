import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/model/recipe_obj.dart';
import 'package:dima_project/model/user_obj.dart';
import 'package:dima_project/screens/review/review_view.dart';
import 'package:dima_project/screens/review/write_review_view.dart';
import 'package:dima_project/screens/singleRecipe/ingredients_view.dart';
import 'package:dima_project/screens/singleRecipe/steps_view.dart';
import 'package:dima_project/services/database.dart';
import 'package:dima_project/shared/app_icons.dart';
import 'package:dima_project/shared/constants.dart';
import 'package:dima_project/shared/loading.dart';
import 'package:dima_project/shared/section_divider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class RecipeView extends StatelessWidget {
  final DatabaseService databaseService =
      new DatabaseService(uid: FirebaseAuth.instance.currentUser.uid);
  final ScrollController scrollController = new ScrollController();

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
          if (recipeData.authorId == FirebaseAuth.instance.currentUser.uid)
            EditIcon(recipeData),
          SaveIcon(databaseService, recipeData.recipeId),
          ShareIcon(recipeData.title),
        ],
      ),
      body: Center(
        child: ListView(
          controller: scrollController,
          padding: EdgeInsets.all(10),
          children: [
            MainPhoto(recipeData.imageURL),
            SectionDivider(),
            AuthorImage(databaseService, recipeData.authorId),
            SectionDivider(),
            Description(recipeData.description),
            SectionDivider(),
            Category(recipeData.category),
            SectionDivider(),
            if (recipeData.isVegan ||
                recipeData.isVegetarian ||
                recipeData.isGlutenFree ||
                recipeData.isLactoseFree) ...[
              Checkmarks(recipeData),
              SectionDivider(),
            ],
            Difficulty(recipeData.difficulty),
            SectionDivider(),
            Time(recipeData.time),
            SectionDivider(),
            Servings(recipeData.servings),
            SectionDivider(),
            IngredientsView(databaseService, recipeData.recipeId),
            SectionDivider(),
            StepsView(databaseService, recipeData.recipeId),
            SectionDivider(),
            if (recipeData.authorId !=
                FirebaseAuth.instance.currentUser.uid) ...[
              WriteReviewView(recipeData),
              SectionDivider(),
            ],
            Text("Ratings and reviews", style: titleStyle),
            ReviewView(recipeData, scrollController),
          ],
        ),
      ),
    );
  }
}

class EditIcon extends StatelessWidget {
  final RecipeData recipeData;

  EditIcon(this.recipeData);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        Navigator.pushNamed(context, '/writeRecipe', arguments: recipeData);
      },
    );
  }
}

class SaveIcon extends StatefulWidget {
  final DatabaseService databaseService;
  final String recipeId;

  SaveIcon(this.databaseService, this.recipeId);

  @override
  SaveIconState createState() => SaveIconState(databaseService, recipeId);
}

class SaveIconState extends State<SaveIcon> {
  final DatabaseService databaseService;
  final String recipeId;
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    databaseService.userData.first.then((value) =>
        setState(() => isSaved = value.savedRecipes.contains(recipeId)));
  }

  SaveIconState(this.databaseService, this.recipeId);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_outline),
      onPressed: () {
        setState(() {
          if (isSaved) {
            isSaved = false;
            databaseService.removeSavedRecipe(recipeId);
          } else {
            isSaved = true;
            databaseService.addSavedRecipe(recipeId);
          }
        });
      },
    );
  }
}

class ShareIcon extends StatelessWidget {
  final String recipeTitle;

  ShareIcon(this.recipeTitle);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.share),
      onPressed: () {
        Share.share("Check out " + recipeTitle + " on CookingTime!");
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
          )),
    );
  }
}

class AuthorImage extends StatelessWidget {
  final DatabaseService databaseService;
  final String authorId;

  AuthorImage(this.databaseService, this.authorId);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: databaseService.getUser(authorId),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text('Something went wrong');
          if (snapshot.connectionState == ConnectionState.waiting)
            return Loading();
          if (!snapshot.hasData) return Text('User does not exists');

          final UserData user =
              databaseService.userDataFromSnapshot(snapshot.data);

          return new Row(
            children: [
              Text(user.username, style: titleStyle),
              Spacer(),
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(user.profilePhotoURL),
              ),
            ],
          );
        });
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
          style: descriptionStyle,
        ));
  }
}

class Category extends StatelessWidget {
  final String recipeCategory;

  Category(this.recipeCategory);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.fastfood_outlined),
          SizedBox(width: 10),
          Text(recipeCategory),
        ],
      ),
    );
  }
}

class Checkmarks extends StatelessWidget {
  final RecipeData recipeData;

  Checkmarks(this.recipeData);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          recipeData.isVegan
              ? Icon(AppIcons.vegan, size: 25)
              : SizedBox(width: 25),
          SizedBox(width: 10),
          recipeData.isVegetarian
              ? Icon(AppIcons.vegan, size: 25)
              : SizedBox(width: 25),
          SizedBox(width: 10),
          recipeData.isGlutenFree
              ? Icon(AppIcons.gluten_free, size: 25)
              : SizedBox(width: 25),
          SizedBox(width: 10),
          recipeData.isLactoseFree
              ? Icon(AppIcons.lactose_free, size: 25)
              : SizedBox(width: 25),
        ],
      ),
    );
  }
}

class Difficulty extends StatelessWidget {
  final int recipeDifficulty;

  Difficulty(this.recipeDifficulty);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Difficulty:"),
          SizedBox(width: 10),
          Icon(AppIcons.chef_hat,
              size: 25, color: difficultyColors[recipeDifficulty]),
          SizedBox(width: 10),
          Icon(AppIcons.chef_hat,
              size: 25,
              color: recipeDifficulty >= 1
                  ? difficultyColors[recipeDifficulty]
                  : difficultyBaseColor),
          SizedBox(width: 10),
          Icon(AppIcons.chef_hat,
              size: 25,
              color: recipeDifficulty >= 2
                  ? difficultyColors[recipeDifficulty]
                  : difficultyBaseColor),
        ],
      ),
    );
  }
}

class Time extends StatelessWidget {
  final int recipeTime;

  Time(this.recipeTime);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.timer_outlined),
          SizedBox(width: 10),
          Text("Time: " + recipeTime.toString() + " minutes"),
        ],
      ),
    );
  }
}

class Servings extends StatelessWidget {
  final int servingNumber;

  Servings(this.servingNumber);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline),
          SizedBox(width: 10),
          Text("Servings: " + servingNumber.toString() + " people"),
        ],
      ),
    );
  }
}
