import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/model/recipe_obj.dart';
import 'package:dima_project/model/review_obj.dart';
import 'package:dima_project/model/user_obj.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  //unique id of the current user
  final String uid;
  DatabaseService({this.uid});
  //collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('user');
  final CollectionReference recipeCollection =
      FirebaseFirestore.instance.collection('recipe');

  Future updateUserData(String username, String profilePhotoURL) async {
    return await userCollection.doc(uid).update({
      'username': username,
      'profilePhotoURL': profilePhotoURL,
    });
  }

  Future insertUserData(
      String username,
      String recipeNum,
      String rating,
      String reviewNum,
      String profilePhotoURL,
      bool userRegisteredWithMail) async {
    return await userCollection.doc(uid).set({
      'username': username,
      'recipeNumber': recipeNum,
      'rating': rating,
      'reviewNumber': reviewNum,
      'profilePhotoURL': profilePhotoURL,
      'userRegisteredWithMail': userRegisteredWithMail,
    });
  }

  //get user stream if needed
  Stream<QuerySnapshot> get users {
    return userCollection.snapshots();
  }

  //get user data from snapshot
  UserData userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: snapshot.id,
      username: snapshot.get('username'),
      recipeNumber: int.parse(snapshot.get('recipeNumber')),
      rating: double.parse(snapshot.get('rating')),
      reviewNumber: int.parse(snapshot.get('reviewNumber')),
      profilePhotoURL: snapshot.get('profilePhotoURL'),
      userRegisteredWithMail: snapshot.get('userRegisteredWithMail'),
    );
  }

  //get user doc stream
  Stream<UserData> get userData {
    return userCollection.doc(uid).snapshots().map(userDataFromSnapshot);
  }

  //get user stream from a user id
  Stream<DocumentSnapshot> getUser(String userId) {
    return userCollection.doc(userId).snapshots();
  }

  //get recipe stream
  Stream<QuerySnapshot> get recipes {
    return recipeCollection.snapshots();
  }

  //get recipe data from snapshot
  RecipeData recipeDataFromSnapshot(DocumentSnapshot documentSnapshot) {
    return RecipeData(
      recipeId: documentSnapshot.id,
      authorId: documentSnapshot.data()['author'],
      title: documentSnapshot.data()['title'],
      subtitle: documentSnapshot.data()['subtitle'],
      description: documentSnapshot.data()['description'],
      imageURL: documentSnapshot.data()['imageURL'],
      rating: documentSnapshot.data()['rating'].toDouble(),
      time: documentSnapshot.data()['time'],
      servings: documentSnapshot.data()['servings'],
      submissionTime: documentSnapshot.data()['submissionTime'],
      difficulty: documentSnapshot.data()['difficulty'],
      isVegan: documentSnapshot.data()['isVegan'],
      isVegetarian: documentSnapshot.data()['isVegetarian'],
      isGlutenFree: documentSnapshot.data()['isGlutenFree'],
      isLactoseFree: documentSnapshot.data()['isLactoseFree'],
      reviewNumber: documentSnapshot.data()['reviewNumber'],
    );
  }

  //get query of last num recipes
  Query getLastRecipes(int num) {
    return recipeCollection
        .orderBy('submissionTime', descending: true)
        .limit(num);
  }

  //get query of last num recipes after submissionTime
  Query getNextLastRecipes(int num, Timestamp submissionTime) {
    return recipeCollection
        .orderBy('submissionTime', descending: true)
        .where('submissionTime', isLessThan: submissionTime)
        .limit(num);
  }

  //get ingredients stream from a recipe id
  Stream<QuerySnapshot> getRecipeIngredients(String recipeId) {
    return recipeCollection.doc(recipeId).collection('ingredient').snapshots();
  }

  //get ingredients data from snapshot
  IngredientData ingredientsDataFromSnapshot(
      DocumentSnapshot documentSnapshot) {
    return IngredientData(
      id: int.parse(documentSnapshot.id),
      quantity: documentSnapshot.data()['quantity'].toDouble(),
      unit: documentSnapshot.data()['unit'],
      name: documentSnapshot.data()['name'],
    );
  }

  //get steps stream from a recipe id
  Stream<QuerySnapshot> getRecipeSteps(String recipeId) {
    return recipeCollection.doc(recipeId).collection('step').snapshots();
  }

  //get steps data from snapshot
  StepData stepsDataFromSnapshot(DocumentSnapshot documentSnapshot) {
    return StepData(
      id: int.parse(documentSnapshot.id),
      title: documentSnapshot.data()['title'],
      description: documentSnapshot.data()['description'],
      imageURL: documentSnapshot.data()['imageURL'],
    );
  }

  //get stream of last num recipes
  Stream<QuerySnapshot> get getUserRecipes {
    return recipeCollection
        .where('author', isEqualTo: uid)
        .orderBy('submissionTime', descending: true)
        .snapshots();
  }

  //get review stream from a recipe id
  Stream<QuerySnapshot> getReviews(String recipeId) {
    return recipeCollection.doc(recipeId).collection('review').snapshots();
  }

  //get steps data from snapshot
  ReviewData reviewDataFromSnapshot(DocumentSnapshot documentSnapshot) {
    return ReviewData(
      reviewId: documentSnapshot.id,
      authorId: documentSnapshot.data()['author'],
      comment: documentSnapshot.data()['comment'],
      rating: documentSnapshot.data()['rating'],
      submissionTime: documentSnapshot.data()['submissionTime'],
    );
  }

  //get query of last num reviews
  Query getLastReviews(String recipeId, int num) {
    return recipeCollection
        .doc(recipeId)
        .collection('review')
        .orderBy('submissionTime', descending: true)
        .limit(num);
  }

  //get query of last num reviews after submissionTime
  Query getNextLastReviews(String recipeId, int num, Timestamp submissionTime) {
    return recipeCollection
        .doc(recipeId)
        .collection('review')
        .orderBy('submissionTime', descending: true)
        .where('submissionTime', isLessThan: submissionTime)
        .limit(num);
  }

  Query getFilteredRecipe(String order, RangeValues timing, String course,
      bool isVegan, bool isVegetarian, bool isGlutenFree, bool isLactoseFree) {
    Query query = recipeCollection;
    if (order == "submissionTime")
      query =
          query.where('submissionTime', isLessThanOrEqualTo: Timestamp.now());
    if (order == "rating")
      query = query.where('rating', isLessThanOrEqualTo: 5);
    //.where('time', whereIn: [timing.start, timing.end]);
    if (course != "Any") query = query.where('category', isEqualTo: course);
    if (isVegan) query = query.where('isVegan', isEqualTo: true);
    if (isVegetarian) query = query.where('isVegetarian', isEqualTo: true);
    if (isGlutenFree) query = query.where('isGlutenFree', isEqualTo: true);
    if (isLactoseFree) query = query.where('isLactoseFree', isEqualTo: true);
    return query.orderBy(order, descending: true).limit(10);
  }
}
