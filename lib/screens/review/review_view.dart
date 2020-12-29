import 'package:dima_project/model/recipe_obj.dart';
import 'package:dima_project/model/review_obj.dart';
import 'package:dima_project/screens/review/review_card.dart';
import 'package:dima_project/services/database.dart';
import 'package:flutter/material.dart';

class ReviewView extends StatefulWidget {
  final RecipeData recipeData;
  ReviewView(this.recipeData);
  @override
  ReviewViewState createState() => new ReviewViewState(recipeData);
}

class ReviewViewState extends State<ReviewView> {
  final RecipeData recipeData;
  final List<ReviewData> reviewList = List();
  final DatabaseService databaseService = new DatabaseService();
  final ScrollController scrollController = ScrollController();
  
  ReviewViewState(this.recipeData);

  @override
  void initState() {
    super.initState();
    fetchFirstDocuments();
    scrollController.addListener(() {
      if (scrollController.position.atEdge && scrollController.position.pixels != 0) {
        fetchNextDocuments();
      }
    });
  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return reviewList.isEmpty
      ? SizedBox(height: 5)
      : ListView.builder(
        shrinkWrap: true,
        physics: AlwaysScrollableScrollPhysics(),
        controller: scrollController,
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
        setState(() {
          reviewList.add(databaseService.reviewDataFromSnapshot(element));
        });
      });
    });
  }

  // Fetch next 10 documents
  Future<void> fetchNextDocuments() async {
    databaseService.getNextLastReviews(recipeData.recipeId, 10, reviewList.last.submissionTime).get().then((value) {
      value.docs.forEach((element) {
        setState(() {
          reviewList.add(databaseService.reviewDataFromSnapshot(element));
        });
      });
    });
  }
}
