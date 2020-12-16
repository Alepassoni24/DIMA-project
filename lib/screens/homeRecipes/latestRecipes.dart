import 'package:dima_project/screens/homeRecipes/recipeCard.dart';
import 'package:dima_project/services/auth.dart';
import 'package:dima_project/services/database.dart';
import 'package:dima_project/shared/loading.dart';
import 'package:flutter/material.dart';

class LatestRecipes extends StatelessWidget {
  //value to manage the authentication particulr sign out phase, would be moved if sign out function is implemented somewhere else
  final AuthService _auth = AuthService();
  final DatabaseService databaseService = new DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.orange[50],
        appBar: AppBar(
          backgroundColor: Colors.orange[400],
          elevation: 0.0,
          title: Text('Home'),
        ),
        body: StreamBuilder(
            stream: databaseService.getLastRecipes(10),
            builder: (context, snapshot) {
              if (snapshot.hasError) return Text('Something went wrong');
              if (snapshot.connectionState == ConnectionState.waiting)
                return Loading();

              return new ListView(
                  padding: const EdgeInsets.all(8),
                  children: snapshot.data.documents
                      .map<Widget>((document) => RecipeCard(
                          databaseService.recipeDataFromSnapshot(document)))
                      .toList());
            }));
  }
}
