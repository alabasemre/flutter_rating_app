import 'package:rating_app/firebase/auth_methods.dart';
import 'package:rating_app/pages/admin_add_product.dart';
import 'package:rating_app/pages/admin_product_list.dart';
import 'package:rating_app/pages/admin_update_product.dart';
import 'package:rating_app/styles/app_colors.dart';
import 'package:flutter/material.dart';

class AdminMainPage extends StatefulWidget {
  const AdminMainPage({Key? key}) : super(key: key);

  @override
  State<AdminMainPage> createState() => _AdminMainPageState();
}

class _AdminMainPageState extends State<AdminMainPage> {
  String action = "list";

  Widget getBody(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    setState(() {
      action = arguments["action"];
    });

    switch (action) {
      case 'list':
        return AdminProductList();
      case 'add':
        return AdminAddProduct();
      case 'update':
        return AdminUpdateProduct(product: arguments["product"]);
      default:
        return Text("Erişim İzniniz Yok!");
    }
  }

  // This widget is the root of your application.
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
              Navigator.pushNamedAndRemoveUntil(context, "/", (r) => false);
            },
          ),
        ],
        backgroundColor: AppColors.primaryBg,
        elevation: 0,
      ),
      body: getBody(context),
    ));
  }
}
