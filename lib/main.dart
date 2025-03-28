import 'package:daily_dairies/controllers/diary_controller.dart';
import 'package:daily_dairies/routes/app_routes.dart';
import 'package:easy_localization/easy_localization.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:get/get_core/src/get_main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);

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

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp.router(
  //     title: 'Daily Diary',
  //     routerConfig: AppRoutes.router, // GoRouter Configuration
  //     debugShowCheckedModeBanner: false,
  //     theme: ThemeData(
  //       primarySwatch: Colors.lightBlue,
  //       useMaterial3: true,
  //     ),
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
      locale: context.locale, // Use EasyLocalization locale
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
    );
  }

}
