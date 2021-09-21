import 'package:firebase_auth/firebase_auth.dart';
import 'package:tracker360/models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<FirebaseUser> getUser() async {
    return await _auth.currentUser();
  }

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // sign in with email and password
  Future signInEmailAndPass(String email, String password) async {
    try {
      AuthResult authResult = await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password);
      print(authResult);
      print("//////");
      FirebaseUser firebaseUser = authResult.user;
      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      print(e);
      return null;
    }
  }

//auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged
        .map((FirebaseUser user) => _userFromFirebaseUser(user));
  }

// register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      // registering user..
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password);
      FirebaseUser firebaseUser = authResult.user;
      firebaseUser.sendEmailVerification();
      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signout() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
