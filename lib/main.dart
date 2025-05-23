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
