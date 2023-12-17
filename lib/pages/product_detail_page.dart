// ignore_for_file: use_build_context_synchronously
import 'package:rating_app/firebase/auth_methods.dart';
import 'package:rating_app/firebase/firestore_methods.dart';
import 'package:rating_app/styles/app_colors.dart';
import 'package:rating_app/widgets/rate_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProductDetail extends StatefulWidget {
  final dynamic arguments;
  const ProductDetail({super.key, required this.arguments});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  String _productId = "";
  String _productName = "";
  String _productImage = "";
  int _productReviewCount = 0;
  double _productScore = 0;
  String _productDetail = "";
  int _rated = 0;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getProductDetails());
  }

  void update() {
    getProductDetails();
  }

  void getProductDetails() async {
    setState(() {
      _isLoading = true;
    });

    var product = await FireStoreMethods().getSingle(
        widget.arguments['productId'].toString(),
        FirebaseAuth.instance.currentUser!.uid);

    setState(() {
      _productId = widget.arguments['productId'].toString();
      _productName = product["productName"];
      _productImage = product["productImage"];
      _productReviewCount = product["productReviewCount"];
      _productScore = product["productScore"];
      _productDetail = product["productDetail"];
      _rated = product["rated"];
    });

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> rateProduct(int rate) async {
    await FireStoreMethods()
        .rateProduct(_productId, FirebaseAuth.instance.currentUser!.uid, rate);
    update();
    widget.arguments["updateList"]();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text("Notunuverdim.com"),
              actions: [
                IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () {
                    AuthMethods().signOutUser();
                    Navigator.pushNamedAndRemoveUntil(
                        context, "/", (r) => false);
                  },
                ),
              ],
              backgroundColor: AppColors.primaryBg,
              elevation: 0,
            ),
            body: _isLoading || _productId == ""
                ? Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                width: 1,
                                color: AppColors.thirdText,
                              )),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(children: [
                              Expanded(
                                flex: 0,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6.0),
                                  child: Image.network(
                                    _productImage,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                flex: 1,
                                child: SizedBox(
                                  height: 100,
                                  // color: Colors.red,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _productName,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '$_productReviewCount Değerlendirme',
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                      Text(
                                        '$_productScore Puan',
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          RateButton(
                                            buttonText: '1',
                                            onPressed: () {
                                              rateProduct(1);
                                            },
                                            isRated: _rated == 1,
                                          ),
                                          RateButton(
                                              buttonText: '2',
                                              onPressed: () {
                                                rateProduct(2);
                                              },
                                              isRated: _rated == 2),
                                          RateButton(
                                              buttonText: '3',
                                              onPressed: () {
                                                rateProduct(3);
                                              },
                                              isRated: _rated == 3),
                                          RateButton(
                                              buttonText: '4',
                                              onPressed: () {
                                                rateProduct(4);
                                              },
                                              isRated: _rated == 4),
                                          RateButton(
                                              buttonText: '5',
                                              onPressed: () {
                                                rateProduct(5);
                                              },
                                              isRated: _rated == 5),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ]),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Ürün Bilgileri",
                            style: TextStyle(
                                color: AppColors.thirdText,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          decoration: BoxDecoration(
                              color: Colors.blueGrey[900],
                              border: Border(
                                  bottom: BorderSide(
                                      width: 2, color: AppColors.primaryBg),
                                  top: BorderSide(
                                      width: 0, color: AppColors.primaryBg),
                                  left: BorderSide(
                                      width: 0, color: AppColors.primaryBg),
                                  right: BorderSide(
                                      width: 0, color: AppColors.primaryBg)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: SingleChildScrollView(
                              child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 8),
                            child: Text(
                              _productDetail,
                              style:
                                  TextStyle(fontSize: 15, letterSpacing: 0.5),
                            ),
                          )),
                        )
                      ],
                    ),
                  )));
  }
}
