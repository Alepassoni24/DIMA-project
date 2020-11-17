import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/model/user_obj.dart';

class DatabaseService {
  //unique id of the current user
  final String uid;
  DatabaseService({this.uid});
  //collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('user');

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
}
