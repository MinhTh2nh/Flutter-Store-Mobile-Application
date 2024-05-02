import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:food_mobile_app/consts/consts.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Text controllers
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  // Function to hash the password using SHA-256
  String _hashPassword(String password) {
    Uint8List bytes = utf8.encode(password);
    Digest digest = sha256.convert(bytes);
    return digest.toString();
  }

  // General function to show SnackBars for error messages
  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

// loginMethod accepting a named parameter `context`
  Future<UserCredential?> loginMethod({required String email, required String password, BuildContext? context}) async {
    String hashedPassword = _hashPassword(password);

    try {
      return FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: hashedPassword,
      );
    } on FirebaseAuthException catch (e) {
      if (context != null) {
        String errorMessage = "Login failed!";
        if (e.code == 'user-not-found') {
          errorMessage = "No user found for that email.";
        } else if (e.code == 'wrong-password') {
          errorMessage = "Wrong password provided.";
        }
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)));
      }
      return null;
    }
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
      {
        String? email,
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
      // Hash the password using SHA-256
      String hashedPassword = _hashPassword(password);
      // Store user data in Firestore with hashed password
      await storeUserData(
        name: name,
        email: email,
        password: hashedPassword,
      );
        } on FirebaseAuthException catch (e) {
      _showErrorSnackBar(context!, e.message ?? "Signup failed!");
      return null;
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
