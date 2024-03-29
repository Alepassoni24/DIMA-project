import 'dart:math';

import 'package:dima_project/model/recipe_obj.dart';
import 'package:dima_project/screens/homeRecipes/recipe_card.dart';
import 'package:dima_project/services/database.dart';
import 'package:dima_project/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Show the recipes saved by the user
class SavedRecipesView extends StatefulWidget {
  @override
  SavedRecipesViewState createState() => new SavedRecipesViewState();
}

class SavedRecipesViewState extends State<SavedRecipesView> {
  List<String> savedRecipeIds = List();
  final List<RecipeData> recipesList = List();
  final DatabaseService databaseService =
      DatabaseService(uid: FirebaseAuth.instance.currentUser.uid);
  final ScrollController scrollController = ScrollController();
  final _random = new Random();

  // On startup, load 10 random saved recipes from Firebase Firestore
  @override
  void initState() {
    super.initState();
    fetchFirstDocuments();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        fetchNextDocuments();
      }
    });
  }

  @override
  void setState(function) {
    if (mounted) {
      super.setState(function);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: mainAppColor,
          elevation: 0.0,
          title: Text('Saved recipes'),
        ),
        body: recipesList.isEmpty
            // If no recipes are saved yet, show a tooltip to tell the user
            // he can save recipes with the bookmark icon
            ? Center(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('Press'),
                Icon(
                  Icons.bookmark,
                  color: Colors.grey[700],
                ),
                Text('to save recipes here'),
              ]))
            // Otherwise show the list of saved recipes
            : RefreshIndicator(
                onRefresh: () => fetchFirstDocuments(),
                child: ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  controller: scrollController,
                  padding: const EdgeInsets.all(5),
                  itemCount: recipesList.length,
                  itemBuilder: (context, index) {
                    return RecipeCard(recipesList[index]);
                  },
                )));
  }

  // Fetch first 10 documents
  Future<void> fetchFirstDocuments() async {
    savedRecipeIds = (await databaseService.userData.first).savedRecipes;
    setState(() => recipesList.clear());
    return await fetchNextDocuments();
  }

  // Fetch next 10 documents
  Future<void> fetchNextDocuments() async {
    for (int i = 0; savedRecipeIds.isNotEmpty && i < 10; i++) {
      String currentRecipeId =
          savedRecipeIds.removeAt(_random.nextInt(savedRecipeIds.length));
      databaseService.recipeCollection
          .doc(currentRecipeId)
          .get()
          .then((recipeDocument) {
        // If the recipe exists show it...
        if (recipeDocument.exists) {
          setState(() {
            recipesList
                .add(databaseService.recipeDataFromSnapshot(recipeDocument));
          });
        }
        // ... otherwise remove it from the saved list in Firestore
        else {
          databaseService.removeSavedRecipe(currentRecipeId);
        }
      });
    }
  }
}
