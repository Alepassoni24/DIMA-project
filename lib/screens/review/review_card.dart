import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/model/review_obj.dart';
import 'package:dima_project/model/user_obj.dart';
import 'package:dima_project/services/database.dart';
import 'package:dima_project/shared/constants.dart';
import 'package:dima_project/shared/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReviewCard extends StatelessWidget {
  final ReviewData reviewData;
  final DatabaseService databaseService = new DatabaseService();

  ReviewCard(this.reviewData);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: databaseService.getUser(reviewData.authorId),
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return Text('Something went wrong');
        if (snapshot.connectionState == ConnectionState.waiting)
          return Loading();

        final UserData user = databaseService.userDataFromSnapshot(snapshot.data);
        
        return Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(user.profilePhotoURL),
                ),
                SizedBox(width: 12.5),
                Text(user.username, style: subtitleStyle),
                Spacer(),
                Column(
                  children: [
                    Row(
                      children: [
                        getStar(1),
                        getStar(2),
                        getStar(3),
                        getStar(4),
                        getStar(5),
                      ],
                    ),
                    Text(DateFormat('dd/MM/yyyy').format(reviewData.submissionTime.toDate())),
                  ]
                )
              ],
            ),
            SizedBox(height: 5),
            Padding(
              padding: EdgeInsets.only(left: 2.5, right: 2.5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(reviewData.comment, style: descriptionStyle),
              ),
            ),
            SizedBox(height: 10),
          ]
        );
      }
    );
  }

  Icon getStar(int index) {
    if (reviewData.rating >= index)
      return Icon(Icons.star, color: Colors.orange[500]);
    return Icon(Icons.star_border, color: Colors.orange[500]);
  }
}
