import 'package:flutter/material.dart';
import 'package:daily_dairies/core/colorPallete.dart';
import 'package:get/get.dart';

class DiaryTitle extends StatelessWidget {
  final TextEditingController controller;
  final Color titleColor;

  const DiaryTitle({
    super.key,
    required this.controller,
    required this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      textAlignVertical: TextAlignVertical.top,
      maxLines: 1,
      controller: controller,
      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(0),
        ),
        hintText: 'write_diary_entry'.tr,
        labelStyle: TextStyle(color: Colorpallete.backgroundColor),
        hintStyle: TextStyle(
          color: titleColor,
        ),
      ),
    );
  }
}
