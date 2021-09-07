import 'package:firebase_auth/firebase_auth.dart';
import 'package:order_app/api/firebase_api.dart';
import 'package:order_app/models/user_model.dart';

class Auth {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  UID _userFromFirebaseUser(User user) {
    return user != null ? UID(uid: user.uid) : null;
  }

  Future singInWithEmailAndPass(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future registerWithEmailAndPass(String email, String password, String username) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      UserModel userData = UserModel(uid: user.uid, username: username, email: email);
      await FirebaseApi.createUserData(userData);
      return _userFromFirebaseUser(user);
     } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (error) {
      print(error.toString());

      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
