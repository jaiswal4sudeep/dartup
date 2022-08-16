// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartup/c_dashboard_screen/home_screen.dart';
import 'package:dartup/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class AuthServices extends StateNotifier<void> {
  AuthServices() : super(null);

  Future<User?> createAccountWithEmail(
    String userName,
    String email,
    String password,
    BuildContext context,
  ) async {
    User? user;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      user = auth.currentUser;
      if (user != null) {
        saveNewUserDetails(
          userName,
          email,
        );
        if (!mounted) return null;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>  HomeScreen(
              user: user!,
            ),
          ),
        );
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

  Future<User?> loginWithEmail(
    String email,
    String password,
    BuildContext context,
  ) async {
    User? user;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      if (user != null) {
        if (!mounted) return null;

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>  HomeScreen(user: user!,),
          ),
        );
      }
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

  continueWithGoogle(
    BuildContext context,
  ) {
    // Navigator.of(context).pushReplacement(
    //   MaterialPageRoute(
    //     builder: (context) => const HomeScreen(),
    //   ),
    // );
  }

  Future<void> logOut(
    BuildContext context,
  ) async {
    try {
      await auth.signOut();
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error signing out. Try again.',
      );
    }
  }

  Future<void> saveNewUserDetails(
    String userName,
    String userEmail,
  ) async {
    UserModel newUserData = UserModel(
      displayName: userName,
      email: userEmail,
      level: 0,
    );
    try {
      FirebaseFirestore.instance.collection('users').doc(userEmail).set(
            newUserData.toMap(),
          );
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }
}

final authProvider = StateNotifierProvider<AuthServices, void>((_) {
  return AuthServices();
});
