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
      title: documentSnapshot['title'],
      subtitle: documentSnapshot['subtitle'],
      description: documentSnapshot['description'],
      imageURL: documentSnapshot['imageURL'],
      rating: documentSnapshot['rating'],
      timeInMinutes: documentSnapshot['timeInMinutes'],
      submissionTime: documentSnapshot['submissionTime'],
    );
  }

  //get recipe doc stream
  Stream<RecipeData> recipeData(String recipeId) {
    return userCollection.doc(recipeId).snapshots().map(recipeDataFromSnapshot);
  }

  //get stream of last num recipes
  Stream<QuerySnapshot> getLastRecipes(int num) {
    return recipeCollection.orderBy('submissionTime', descending: true).limit(num).snapshots();
  }
}
