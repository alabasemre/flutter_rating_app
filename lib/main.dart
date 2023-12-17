import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rating_app/pages/admin_main_page.dart';
import 'package:rating_app/pages/home_page.dart';
import 'package:rating_app/pages/login_page.dart';
import 'package:rating_app/pages/main_page.dart';
import 'package:rating_app/pages/product_detail_page.dart';
import 'package:rating_app/pages/profile_page.dart';
import 'package:rating_app/pages/signup_page.dart';
import 'package:rating_app/styles/app_colors.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          fontFamily: "Urbanist",
          scaffoldBackgroundColor: AppColors.mainBackgroundColor,
          brightness: Brightness.dark),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage(),
        '/main': (context) => const MainPage(),
        '/admin': (context) => const AdminMainPage(),
        '/productDetail': (context) =>
            ProductDetail(arguments: ModalRoute.of(context)?.settings.arguments)
      },
    );
  }
}
