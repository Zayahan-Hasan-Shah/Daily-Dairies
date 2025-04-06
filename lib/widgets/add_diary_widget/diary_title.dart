import 'package:flutter/material.dart';
import 'package:daily_dairies/core/colorPallete.dart';

class DiaryTitle extends StatelessWidget {
  final TextEditingController controller;

  const DiaryTitle({
    super.key,
    required this.controller,
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
        hintText: "Enter diary title",
        labelStyle: TextStyle(color: Colorpallete.backgroundColor),
        hintStyle: TextStyle(
          color: Colorpallete.backgroundColor,
        ),
      ),
    );
  }
}