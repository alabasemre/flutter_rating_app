// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:rating_app/firebase/firestore_methods.dart';
import 'package:rating_app/styles/app_colors.dart';
import 'package:flutter/material.dart';

class AdminProductCard extends StatefulWidget {
  final String productId;
  final String productName;
  final String productImage;
  final String productImageName;
  final String productDetail;
  final int productReviewCount;
  final double productScore;
  final Function deleteProductFromParent;
  final Function updateProductFromParent;

  const AdminProductCard(
      {Key? key,
      required this.productName,
      required this.productImage,
      required this.productImageName,
      required this.productDetail,
      required this.productReviewCount,
      required this.productScore,
      required this.productId,
      required this.deleteProductFromParent,
      required this.updateProductFromParent})
      : super(key: key);

  @override
  State<AdminProductCard> createState() => _AdminProductCardState();
}

class _AdminProductCardState extends State<AdminProductCard> {
  bool _isLoading = false;

  Future<void> deleteProduct(context) async {
    setState(() {
      _isLoading = true;
    });
    var res = await FireStoreMethods()
        .deleteProduct(widget.productId, widget.productImageName);
    if (res["error"] == true) {
      _showToast(context, res["errorMessage"].toString());
    } else {
      widget.deleteProductFromParent(widget.productId);
      setState(() {
        _isLoading = false;
      });
      _showToast(context, "Ürün Başarıyla Silindi");
    }
  }

  void _showToast(BuildContext context, String text) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(text),
        action: SnackBarAction(
            label: 'Kapat', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
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
          child: Row(
            children: [
              Expanded(
                flex: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6.0),
                  child: Image.network(
                    widget.productImage,
                    width: 75,
                    height: 75,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: 75,
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
                    ],
                  ),
                ),
              ),
              Expanded(
                  flex: 0,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: _isLoading
                                  ? null
                                  : () {
                                      Navigator.pushNamed(context, '/admin',
                                          arguments: {
                                            "action": "update",
                                            "product": {
                                              "productId": widget.productId,
                                              "productName": widget.productName,
                                              "productDetail":
                                                  widget.productDetail,
                                              "productImg": widget.productImage,
                                              "productImageName":
                                                  widget.productImageName,
                                              "updateList":
                                                  widget.updateProductFromParent
                                            }
                                          });
                                    },
                              icon: Icon(
                                Icons.edit_document,
                                size: 32,
                              )),
                          IconButton(
                              onPressed: _isLoading
                                  ? null
                                  : () => showDialog(
                                      context: context,
                                      builder: (BuildContext context_) =>
                                          AlertDialog(
                                            title:
                                                Text("İşleminizi Onaylayın!"),
                                            content: Text(
                                                "Ürünü Silmek İstiyor Musunuz?"),
                                            actions: <Widget>[
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(
                                                        context_, 'Cancel');
                                                  },
                                                  child: Text("İptal")),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(
                                                        context_, 'OK');
                                                    deleteProduct(context);
                                                  },
                                                  child: Text("Evet")),
                                            ],
                                          )),
                              icon: Icon(
                                Icons.delete,
                                size: 32,
                              )),
                        ],
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
