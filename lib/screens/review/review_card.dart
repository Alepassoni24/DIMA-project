import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/model/recipe_obj.dart';
import 'package:dima_project/model/user_obj.dart';
import 'package:dima_project/services/database.dart';
import 'package:dima_project/shared/constants.dart';
import 'package:dima_project/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// A card that show the rating and comment of a user under a RecipeView
// The ReviewData must be obtained from a query to the database
class ReviewCard extends StatelessWidget {
  final ReviewData reviewData;
  final DatabaseService databaseService = new DatabaseService();

  ReviewCard(this.reviewData);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: databaseService.getUser(reviewData.authorId),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text('Something went wrong');
          if (snapshot.connectionState == ConnectionState.waiting)
            return Loading();

          final UserData user =
              databaseService.userDataFromSnapshot(snapshot.data);

          return Column(children: [
            Row(
              children: [
                // Profile picture of the author of the review, if it has one
                user.profilePhotoURL != null
                    ? CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(user.profilePhotoURL),
                      )
                    : Icon(
                        Icons.account_circle_outlined,
                        size: 50,
                        color: Colors.grey[600],
                      ),
                SizedBox(width: 12.5),
                // Name of the author of the review
                Text(user.username, style: subtitleStyle),
                Spacer(),
                Column(children: [
                  // Rating of the review
                  Row(
                    children: [
                      getStar(1),
                      getStar(2),
                      getStar(3),
                      getStar(4),
                      getStar(5),
                    ],
                  ),
                  // Date of the review
                  Text(DateFormat('dd/MM/yyyy')
                      .format(reviewData.submissionTime)),
                ])
              ],
            ),
            SizedBox(height: 5),
            // Comment of the review
            Padding(
              padding: EdgeInsets.only(left: 2.5, right: 2.5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(reviewData.comment, style: descriptionStyle),
              ),
            ),
            SizedBox(height: 10),
          ]);
        });
  }

  // Get a correctly colored star based on the rating
  Icon getStar(int index) {
    if (reviewData.rating >= index)
      return Icon(Icons.star, color: ratingStarColor);
    return Icon(Icons.star_border, color: ratingStarColor);
  }
}
