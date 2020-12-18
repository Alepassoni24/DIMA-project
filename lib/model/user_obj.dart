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
  final bool userRegisteredWithMail;

  UserData(
      {this.uid,
      this.username,
      this.recipeNumber,
      this.rating,
      this.reviewNumber,
      this.profilePhotoURL,
      this.userRegisteredWithMail});

  String getUsername() {
    return username;
  }
}
