class UserObj {
  final String uid;

  UserObj({this.uid});

  String getUid() {
    return uid;
  }
}

class UserData {
  //user uid
  final String uid;
  //user username
  final String username;
  //URL of user profile picture
  String profilePhotoURL;
  //number of recipes uploaded by the user
  int recipeNumber;
  //number of reviews received by the user
  int reviewNumber;
  //avarage of user recipe rating
  double rating;
  //list of recipes which the user want to store
  List<String> savedRecipes;
  //boolean to represent channel of registration
  final bool userRegisteredWithMail;

  UserData(
      {this.uid,
      this.username,
      this.recipeNumber,
      this.rating,
      this.reviewNumber,
      this.profilePhotoURL,
      this.savedRecipes,
      this.userRegisteredWithMail});

  String getUsername() {
    return username;
  }
}
