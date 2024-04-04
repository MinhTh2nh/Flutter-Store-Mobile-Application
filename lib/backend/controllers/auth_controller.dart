import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:food_mobile_app/consts/consts.dart';
class AuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? currentUser = FirebaseAuth.instance.currentUser;

  Future<UserCredential?> loginMethod({String? email, String? password, BuildContext? context}) async {
    UserCredential? userCredential;
    try {
      userCredential = await auth.signInWithEmailAndPassword(
        email: email!,
        password: password!,
      );
    } on FirebaseAuthException catch (e) {
      VxToast.show(context!, msg: e.toString());
    }
    return userCredential;
  }

  Future<void> storeUserData({String? name, String? email, String? password}) async {
    if (currentUser != null && name != null && email != null && password != null) {
      DocumentReference store =
      firestore.collection(usersCollection).doc(currentUser!.uid);
      await store.set({
        'name': name,
        'email': email,
        'password': password,
        'imageUrl': ''
      });
    } else {
      print("Error storing user data: One or more parameters are null.");
    }
  }

  Future<UserCredential?> signupMethod({String? email, String? password, String? name, BuildContext? context}) async {
    UserCredential? userCredential;
    print("Name in controller: ${name}");
    print("Email in controller: ${email}");
    print("Password in controller: ${password}");
    try {
      // Sign up the user with Firebase Authentication
      userCredential = await auth.createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      // If signup successful, store user data in Firestore
      if (userCredential != null) {
        await storeUserData(
          name: name,
          email: email,
          password: password,
        );
      } else {
        // Handle case where userCredential is null
        print("UserCredential is null after sign up.");
      }
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuthException
      VxToast.show(context!, msg: e.toString());
    } catch (e) {
      // Handle other exceptions
      print("Error during signup: $e");
    }

    return userCredential;
  }


  Future<void> signoutMethod(BuildContext context) async {
    try {
      await auth.signOut();
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }
}
