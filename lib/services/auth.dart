import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  //firebase instance for authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //register by email and password

  //sign in by email and password
  Future signInWithEmailAndPassword() async {
    try {
      UserCredential result =
          await _auth.signInWithEmailAndPassword(email: null, password: null);
      User user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out

}
