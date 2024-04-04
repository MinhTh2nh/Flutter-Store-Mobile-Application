import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:food_mobile_app/consts/consts.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? currentUser = FirebaseAuth.instance.currentUser;

  // Function to hash the password using SHA-256
  String _hashPassword(String password) {
    // Convert password string to bytes
    Uint8List bytes = utf8.encode(password);
    // Hash bytes using SHA-256 algorithm
    Digest digest = sha256.convert(bytes);
    // Convert digest to hexadecimal string
    String hashedPassword = digest.toString();
    return hashedPassword;
  }

  Future<UserCredential?> loginMethod(
      {String? email, String? password, BuildContext? context}) async {
    UserCredential? userCredential;
    try {
      userCredential = await auth.signInWithEmailAndPassword(
        email: email!,
        password: password!,
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context!).showSnackBar(
        SnackBar(
          content: Text(e.message!),
        ),
      );
    }
    return userCredential;
  }

  Future<void> storeUserData(
      {String? name, String? email, String? password}) async {
    if (name != null && email != null && password != null) {
      DocumentReference store = firestore.collection(usersCollection).doc();
      await store.set(
          {'name': name, 'email': email, 'password': password, 'imageUrl': ''});
    } else {
      throw Exception(
          "One or more parameters are null when storing user data.");
    }
  }

  Future<UserCredential?> signupMethod(
      {String? email,
        String? password,
        String? name,
        BuildContext? context}) async {
    UserCredential? userCredential;
    try {
      // Sign up the user with Firebase Authentication
      userCredential = await auth.createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      // If signup successful, store user data in Firestore
      if (userCredential != null) {
        // Hash the password using SHA-256
        String hashedPassword = _hashPassword(password!);
        // Store user data in Firestore with hashed password
        await storeUserData(
          name: name,
          email: email,
          password: hashedPassword,
        );
      }
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuthException
      if (e.code == 'email-already-in-use') {
        // Inform the user that the email address is already in use
        ScaffoldMessenger.of(context!).showSnackBar(
          const SnackBar(
            content: Text('Email address is already in use. Please use a different email address.'),
            behavior: SnackBarBehavior.floating, // Set behavior to floating
          ),
        );
      } else {
        // Handle other FirebaseAuthException errors
        ScaffoldMessenger.of(context!).showSnackBar(
          SnackBar(
            content: Text(e.message!),
            behavior: SnackBarBehavior.floating, // Set behavior to floating
          ),
        );
      }
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          behavior: SnackBarBehavior.floating, // Set behavior to floating
        ),
      );
    }
  }
}
