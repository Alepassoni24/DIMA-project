import 'package:dima_project/model/user_obj.dart';
import 'package:dima_project/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  //firebase instance for authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final fb = FacebookLogin();

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
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  //sign in with google
  Future signInWithGoogle() async {
    await Firebase.initializeApp(); //TODO: verify if it is necessary

    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    UserCredential result = await _auth.signInWithCredential(credential);
    User user = result.user;

    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);

      return _userFromFirebaseUser(user);
    }

    return null;
  }

  //sign in with facebook
  Future signInWithFacebook() async {
    final fbResult = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);

    switch (fbResult.status) {
      case FacebookLoginStatus.Success:
        //get the token
        final FacebookAccessToken fbToken = fbResult.accessToken;
        //convert to auth credential
        final AuthCredential credential =
            FacebookAuthProvider.credential(fbToken.token);
        //user credential to sign in with firebase
        UserCredential result = await _auth.signInWithCredential(credential);
        User user = result.user;
        return _userFromFirebaseUser(user);
        break;
      case FacebookLoginStatus.Cancel:
        print('the user canceled the login');
        break;
      case FacebookLoginStatus.Error:
        print('there was an error');
        break;
    }

    return null;
  }

  //sign out by email and password
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out with google
  Future signOutGoogle() async {
    try {
      return await googleSignIn.signOut();
    } on Exception catch (e) {
      print(e.toString());
      return null;
    }
  }
}
