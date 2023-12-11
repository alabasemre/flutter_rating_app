// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:rating_app/firebase/firestore_methods.dart';
import 'package:rating_app/styles/app_colors.dart';
import 'package:rating_app/widgets/rate_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  final int rated;
  final String productId;
  final String productName;
  final String productImage;
  final int productReviewCount;
  final double productScore;
  final String productDetail;
  final Function updateList;

  const ProductCard(
      {Key? key,
      required this.rated,
      required this.productId,
      required this.productName,
      required this.productImage,
      required this.productReviewCount,
      required this.productScore,
      required this.productDetail,
      required this.updateList})
      : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isLoading = false;

  Future<void> rateProduct(int rate) async {
    setState(() {
      _isLoading = true;
    });

    await FireStoreMethods().rateProduct(
        widget.productId, FirebaseAuth.instance.currentUser!.uid, rate);
    widget.updateList();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              width: 1,
              color: AppColors.thirdText,
            )),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _isLoading
              ? const SizedBox(
                  height: 100,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : InkWell(
                  onTap: () {
                    // TODO: go to product detail page
                  },
                  child: Row(
                    children: [
                      Expanded(
                        flex: 0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6.0),
                          child: Image.network(
                            widget.productImage,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.productName,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${widget.productReviewCount} Değerlendirme',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                '${widget.productScore} Puan',
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
                                    isRated: widget.rated == 1,
                                  ),
                                  RateButton(
                                      buttonText: '2',
                                      onPressed: () {
                                        rateProduct(2);
                                      },
                                      isRated: widget.rated == 2),
                                  RateButton(
                                      buttonText: '3',
                                      onPressed: () {
                                        rateProduct(3);
                                      },
                                      isRated: widget.rated == 3),
                                  RateButton(
                                      buttonText: '4',
                                      onPressed: () {
                                        rateProduct(4);
                                      },
                                      isRated: widget.rated == 4),
                                  RateButton(
                                      buttonText: '5',
                                      onPressed: () {
                                        rateProduct(5);
                                      },
                                      isRated: widget.rated == 5),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
