import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rating_app/firebase/storage_methods.dart';

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

  Future<Map<String, Object>> addProduct(
      String productName, String productDetail, File file) async {
    var res = {"error": false, "errorMessage": "", "success": false};
    try {
      final isExist = await _firestore
          .collection("products")
          .where("productName", isEqualTo: productName)
          .get();

      if (isExist.size != 0) {
        res["error"] = true;
        res["errorMessage"] = "Ürün zaten veritabanında var.";
        return res;
      }

      String url =
          await StorageMethods().uploadProductImageToStorage("products", file);

      _firestore.collection("products").add({
        "productName": productName,
        "productDetail": productDetail,
        "review": 0,
        "score": 0,
        "rates": {},
        "url": url,
        "imageName": file.hashCode.toString()
      });
      res["success"] = true;
    } catch (e) {
      res["error"] = true;
      res["errorMessage"] = e.toString();
    }
    return res;
  }

  Future<Map<String, Object>> updateProduct(
      String productId,
      String productName,
      String productDetail,
      File? file,
      String? imageName) async {
    var res = {
      "error": false,
      "errorMessage": "",
      "success": false,
      "imgUrl": "",
      "imgName": "",
    };

    try {
      if (file != null && imageName != null) {
        String fileHash = file.hashCode.toString();
        String url = await StorageMethods()
            .uploadProductImageToStorage("products", file);
        _firestore.collection("products").doc(productId).update({
          "productName": productName,
          "productDetail": productDetail,
          "url": url,
          "imageName": fileHash
        });
        await StorageMethods().deleteImageFromStorage("products", imageName);
        res["imgUrl"] = url;
        res["imgName"] = fileHash;
      } else {
        _firestore.collection("products").doc(productId).update({
          "productName": productName,
          "productDetail": productDetail,
        });
      }

      res["success"] = true;
    } catch (e) {
      res["error"] = true;
      res["errorMessage"] = e.toString();
    }
    return res;
  }

  Future<Map<String, Object>> deleteProduct(
      String productId, String imageName) async {
    var res = {"error": false, "errorMessage": "", "success": false};
    try {
      await _firestore.collection("products").doc(productId).delete();
      await StorageMethods().deleteImageFromStorage("products", imageName);

      res["success"] = true;
    } catch (e) {
      res["error"] = true;
      res["errorMessage"] = e.toString();
    }
    return res;
  }

  Future<dynamic> getAllProducts() async {
    var snapshot = await _firestore.collection("products").get();
    var products = [];

    for (var docSnap in snapshot.docs) {
      var data = docSnap.data();
      int reviewCount = data["review"];
      double score = 0;
      if (reviewCount > 0) {
        score = data["score"] / reviewCount;
      }

      products.add({
        "productId": docSnap.id,
        "productName": data["productName"],
        "productImage": data["url"],
        "productReviewCount": reviewCount,
        "productDetail": data["productDetail"],
        "productScore": score,
        "productImageName": data["imageName"],
        "rates": data["rates"]
      });
    }

    return products;
  }
}
