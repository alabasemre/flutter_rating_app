import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential> signUpUser(
      String email, String password, String username) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    await _firestore.collection("users").doc(userCredential.user!.uid).set({
      "username": username,
      "email": email,
      "role": 'user',
      'profilePicUrl': '',
      "rated": {}
    });

    return userCredential;
  }

  Future<UserCredential> signInUser(String email, String password) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    return userCredential;
  }

  Future<void> signOutUser() async {
    await _auth.signOut();
  }

  Future<DocumentSnapshot> getCurrentUser() async {
    var snapshot = await _firestore
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    return snapshot;
  }
}
