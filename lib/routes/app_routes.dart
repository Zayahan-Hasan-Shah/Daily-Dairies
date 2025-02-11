import 'package:daily_dairies/screens/addDiaryScreen.dart';
import 'package:daily_dairies/screens/homeScreen.dart';
import 'package:daily_dairies/screens/loginScreen.dart';
import 'package:daily_dairies/screens/signupScreen.dart';
import 'package:daily_dairies/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';

class AppRoutes {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return Scaffold(
            drawer: AppDrawer(),
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
            path: '/add-diary',
            builder: (context, state) => AddDiaryScreen(),
          ),
          // GoRoute(
          //   path: '/settings',
          //   builder: (context, state) => const SettingsScreen(),
          // ),
        ],
      ),
    ],
  );
}
