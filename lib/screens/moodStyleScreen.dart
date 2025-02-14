import 'package:daily_dairies/core/colorPallete.dart';
import 'package:flutter/material.dart';

class Moodstylescreen extends StatelessWidget {
  const Moodstylescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorpallete.bgColor,
      appBar: AppBar(
        title: const Text("Mood Style"),
        foregroundColor: Colorpallete.bottomNavigationColor,
        backgroundColor: Colorpallete.backgroundColor,
      ),
    );
  }
  
}