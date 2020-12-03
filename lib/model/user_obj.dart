class UserObj {
  final String uid;

  UserObj({this.uid});

  String getUid() {
    return uid;
  }
}

class UserData {
  final String uid;
  final String username;
  int recipeNumber;
  int reviewNumber;
  double rating;

  //UserData({this.uid, this.username});

  UserData(
      {this.uid,
      this.username,
      this.recipeNumber,
      this.rating,
      this.reviewNumber});

  String getUsername() {
    return username;
  }
}
