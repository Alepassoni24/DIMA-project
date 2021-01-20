import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/model/recipe_obj.dart';
import 'package:dima_project/screens/review/review_card.dart';
import 'package:dima_project/screens/writeRecipe/text_form_fields.dart';
import 'package:dima_project/services/database.dart';
import 'package:dima_project/shared/constants.dart';
import 'package:dima_project/shared/form_validators.dart';
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
  final DatabaseService databaseService =
      new DatabaseService(uid: FirebaseAuth.instance.currentUser.uid);

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
            return YourReviewView(
                databaseService
                    .reviewDataFromSnapshot(snapshot.data.docs.first),
                deleteReview);
          else
            return ReviewForm(recipeData, refreshReview, databaseService);
        });
  }

  void refreshReview() {
    setState(() {});
  }

  // Delete review from Firebase Firestore and update rating
  void deleteReview(ReviewData reviewData) {
    databaseService.updateRecipeRating(recipeData, -reviewData.rating);
    databaseService.updateUserRating(recipeData.authorId, -reviewData.rating);
    databaseService.recipeCollection
        .doc(recipeData.recipeId)
        .collection('review')
        .doc(reviewData.reviewId)
        .delete();
    refreshReview();
  }
}

class YourReviewView extends StatelessWidget {
  final ReviewData reviewData;
  final Function(ReviewData) deleteReview;

  YourReviewView(this.reviewData, this.deleteReview);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          Text("Your review", style: titleStyle),
          Spacer(),
          DeleteIcon(() => deleteReview(reviewData)),
        ]),
        Padding(
          padding: const EdgeInsets.all(5),
          child: ReviewCard(reviewData),
        ),
      ],
    );
  }
}

class ReviewForm extends StatefulWidget {
  final RecipeData recipeData;
  final Function refreshReview;
  final DatabaseService databaseService;

  ReviewForm(this.recipeData, this.refreshReview, this.databaseService);

  ReviewFormState createState() =>
      ReviewFormState(recipeData, refreshReview, databaseService);
}

class ReviewFormState extends State<ReviewForm> {
  final RecipeData recipeData;
  final Function refreshReview;
  final DatabaseService databaseService;
  final _formKey = GlobalKey<FormState>();
  ReviewData _reviewData = ReviewData();
  bool _errorMessage = false;

  ReviewFormState(this.recipeData, this.refreshReview, this.databaseService);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: Text("Rate this recipe", style: titleStyle)),
        Row(
          children: [
            ...getStars(),
          ],
        ),
        if (_errorMessage)
          Container(
              child: Text("Rate this recipe", style: errorStyle),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 5)),
        Form(
          key: _formKey,
          child: TextFormFieldLong(
              "Describe your experience",
              _reviewData.comment,
              setReviewComment,
              DescriptionFieldValidator.validate),
        ),
        FlatButton(
          child: Text("SUBMIT REVIEW", style: titleStyle),
          color: Colors.orange[300],
          minWidth: double.infinity,
          onPressed: submitReview,
        ),
      ],
    );
  }

  List<Widget> getStars() {
    List<Widget> stars = List<Widget>();
    for (int i = 1; i <= 5; i++) {
      stars.add(
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: IconButton(
            onPressed: () => setRating(i),
            iconSize: 35,
            splashRadius: 30,
            icon: getStar(i),
          ),
        ),
      );
    }
    return stars;
  }

  void setRating(int value) {
    setState(() {
      _reviewData.rating = value;
    });
  }

  Icon getStar(int index) {
    if (_reviewData.rating >= index)
      return Icon(Icons.star, color: ratingStarColor);
    return Icon(Icons.star_border, color: ratingStarColor);
  }

  void setReviewComment(String text) =>
      setState(() => _reviewData.comment = text);

  void submitReview() async {
    // Check if rating and comment are inserted
    setState(() => _errorMessage = _reviewData.rating == 0);
    if (_formKey.currentState.validate() && _reviewData.rating > 0) {
      // Submit review
      _reviewData.authorId = FirebaseAuth.instance.currentUser.uid;
      _reviewData.submissionTime = DateTime.now();
      await databaseService.addReview(_reviewData, recipeData.recipeId);

      // Update recipe and author ratings
      databaseService.updateRecipeRating(recipeData, _reviewData.rating);
      databaseService.updateUserRating(recipeData.authorId, _reviewData.rating);

      // Refresh recipe view with the new review
      refreshReview();
    }
  }
}

class DeleteIcon extends StatelessWidget {
  final Function() deleteReview;

  DeleteIcon(this.deleteReview);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.delete, color: errorColor),
      onPressed: () {
        showDeleteDialog(context);
      },
    );
  }

  // Show a popup to ask confirmation of the deletion of the review
  Future<void> showDeleteDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure you want to delete this review?'),
          actions: <Widget>[
            TextButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            TextButton(
                child: Text('Yes'),
                onPressed: () {
                  deleteReview();
                  Navigator.of(context).pop();
                }),
          ],
        );
      },
    );
  }
}
