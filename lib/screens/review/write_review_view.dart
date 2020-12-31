import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/model/recipe_obj.dart';
import 'package:dima_project/model/review_obj.dart';
import 'package:dima_project/screens/review/review_card.dart';
import 'package:dima_project/services/database.dart';
import 'package:dima_project/shared/constants.dart';
import 'package:dima_project/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WriteReviewView extends StatefulWidget {
  final RecipeData recipeData;

  WriteReviewView(this.recipeData);

  @override
  WriteReviewViewState createState() => new WriteReviewViewState(recipeData);
}

class WriteReviewViewState extends State<WriteReviewView> {
  final RecipeData recipeData;
  final DatabaseService databaseService = new DatabaseService();

  WriteReviewViewState(this.recipeData);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: databaseService.getReviewByAuthor(
            recipeData.recipeId, FirebaseAuth.instance.currentUser.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text('Something went wrong');
          if (snapshot.connectionState == ConnectionState.waiting)
            return Loading();

          if (snapshot.data.docs.isNotEmpty)
            return YourReviewView(databaseService
                .reviewDataFromSnapshot(snapshot.data.docs.first));
          else
            return ReviewForm();
        });
  }
}

class YourReviewView extends StatelessWidget {
  final ReviewData reviewData;

  YourReviewView(this.reviewData);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: Text("Your review", style: titleStyle)),
        Padding(
          padding: const EdgeInsets.all(5),
          child: ReviewCard(reviewData),
        ),
      ],
    );
  }
}

class ReviewForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(); // TODO: Add actual behavior of review form
  }
}
