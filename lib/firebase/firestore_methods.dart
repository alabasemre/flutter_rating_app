import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> updateProfile(
    String profilePicUrl,
    String uid,
  ) async {
    bool res = false;
    try {
      await _firestore
          .collection("users")
          .doc(uid)
          .update({"profilePicUrl": profilePicUrl});
      res = true;
    } catch (e) {
      res = false;
    }

    return res;
  }
}
