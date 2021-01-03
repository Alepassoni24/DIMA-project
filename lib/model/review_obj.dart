class ReviewData {
  String reviewId;
  String authorId;
  String comment;
  int rating;
  DateTime submissionTime;

  ReviewData({
    this.reviewId,
    this.authorId,
    this.comment,
    this.rating = 0,
    this.submissionTime,
  });
}
