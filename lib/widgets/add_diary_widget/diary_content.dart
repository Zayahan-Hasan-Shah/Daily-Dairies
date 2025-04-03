import 'package:flutter/material.dart';
import 'package:daily_dairies/core/colorPallete.dart';

class DiaryContent extends StatelessWidget {
  final TextEditingController controller;
  final TextStyle currentTextStyle;
  final Function(String) onChanged;

  const DiaryContent({
    Key? key,
    required this.controller,
    required this.currentTextStyle,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: TextField(
        textAlignVertical: TextAlignVertical.top,
        controller: controller,
        maxLines: null,
        expands: true,
        onChanged: onChanged,
        style: currentTextStyle,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(0),
          ),
          hintText: "Write your diary entry here...",
          hintStyle: TextStyle(
            color: Colorpallete.backgroundColor,
          ),
        ),
      ),
    );
  }
}