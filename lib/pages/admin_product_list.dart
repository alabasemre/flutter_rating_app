import 'package:rating_app/components/admin_product_card.dart';
import 'package:rating_app/firebase/firestore_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminProductList extends StatefulWidget {
  const AdminProductList({Key? key}) : super(key: key);

  @override
  State<AdminProductList> createState() => _AdminProductListState();
}

class _AdminProductListState extends State<AdminProductList> {
  late List<dynamic> _products;
  bool _isLoading = true;

  _AdminProductListState() {
    if (FirebaseAuth.instance.currentUser == null) {
      Navigator.of(context).pushReplacementNamed("/");
    }
    getProducts();
  }

  Future<void> getProducts() async {
    var products = await FireStoreMethods().getAllProducts();
    setState(() {
      _isLoading = false;
      _products = products;
    });
  }

  List<Widget> productList() {
    List<Widget> products = [];

    for (var data in _products) {
      products.add(AdminProductCard(
          productId: data["productId"],
          productName: data["productName"],
          productImage: data["productImage"],
          productReviewCount: data["productReviewCount"],
          productScore: data["productScore"],
          productImageName: data["productImageName"],
          productDetail: data["productDetail"],
          deleteProductFromParent: deleteProduct,
          updateProductFromParent: updateProduct));
    }
    return products;
  }

  void deleteProduct(String productId) {
    setState(() {
      _products = _products
          .where((element) => element["productId"] != productId)
          .toList();
    });
  }

  void updateProduct(String productId, String productName, String productDetail,
      String imgUrl, String imgName) {
    setState(() {
      _products = _products.map((e) {
        if (e["productId"] == productId) {
          return {
            "productId": productId,
            "productName": productName,
            "productImage": imgUrl,
            "productImageName": imgName,
            "productDetail": productDetail,
            "productReviewCount": e["productReviewCount"],
            "productScore": e["productScore"]
          };
        } else {
          return e;
        }
      }).toList();
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListView(
              children: productList(),
            ),
          );
  }
}
