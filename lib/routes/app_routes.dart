import 'package:daily_dairies/screens/addDiaryScreen.dart';
import 'package:daily_dairies/screens/backupscreen.dart';
import 'package:daily_dairies/screens/diarylock.dart';
import 'package:daily_dairies/screens/exportdataScreen.dart';
import 'package:daily_dairies/screens/faqScreen.dart';
import 'package:daily_dairies/screens/homeScreen.dart';
import 'package:daily_dairies/screens/loginScreen.dart';
import 'package:daily_dairies/screens/searchScreen.dart';
import 'package:daily_dairies/screens/settingScreen.dart';
import 'package:daily_dairies/screens/signupScreen.dart';
import 'package:daily_dairies/screens/tagScreen.dart';
import 'package:daily_dairies/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:get/get.dart';

class AppRoutes {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return Scaffold(
            drawer: const AppDrawer(),
            body: child,
          );
        },
        routes: [
          GoRoute(
            path: '/login',
            builder: (context, state) => LoginScreen(),
          ),
          GoRoute(
            path: '/signup',
            builder: (context, state) => SignupScreen(),
          ),
          GoRoute(
            path: '/',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/search',
            builder: (context, state) => const SearchScreen(),
          ),
          GoRoute(
            path: '/add-diary',
            builder: (context, state) => const AddDiaryScreen(),
          ),
          GoRoute(
            path: '/tagmanagement',
            builder: (context, state) => const Tagscreen(),
          ),
          GoRoute(
            path: '/diarylock',
            builder: (context, state) => const Diarylock(),
          ),
          GoRoute(
            path: '/backup',
            builder: (context, state) => BackupAndRestoreScreen(),
          ),
          GoRoute(
            path: '/exportdata',
            builder: (context, state) => const Exportdatascreen(),
          ),
          GoRoute(
            path: '/faq',
            builder: (context, state) => const Faqscreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const Settingscreen(),
          ),
        ],
      ),
    ],
  );
}
