import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/model/recipe_obj.dart';
import 'package:dima_project/model/user_obj.dart';

class DatabaseService {
  //unique id of the current user
  final String uid;
  DatabaseService({this.uid});
  //collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('user');
  final CollectionReference recipeCollection =
      FirebaseFirestore.instance.collection('recipe');

  Future updateUserData(String username) async {
    return await userCollection.doc(uid).set({
      'username': username,
    });
  }

  //get user stream if needed
  Stream<QuerySnapshot> get users {
    return userCollection.snapshots();
  }

  //get user data from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      username: snapshot.get('username'),
    );
  }

  //get user doc stream
  Stream<UserData> get userData {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  //get recipe stream
  Stream<QuerySnapshot> get recipes {
    return recipeCollection.snapshots();
  }

  //get recipe data from snapshot
  RecipeData recipeDataFromSnapshot(DocumentSnapshot documentSnapshot) {
    return RecipeData(
      recipeId: documentSnapshot.id,
      title: documentSnapshot.data()['title'],
      subtitle: documentSnapshot.data()['subtitle'],
      description: documentSnapshot.data()['description'],
      imageURL: documentSnapshot.data()['imageURL'],
      rating: documentSnapshot.data()['rating'].toString(),
      time: documentSnapshot.data()['time'],
      submissionTime: documentSnapshot.data()['submissionTime'],
    );
  }

  //get stream of last num recipes
  Stream<QuerySnapshot> getLastRecipes(int num) {
    return recipeCollection
        .orderBy('submissionTime', descending: true)
        .limit(num)
        .snapshots();
  }

  //get ingredients stream from a recipe id
  Stream<QuerySnapshot> getRecipeIngredients(String recipeId) {
    return recipeCollection.doc(recipeId).collection('ingredient').snapshots();
  }

  //get ingredients data from snapshot
  IngredientData ingredientsDataFromSnapshot(
      DocumentSnapshot documentSnapshot) {
    return IngredientData(
      id: documentSnapshot.id,
      quantity: documentSnapshot.data()['quantity'].toString(),
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
      id: documentSnapshot.id,
      title: documentSnapshot.data()['title'],
      description: documentSnapshot.data()['description'],
      imageURL: documentSnapshot.data()['imageURL'],
    );
  }
}
