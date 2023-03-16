import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'database.dart';
import 'other.dart';

class AuthSerivice {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //auth change user stream
  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  //sign in anon
  Future Passwordreset(String email, BuildContext context) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      showToast(context: context, msg: "Reset email sent to $email");
    } catch (e) {
      // showToast(context: context, msg: e.toString());
      showToast(context: context, msg: "Enter valid email");
    }
  }

  Future SignInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign in email
  Future loginWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      User? user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //reg email
  Future registerWithEmail(String email, String password, String name) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      await DatabaseService(uid: user!.uid).updateUserName(name);
      await DatabaseService(uid: user.uid).updateUserEmail(email);
      await DatabaseService(uid: user.uid).updateUserPhone("");

      return user;
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
