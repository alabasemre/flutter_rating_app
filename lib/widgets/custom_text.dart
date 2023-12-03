// ignore_for_file: prefer_const_constructors

import 'package:rating_app/styles/app_colors.dart';
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final String label;

  const CustomText({Key? key, required this.text, required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: double.infinity),
      padding: EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(width: 2, color: AppColors.primaryBg),
              top: BorderSide(width: 0, color: AppColors.primaryBg),
              left: BorderSide(width: 0, color: AppColors.primaryBg),
              right: BorderSide(width: 0, color: AppColors.primaryBg)),
          borderRadius: BorderRadius.all(Radius.circular(4))),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              label,
              style: TextStyle(
                  color: AppColors.thirdText,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          SizedBox(
            height: 14,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              text,
              style: TextStyle(
                  color: AppColors.primaryText,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                  fontSize: 16),
            ),
          ),
          SizedBox(
            height: 6,
          ),
        ],
      ),
    );
  }
}
