import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartup/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class Auth {
  static Future<User?> createAccountWithEmail(
    String userName,
    String email,
    String password,
  ) async {
    User? user;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      user = auth.currentUser;
      bool? isNewUser = userCredential.additionalUserInfo?.isNewUser;
      if (isNewUser!) {
        UserModel newUserData = UserModel(
          displayName: userName,
          email: email,
          level: 0,
        );
        try {
          FirebaseFirestore.instance.collection('users').doc(email).set(
                newUserData.toMap(),
              );
        } catch (e) {
          Fluttertoast.showToast(
            msg: e.toString(),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(
          msg: 'The password provided is too weak',
        );
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
          msg: 'The account already exists for that email',
        );
      } else {
        Fluttertoast.showToast(
          msg: e.code.toString(),
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
    return user;
  }

  static Future<User?> loginWithEmail(
    String email,
    String password,
  ) async {
    User? user;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(
          msg: 'No user found for that email',
        );
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(
          msg: 'Wrong password provided',
        );
      } else {
        Fluttertoast.showToast(
          msg: e.code.toString(),
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
    return user;
  }

  static Future<User?> signInWithGoogle() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    bool? isNewUser;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;

        isNewUser = userCredential.additionalUserInfo?.isNewUser;
        if (isNewUser!) {
          UserModel newUserData = UserModel(
            uid: user!.uid,
            displayName: user.displayName.toString(),
            email: user.email.toString(),
            photoURL: user.photoURL.toString(),
          );

          await FirebaseFirestore.instance
              .collection("users")
              .doc(userCredential.user!.email)
              .set(newUserData.toMap());
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          Fluttertoast.showToast(
            msg: 'The account already exists with a different credential',
          );
        } else if (e.code == 'invalid-credential') {
          Fluttertoast.showToast(
            msg: 'Error occurred while accessing credentials. Try again.',
          );
        }
      } catch (e) {
        Fluttertoast.showToast(
          msg: 'Error occurred using Google Sign In. Try again.',
        );
      }
    }
    return user;
  }

  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error signing out. Try again.',
      );
    }
  }
}
