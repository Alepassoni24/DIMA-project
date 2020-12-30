import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewData {
  String reviewId;
  String authorId;
  String comment;
  int rating;
  Timestamp submissionTime;

  ReviewData({
    this.reviewId,
    this.authorId,
    this.comment,
    this.rating,
    this.submissionTime,
  });
}
