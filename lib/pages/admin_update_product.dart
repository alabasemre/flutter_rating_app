// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:rating_app/firebase/firestore_methods.dart';
import 'package:rating_app/styles/app_colors.dart';
import 'package:rating_app/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdminUpdateProduct extends StatefulWidget {
  final Map<dynamic, dynamic>? product;
  const AdminUpdateProduct({Key? key, required this.product}) : super(key: key);

  @override
  State<AdminUpdateProduct> createState() => _AdminUpdateProductState();
}

class _AdminUpdateProductState extends State<AdminUpdateProduct> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productDetailController =
      TextEditingController();
  String _productImage = "";
  String _imagePath = "";
  String _productImageName = "";
  bool _isLoading = false;
  bool _isUpdated = false;

  void setValues() {
    if (!_isUpdated) {
      _productNameController.text = widget.product!["productName"];
      _productDetailController.text = widget.product!["productDetail"];
      setState(() {
        _productImage = widget.product!["productImg"];
        _productImageName = widget.product!["productImageName"];
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _productNameController.dispose();
    _productDetailController.dispose();
  }

  Future<void> selectProductPicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imagePath = image.path;
      });
    }
  }

  Future<void> updateProduct(BuildContext context) async {
    if (_isLoading) {
      return;
    }

    String productName = _productNameController.text;
    String productDetail = _productDetailController.text;

    if (widget.product!["productName"] == productName &&
        _imagePath == "" &&
        widget.product!["productDetail"] == productDetail) {
      _showToast(context, "Herhangi bir değişiklik yapmadınız.");
      return;
    }

    Map<String, Object> res;
    if (productName.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      if (_imagePath.isNotEmpty) {
        res = await FireStoreMethods().updateProduct(
            widget.product!["productId"],
            productName,
            productDetail,
            File(_imagePath),
            _productImageName);
        setState(() {
          _productImageName = res["imgName"].toString();
          _imagePath = "";
          _productImage = res["imgUrl"].toString();
        });
      } else {
        res = await FireStoreMethods().updateProduct(
            widget.product!["productId"],
            productName,
            productDetail,
            null,
            null);
      }

      if (res["error"] == true) {
        _showToast(context, res["errorMessage"].toString());
      } else {
        widget.product!["updateList"](widget.product!["productId"], productName,
            productDetail, _productImage, _productImageName);
        _showToast(context, "Ürün Başarıyla Güncellendi");
      }
      setState(() {
        _isLoading = false;
        _isUpdated = true;
      });
    } else {
      _showToast(context, "Resim ve Ürün Adı Boş Bırakılamaz.");
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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    setValues();
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            // mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              ClipRRect(
                  borderRadius: BorderRadius.circular(6.0),
                  child: _imagePath != ""
                      ? Image.file(
                          File(_imagePath),
                          width: 180,
                          height: 180,
                          fit: BoxFit.fill,
                        )
                      : Image.network(
                          _productImage,
                          width: 180,
                          height: 180,
                          fit: BoxFit.fill,
                        )),
              IconButton(
                  onPressed: _isLoading ? null : selectProductPicture,
                  icon: Icon(Icons.camera_alt_rounded),
                  iconSize: 32),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Ürün Adı",
                      style: TextStyle(
                          color: AppColors.thirdText,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              CustomTextField(
                text: "Ürün Adı",
                textEditingController: _productNameController,
                enabled: !_isLoading,
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Ürün Açıklaması",
                      style: TextStyle(
                          color: AppColors.thirdText,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              CustomTextField(
                text: "Ürün Açıklaması",
                textEditingController: _productDetailController,
                textInputType: TextInputType.multiline,
                maxLines: 5,
                enabled: !_isLoading,
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          updateProduct(context);
                        },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBg,
                      fixedSize: Size(200, 40),
                      elevation: 0.0,
                      shadowColor: Colors.transparent),
                  // child: CircularProgressIndicator()),
                  child: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          "Ürünü Güncelle",
                          style: TextStyle(fontSize: 16),
                        )),
            ],
          ),
        ),
      ),
    );
  }
}
