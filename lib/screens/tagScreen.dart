import 'package:daily_dairies/core/colorPallete.dart';
import 'package:flutter/material.dart';

class Tagscreen extends StatelessWidget {
  const Tagscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorpallete.bgColor,
      appBar: AppBar(
        title: const Text("Tag Management"),
        foregroundColor: Colorpallete.bottomNavigationColor,
        backgroundColor: Colorpallete.backgroundColor,
      ),
    );
  }
}
