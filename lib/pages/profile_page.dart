import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rating_app/firebase/auth_methods.dart';
import 'package:rating_app/firebase/firestore_methods.dart';
import 'package:rating_app/firebase/storage_methods.dart';
import 'package:rating_app/styles/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rating_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoading = true;
  String username = "";
  String email = "";
  String profilePicUrl = "";
  String userRole = "";
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  _ProfilePageState() {
    getProfile();
  }

  Future<void> getProfile() async {
    DocumentSnapshot currentUserSnapShot = await AuthMethods().getCurrentUser();
    var data = currentUserSnapShot.data() as Map<String, dynamic>;

    setState(() {
      username = data['username'];
      email = data['email'];
      profilePicUrl = data['profilePicUrl'];
      userRole = data['role'];
      isLoading = false;
    });
  }

  Future<void> updateProfilePic() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      File file = File(image.path);
      String newPhoto =
          await StorageMethods().uploadImageToStorage("profile", file, uid);
      FireStoreMethods().updateProfile(newPhoto, uid);

      setState(() {
        profilePicUrl = newPhoto;
      });
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(mainAxisSize: MainAxisSize.max, children: [
                    SizedBox(
                      height: 20,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6.0),
                      child: profilePicUrl == ""
                          ? Image.asset(
                              'assets/temp/pp.webp',
                              width: 180,
                              height: 180,
                              fit: BoxFit.fill,
                            )
                          : Image.network(
                              profilePicUrl,
                              width: 180,
                              height: 180,
                              fit: BoxFit.fill,
                            ),
                    ),
                    IconButton(
                        onPressed: updateProfilePic,
                        icon: Icon(Icons.camera_alt_rounded),
                        iconSize: 32),
                    SizedBox(height: 50),
                    CustomText(text: username, label: "Kullanıcı Adı"),
                    SizedBox(height: 30),
                    CustomText(text: email, label: "E-Posta Adresi"),
                    SizedBox(
                      height: 20,
                    ),
                    if (userRole == "admin")
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/admin',
                                arguments: {"action": "list"});
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryBg,
                              fixedSize: Size(200, 40),
                              elevation: 0.0,
                              shadowColor: Colors.transparent),
                          child: Text("Ürün Listesi",
                              style: TextStyle(fontSize: 16))),
                    if (userRole == "admin")
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/admin',
                                arguments: {"action": "add"});
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryBg,
                              fixedSize: Size(200, 40),
                              elevation: 0.0,
                              shadowColor: Colors.transparent),
                          child: Text(
                            "Ürün Ekle",
                            style: TextStyle(fontSize: 16),
                          )),
                  ]),
                ),
              ),
      ),
    );
  }
}
