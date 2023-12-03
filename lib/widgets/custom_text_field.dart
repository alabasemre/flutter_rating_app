import 'package:rating_app/styles/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String text;
  final TextEditingController textEditingController;
  final TextInputType? textInputType;
  final int? maxLines;
  final bool? enabled;

  const CustomTextField(
      {Key? key,
      required this.text,
      required this.textEditingController,
      this.enabled,
      this.textInputType,
      this.maxLines})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(width: 2, color: AppColors.primaryBg),
              top: BorderSide(width: 0, color: AppColors.primaryBg),
              left: BorderSide(width: 0, color: AppColors.primaryBg),
              right: BorderSide(width: 0, color: AppColors.primaryBg)),
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: TextField(
        controller: textEditingController,
        enabled: enabled ?? true,
        keyboardType: textInputType,
        maxLines: maxLines,
        style: const TextStyle(color: AppColors.primaryText),
        decoration: InputDecoration(
          hintText: text,
          hintStyle: const TextStyle(color: AppColors.primaryText),
          filled: true,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
