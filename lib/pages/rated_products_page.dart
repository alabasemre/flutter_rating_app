import 'package:rating_app/components/product_card.dart';
import 'package:rating_app/firebase/firestore_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RatedProductsPage extends StatefulWidget {
  const RatedProductsPage({Key? key}) : super(key: key);

  @override
  State<RatedProductsPage> createState() => _RatedProductsPageState();
}

class _RatedProductsPageState extends State<RatedProductsPage> {
  late List<dynamic> _products;
  late Map<String, dynamic> _userRated;

  bool _isLoading = true;

  _RatedProductsPageState() {
    if (FirebaseAuth.instance.currentUser == null) {
      Navigator.of(context).pushReplacementNamed("/");
    }
    getProducts();
  }

  Future<void> getProducts() async {
    var userRated = await FireStoreMethods()
        .getUserRated(FirebaseAuth.instance.currentUser!.uid);

    var products = await FireStoreMethods().getUserRatedProducts(
        FirebaseAuth.instance.currentUser!.uid, userRated);

    setState(() {
      _isLoading = false;
      _products = products;
      _userRated = userRated;
    });
  }

  void updateList() {
    getProducts();
  }

  List<Widget> productList() {
    List<Widget> products = [];

    for (var data in _products) {
      int rate = 0;
      String productId = data["productId"];
      if (_userRated[productId] != null) {
        rate = _userRated[productId];
      }

      products.add(ProductCard(
          productId: productId,
          productName: data["productName"],
          productReviewCount: data["productReviewCount"],
          productScore: data["productScore"],
          productDetail: data["productDetail"],
          productImage: data["productImage"],
          rated: rate,
          updateList: getProducts));
    }
    return products;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView(
                  children: productList(),
                )),
    );
  }
}
