import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_mobile_app/consts/firebase_consts.dart';

class FirestoreServices {
  // Get user data
  static Stream<QuerySnapshot> getUser(String uid) {
    return FirebaseFirestore.instance
        .collection(usersCollection)
        .where('id', isEqualTo: uid)
        .snapshots();
  }

  // Get all products data
  static Stream<QuerySnapshot> getProducts() {
    return FirebaseFirestore.instance
        .collection(productsCollection)
        .snapshots();
  }
}
