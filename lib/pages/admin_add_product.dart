// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'dart:io';

import 'package:rating_app/firebase/firestore_methods.dart';
import 'package:rating_app/styles/app_colors.dart';
import 'package:rating_app/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdminAddProduct extends StatefulWidget {
  const AdminAddProduct({Key? key}) : super(key: key);

  @override
  State<AdminAddProduct> createState() => _AdminAddProductState();
}

class _AdminAddProductState extends State<AdminAddProduct> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productDetailController =
      TextEditingController();
  String _imagePath = "";
  bool _isLoading = false;

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

  Future<void> addProduct(BuildContext context) async {
    if (_isLoading) {
      return;
    }

    String productName = _productNameController.text;
    String productDetail = _productDetailController.text;

    if (productName.isNotEmpty && _imagePath != "") {
      setState(() {
        _isLoading = true;
      });
      Map<String, Object> res = await FireStoreMethods()
          .addProduct(productName, productDetail, File(_imagePath));

      if (res["error"] == true) {
        _showToast(context, res["errorMessage"].toString());
      } else {
        setState(() {
          _imagePath = "";
          _productNameController.clear();
          _productDetailController.clear();
          _isLoading = false;
        });
        _showToast(context, "Ürün Başarıyla Eklendi");
      }
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
                  child: _imagePath == ""
                      ? Image.asset(
                          'assets/temp/empty.png',
                          width: 180,
                          height: 180,
                          fit: BoxFit.fill,
                        )
                      : Image.file(
                          File(_imagePath),
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
                          addProduct(context);
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
                          "Ürünü Ekle",
                          style: TextStyle(fontSize: 16),
                        )),
            ],
          ),
        ),
      ),
    );
  }
}
