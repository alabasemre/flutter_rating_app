// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'package:rating_app/firebase/auth_methods.dart';
import 'package:rating_app/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:rating_app/pages/main_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isSigned = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }

  void signUpUser(BuildContext context) async {
    try {
      await AuthMethods().signUpUser(_emailController.text,
          _passwordController.text, _usernameController.text);

      setState(() {
        _isSigned = true;
      });
    } catch (e) {
      _showToast(context, "Invalid credentials");
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
    return _isSigned
        ? MainPage()
        : SafeArea(
            child: Scaffold(
                body: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Kayıt Ol",
                        style: TextStyle(
                          color: AppColors.thirdText,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Arial",
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Hesap Oluştur",
                        style: TextStyle(
                            color: AppColors.primaryText,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text(
                              "Kullanıcı Adı",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: AppColors.secondaryText,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                          )),
                      SizedBox(
                        height: 6,
                      ),
                      Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
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
                        child: TextField(
                          controller: _usernameController,
                          style: TextStyle(color: AppColors.primaryText),
                          decoration: InputDecoration(
                            hintText: "Kullanıcı Adı",
                            hintStyle: TextStyle(color: AppColors.primaryText),
                            filled: true,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text(
                              "E-Posta",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: AppColors.secondaryText,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                          )),
                      SizedBox(
                        height: 6,
                      ),
                      Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
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
                        child: TextField(
                          controller: _emailController,
                          style: TextStyle(color: AppColors.primaryText),
                          decoration: InputDecoration(
                            hintText: "E-posta Adresi",
                            hintStyle: TextStyle(color: AppColors.primaryText),
                            filled: true,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text(
                              "Şifre",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: AppColors.secondaryText,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                          )),
                      SizedBox(
                        height: 6,
                      ),
                      Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
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
                        child: TextField(
                          controller: _passwordController,
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          style: TextStyle(color: AppColors.primaryText),
                          decoration: InputDecoration(
                            hintText: "Şifre",
                            hintStyle: TextStyle(color: AppColors.primaryText),
                            filled: true,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBg,
                            fixedSize: Size(200, 40),
                            elevation: 0.0,
                            shadowColor: Colors.transparent),
                        onPressed: () {
                          signUpUser(context);
                        },
                        child: Text(
                          "Kayıt Ol",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Zaten bir hesabın var mı?",
                              style: TextStyle(
                                  color: AppColors.secondaryText,
                                  fontSize: 18)),
                          TextButton(
                            style: TextButton.styleFrom(
                              splashFactory: NoSplash.splashFactory,
                              backgroundColor: Colors.transparent,
                              enableFeedback: false,
                            ),
                            onPressed: () {
                              Navigator.of(context).pushNamed('/');
                            },
                            child: Text(
                              "Giriş Yap",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: AppColors.thirdText,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )),
          );
  }
}
