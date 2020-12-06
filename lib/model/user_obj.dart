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
  String profilePhotoURL;
  int recipeNumber;
  int reviewNumber;
  double rating;

  //UserData({this.uid, this.username});

  UserData(
      {this.uid,
      this.username,
      this.recipeNumber,
      this.rating,
      this.reviewNumber,
      this.profilePhotoURL});

  String getUsername() {
    return username;
  }
}
