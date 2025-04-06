import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_dairies/api/firebase_api.dart';
import 'package:daily_dairies/controllers/diary_controller.dart';
import 'package:daily_dairies/controllers/biometric_controller.dart';
import 'package:daily_dairies/routes/app_routes.dart';
import 'package:daily_dairies/screens/enter_pin_screen.dart';
import 'package:daily_dairies/screens/loginScreen.dart';
import 'package:daily_dairies/screens/homeScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
// final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(BiometricServices());

  // Initialize Firebase
  await Firebase.initializeApp();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  // Will get same data from cache
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  await FirebaseApi().initNotifications();
  // Initialize EasyLocalization
  await EasyLocalization.ensureInitialized();

  // Register GetX Controller
  Get.put(DiaryController());

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'), // English
        Locale('ur'), // Urdu
        Locale('ar'), // Arabic
      ],
      path: 'assets/lang', // Path to translation files
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _getInitialScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final pin = prefs.getString('diary_pin');
    final currentUser = FirebaseAuth.instance.currentUser;

    if (pin == null || pin.isEmpty) {
      // No PIN set
      return currentUser != null ? const HomeScreen() : LoginScreen();
    } else {
      // PIN is set, always show PIN screen first
      return const EnterPinScreen();
    }
  }

  //  @override
  // Widget build(BuildContext context) {
  //   return MaterialApp.router(
  //     title: 'Daily Diary',
  //     routerConfig: AppRoutes.router, // GoRouter Configuration
  //     debugShowCheckedModeBanner: false,
  //     theme: ThemeData(
  //       primarySwatch: Colors.lightBlue,
  //       useMaterial3: true,
  //     ),
  //     // navigatorKey: navigatorKey,
  //     locale: context.locale, // Use EasyLocalization locale
  //     supportedLocales: context.supportedLocales,
  //     localizationsDelegates: context.localizationDelegates,
  //   );
  // }

   @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Daily Diary',
      routerConfig: AppRoutes.router, // GoRouter Configuration
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        useMaterial3: true,
      ),
      // navigatorKey: navigatorKey,
      locale: context.locale, // Use EasyLocalization locale
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
    );
  }
}
