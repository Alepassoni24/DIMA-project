import 'package:dima_project/model/recipe_obj.dart';
import 'package:dima_project/screens/homeRecipes/recipe_card.dart';
import 'package:dima_project/services/database.dart';
import 'package:dima_project/shared/loading.dart';
import 'package:flutter/material.dart';

class LatestRecipes extends StatefulWidget {
  @override
  LatestRecipesState createState() => new LatestRecipesState();
}

class LatestRecipesState extends State<LatestRecipes> {
  List<RecipeData> recipesList = List();
  final DatabaseService databaseService = new DatabaseService();
  final ScrollController scrollController = ScrollController();

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
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.orange[50],
        appBar: AppBar(
          backgroundColor: Colors.orange[400],
          elevation: 0.0,
          title: Text('Home'),
        ),
        body: recipesList.isEmpty
            ? Loading()
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
    recipesList = List();
    databaseService.getLastRecipes(10).get().then((value) {
      value.docs.forEach((element) {
        setState(() {
          recipesList.add(databaseService.recipeDataFromSnapshot(element));
        });
      });
    });
  }

  // Fetch next 10 documents
  Future<void> fetchNextDocuments() async {
    databaseService
        .getNextLastRecipes(10, recipesList.last.submissionTime)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        setState(() {
          recipesList.add(databaseService.recipeDataFromSnapshot(element));
        });
      });
    });
  }
}
