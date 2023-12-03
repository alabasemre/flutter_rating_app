import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageMethods {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // adding image to firebase storage
  Future<String> uploadImageToStorage(
      String childName, File file, String uid) async {
    // creating location to our firebase storage

    Reference ref = _storage.ref().child(childName).child(uid);

    // putting in uint8list format -> Upload task like a future but not future
    UploadTask uploadTask = ref.putFile(file);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> uploadProductImageToStorage(
      String childName, File file) async {
    // creating location to our firebase storage

    Reference ref =
        _storage.ref().child(childName).child(file.hashCode.toString());

    // putting in uint8list format -> Upload task like a future but not future
    UploadTask uploadTask = ref.putFile(file);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> deleteImageFromStorage(String childName, String uid) async {
    Reference ref = _storage.ref().child(childName).child(uid);
    await ref.delete();
  }
}
