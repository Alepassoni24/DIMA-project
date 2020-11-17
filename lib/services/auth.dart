import 'package:dima_project/model/user_obj.dart';
import 'package:dima_project/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  //firebase instance for authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user object based on firebase User
  UserObj _userFromFirebaseUser(User user) {
    return user != null ? UserObj(uid: user.uid) : null;
  }

  //authentication changes on user stream
  Stream<UserObj> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
    //not working with the new function, probably map function must be explicit implemented
    //TODO check if we can manage it
    //return _auth.authStateChanges.map(_userFromFirebaseUser);
  }

  //register by email and password
  Future registerWithEmailAndPassword(
      String email, String password, String username) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      //create a new document for the user with th uid
      await DatabaseService(uid: user.uid).updateUserData(username);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign in by email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
