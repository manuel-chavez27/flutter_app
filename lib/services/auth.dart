import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/date_symbols.dart';
import 'package:my_app/models/user.dart';
import 'package:my_app/services/database.dart';
import 'package:package_info/package_info.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create user object based on FirebaseUser
  TheUser? _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? TheUser(uid: user.uid, isEmailVerified: user.isEmailVerified) : null;
  }

  // Auth change user stream
  Stream<TheUser?> get user {
    return _auth.onAuthStateChanged
      //.map((TheUser? user) => _userFromFirebaseUser(user!));
      .map(_userFromFirebaseUser);
  }

  // Sign in anonymously
  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    }catch(e) {
      print(e.toString());
      return null;
    }
  }

  // Sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // Register with email & password
  Future registerWithEmailAndPassword(String email, String password) async {
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      await user.sendEmailVerification();

      // Create a new document fo the user with the uid
      await DatabaseService(uid: user.uid).updateUserData('customer');


      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  

  // Sign out
  Future signOut() async {
    try{
      return await _auth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

}