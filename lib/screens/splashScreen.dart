import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:daily_dairies/core/colorPallete.dart';
import 'package:daily_dairies/screens/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.go('/');
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorpallete.backgroundColor,
      body: AnimatedSplashScreen(
        splash: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/splashimagee.jpg',
              width: 240,
              height: 240,
            ),
            const SizedBox(height: 20),
            const Text(
              'Daily Diaries',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        splashTransition: SplashTransition.fadeTransition,
        pageTransitionType: PageTransitionType.fade,
        animationDuration: const Duration(milliseconds: 500),
        splashIconSize: 300,
        duration: 2000,
        nextScreen: const HomeScreen(),
      ),
    );
  }
}
