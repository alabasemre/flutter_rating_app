// ignore_for_file: use_build_context_synchronously

import 'package:rating_app/firebase/auth_methods.dart';
import 'package:rating_app/pages/main_page.dart';
import 'package:rating_app/styles/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
    _emailController.dispose();
  }

  void signInUser(BuildContext context) async {
    try {
      UserCredential user = await AuthMethods()
          .signInUser(_emailController.text, _passwordController.text);

      if (user.user != null) {
        Navigator.of(context).pushReplacementNamed("/main");
      }
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
    if (FirebaseAuth.instance.currentUser != null) {
      return const MainPage();
    }
    return SafeArea(
      child: Scaffold(
          body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Giriş Yap",
              style: TextStyle(
                color: AppColors.thirdText,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                fontFamily: "Arial",
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Hesabınıza Giriş Yapın",
              style: TextStyle(
                  color: AppColors.primaryText,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 50,
            ),
            const Align(
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
            const SizedBox(
              height: 6,
            ),
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 2, color: AppColors.primaryBg),
                      top: BorderSide(width: 0, color: AppColors.primaryBg),
                      left: BorderSide(width: 0, color: AppColors.primaryBg),
                      right: BorderSide(width: 0, color: AppColors.primaryBg)),
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: TextField(
                controller: _emailController,
                style: const TextStyle(color: AppColors.primaryText),
                decoration: const InputDecoration(
                  hintText: "E-posta Adresi",
                  hintStyle: TextStyle(color: AppColors.primaryText),
                  filled: true,
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Align(
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
            const SizedBox(
              height: 6,
            ),
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 2, color: AppColors.primaryBg),
                      top: BorderSide(width: 0, color: AppColors.primaryBg),
                      left: BorderSide(width: 0, color: AppColors.primaryBg),
                      right: BorderSide(width: 0, color: AppColors.primaryBg)),
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                style: const TextStyle(color: AppColors.primaryText),
                decoration: const InputDecoration(
                  hintText: "Şifre",
                  hintStyle: TextStyle(color: AppColors.primaryText),
                  filled: true,
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBg,
                  fixedSize: const Size(200, 40),
                  elevation: 0.0,
                  shadowColor: Colors.transparent),
              onPressed: () {
                signInUser(context);
              },
              child: const Text(
                "Giriş Yap",
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Bir hesabın yok mu?",
                    style: TextStyle(
                        color: AppColors.secondaryText, fontSize: 18)),
                TextButton(
                  style: TextButton.styleFrom(
                    splashFactory: NoSplash.splashFactory,
                    backgroundColor: Colors.transparent,
                    enableFeedback: false,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed("/signup");
                  },
                  child: const Text(
                    "Kayıt Ol",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColors.thirdText,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      )),
    );
  }
}
