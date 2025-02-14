import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:daily_dairies/core/colorPallete.dart';
import 'package:daily_dairies/screens/homeScreen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorpallete.backgroundColor,
      body: AnimatedSplashScreen(
        splash: 'assets/images/splashimage.jpg',
        centered: true,
        splashIconSize: 2000,
        duration: 2000,
        nextScreen: const HomeScreen(),
      ),
    );
  }
}
 