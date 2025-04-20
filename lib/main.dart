// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:daily_dairies/api/firebase_api.dart';
// import 'package:daily_dairies/controllers/diary_controller.dart';
// import 'package:daily_dairies/controllers/biometric_controller.dart';
// import 'package:daily_dairies/core/translations.dart';
// import 'package:daily_dairies/routes/app_routes.dart';
// import 'package:flutter/material.dart' as flutter;
// import 'package:get/get.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';

// void main() async {
//   flutter.WidgetsFlutterBinding.ensureInitialized();

//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

//   FirebaseFirestore.instance.settings = const Settings(
//     persistenceEnabled: true,
//   );

//   await FirebaseApi().initNotifications();
//   await AppTranslations.loadTranslations();
//   // Init GetX controllers
//   Get.put(BiometricServices());
//   Get.put(DiaryController());

//   flutter.runApp(const MyApp());
// }

// class MyApp extends flutter.StatelessWidget {
//   const MyApp({super.key});

//   @override
//   flutter.Widget build(flutter.BuildContext context) {
//     return GetMaterialApp.router(
//       title: 'Daily Diary',
//       debugShowCheckedModeBanner: false,
//       theme: flutter.ThemeData(
//         primarySwatch: flutter.Colors.lightBlue,
//         useMaterial3: true,
//       ),
//       translations: AppTranslations(),
//       locale: Get.deviceLocale ?? const flutter.Locale('en'),
//       fallbackLocale: const flutter.Locale('en'),
//       supportedLocales: const [
//         flutter.Locale('en'),
//         flutter.Locale('ur'),
//         flutter.Locale('ar'),
//       ],
//       localizationsDelegates: const [
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//       ],
//       routerDelegate: AppRoutes.router.routerDelegate,
//       routeInformationParser: AppRoutes.router.routeInformationParser,
//       routeInformationProvider: AppRoutes.router.routeInformationProvider,
//       builder: (context, child) {
//         return flutter.Directionality(
//           textDirection: _getTextDirection(Get.locale?.languageCode ?? 'en'),
//           child: child!,
//         );
//       },
//     );
//   }

//   flutter.TextDirection _getTextDirection(String languageCode) {
//     return (languageCode == 'ar' || languageCode == 'ur')
//         ? flutter.TextDirection.rtl
//         : flutter.TextDirection.ltr;
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_dairies/api/firebase_api.dart';
import 'package:daily_dairies/controllers/diary_controller.dart';
import 'package:daily_dairies/controllers/biometric_controller.dart';
import 'package:daily_dairies/controllers/theme_controller.dart';
import 'package:daily_dairies/core/translations.dart';
import 'package:daily_dairies/routes/app_routes.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  flutter.WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  await FirebaseApi().initNotifications();
  await AppTranslations.loadTranslations();
  await GetStorage.init(); // Initialize GetStorage

  Get.put(BiometricServices());
  Get.put(DiaryController());
  Get.put(ThemeController());

  final box = GetStorage();

  final languageCode = box.read('language_code') ?? 'en';
  final countryCode = box.read('country_code') ?? 'US';

  final savedLocale = flutter.Locale(languageCode, countryCode);

  flutter.runApp(MyApp(savedLocale: savedLocale));
}

class MyApp extends flutter.StatelessWidget {
  final flutter.Locale savedLocale;
  const MyApp({super.key, required this.savedLocale});

  @override
  flutter.Widget build(flutter.BuildContext context) {
    return GetMaterialApp.router(
      title: 'Daily Diary',
      debugShowCheckedModeBanner: false,
      theme: flutter.ThemeData(
        primarySwatch: flutter.Colors.lightBlue,
        useMaterial3: true,
      ),
      translations: AppTranslations(),
      locale: savedLocale,
      fallbackLocale: const flutter.Locale('en'),
      supportedLocales: const [
        flutter.Locale('en'),
        flutter.Locale('ur'),
        flutter.Locale('ar'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerDelegate: AppRoutes.router.routerDelegate,
      routeInformationParser: AppRoutes.router.routeInformationParser,
      routeInformationProvider: AppRoutes.router.routeInformationProvider,
      builder: (context, child) {
        return flutter.Directionality(
          textDirection: _getTextDirection(Get.locale?.languageCode ?? 'en'),
          child: child!,
        );
      },
    );
  }

  flutter.TextDirection _getTextDirection(String languageCode) {
    return (languageCode == 'ar' || languageCode == 'ur')
        ? flutter.TextDirection.rtl
        : flutter.TextDirection.ltr;
  }
}














// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:daily_dairies/api/firebase_api.dart';
// import 'package:daily_dairies/controllers/diary_controller.dart';
// import 'package:daily_dairies/controllers/biometric_controller.dart';
// import 'package:daily_dairies/routes/app_routes.dart';
// import 'package:daily_dairies/screens/enter_pin_screen.dart';
// import 'package:daily_dairies/screens/loginScreen.dart';
// import 'package:daily_dairies/screens/homeScreen.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// // final navigatorKey = GlobalKey<NavigatorState>();

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Initialize Firebase first
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

//   // Initialize other services after Firebase
//   Get.put(BiometricServices());

//   // Will get same data from cache
//   FirebaseFirestore.instance.settings = const Settings(
//     persistenceEnabled: true,
//   );

//   await FirebaseApi().initNotifications();

//   // Initialize EasyLocalization
//   await EasyLocalization.ensureInitialized();

//   // Register GetX Controller
//   Get.put(DiaryController());

//   runApp(
//     EasyLocalization(
//       supportedLocales: const [
//         Locale('en'), // English
//         Locale('ur'), // Urdu
//         Locale('ar'), // Arabic
//       ],
//       path: 'assets/lang', // Path to translation files
//       fallbackLocale: const Locale('en'),
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   Future<Widget> _getInitialScreen() async {
//     final prefs = await SharedPreferences.getInstance();
//     final pin = prefs.getString('diary_pin');
//     final currentUser = FirebaseAuth.instance.currentUser;

//     if (pin == null || pin.isEmpty) {
//       // No PIN set
//       return currentUser != null ? const HomeScreen() : LoginScreen();
//     } else {
//       // PIN is set, always show PIN screen first
//       return const EnterPinScreen();
//     }
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp.router(
//       title: 'Daily Diary',
//       routerConfig: AppRoutes.router, // GoRouter Configuration
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.lightBlue,
//         useMaterial3: true,
//       ),
//       // navigatorKey: navigatorKey,
//       locale: context.locale, // Use EasyLocalization locale
//       supportedLocales: context.supportedLocales,
//       localizationsDelegates: context.localizationDelegates,
//     );
//   }
// }
