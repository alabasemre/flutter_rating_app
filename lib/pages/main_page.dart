// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:rating_app/firebase/auth_methods.dart';
import 'package:rating_app/pages/home_page.dart';
import 'package:rating_app/pages/profile_page.dart';
import 'package:rating_app/pages/rated_products_page.dart';
import 'package:rating_app/styles/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  _MainPageState() {
    if (FirebaseAuth.instance.currentUser == null) {
      Navigator.of(context).pushReplacementNamed("/");
      AuthMethods().signOutUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notunuverdim.com"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              AuthMethods().signOutUser();
              Navigator.pushNamedAndRemoveUntil(context, "/", (r) => false);
            },
          ),
        ],
        backgroundColor: AppColors.primaryBg,
        elevation: 0,
      ),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Anasayfa"),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: "Notladım"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Profil"),
        ],
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        backgroundColor: AppColors.primaryBg,
        unselectedItemColor: AppColors.secondaryText,
        selectedItemColor: AppColors.primaryText,
        selectedFontSize: 15,
        unselectedFontSize: 15,
      ),
    );
  }

  final pages = [HomePage(), RatedProductsPage(), ProfilePage()];
}
