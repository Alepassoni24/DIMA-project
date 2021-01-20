import 'package:dima_project/model/recipe_obj.dart';
import 'package:dima_project/screens/review/review_card.dart';
import 'package:dima_project/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReviewView extends StatefulWidget {
  final RecipeData recipeData;
  final ScrollController scrollController;

  ReviewView(this.recipeData, this.scrollController);

  @override
  ReviewViewState createState() =>
      new ReviewViewState(recipeData, scrollController);
}

class ReviewViewState extends State<ReviewView> {
  final RecipeData recipeData;
  final List<ReviewData> reviewList = List();
  final DatabaseService databaseService = new DatabaseService();
  final ScrollController scrollController;

  ReviewViewState(this.recipeData, this.scrollController);

  @override
  void initState() {
    super.initState();
    fetchFirstDocuments();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
              scrollController.offset &&
          reviewList.isNotEmpty) {
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
    return reviewList.isEmpty
        ? SizedBox(height: 5)
        : ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            padding: const EdgeInsets.all(5),
            itemCount: reviewList.length,
            itemBuilder: (context, index) {
              return ReviewCard(reviewList[index]);
            },
          );
  }

  // Fetch first 10 documents
  Future<void> fetchFirstDocuments() async {
    databaseService.getLastReviews(recipeData.recipeId, 10).get().then((value) {
      value.docs.forEach((element) {
        ReviewData reviewData = databaseService.reviewDataFromSnapshot(element);
        if (reviewData.authorId != FirebaseAuth.instance.currentUser.uid) {
          setState(() {
            reviewList.add(reviewData);
          });
        }
      });
    });
  }

  // Fetch next 10 documents
  Future<void> fetchNextDocuments() async {
    databaseService
        .getNextLastReviews(
            recipeData.recipeId, 10, reviewList.last.submissionTime)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        ReviewData reviewData = databaseService.reviewDataFromSnapshot(element);
        if (reviewData.authorId != FirebaseAuth.instance.currentUser.uid) {
          setState(() {
            reviewList.add(reviewData);
          });
        }
      });
    });
  }
}
