import 'package:daily_dairies/screens/achievmentScreen.dart';
import 'package:daily_dairies/screens/addDiaryScreen.dart';
import 'package:daily_dairies/screens/backupscreen.dart';
import 'package:daily_dairies/screens/calendarScreen.dart';
import 'package:daily_dairies/screens/diarylock.dart';
import 'package:daily_dairies/screens/exportdataScreen.dart';
import 'package:daily_dairies/screens/faqScreen.dart';
import 'package:daily_dairies/screens/faqsQnA/backupFailed.dart';
import 'package:daily_dairies/screens/faqsQnA/dataPrivacy.dart';
import 'package:daily_dairies/screens/faqsQnA/forgetPasswordScreen.dart';
import 'package:daily_dairies/screens/faqsQnA/getDiaryIdeas.dart';
import 'package:daily_dairies/screens/faqsQnA/getStartedScreen.dart';
import 'package:daily_dairies/screens/faqsQnA/getYourBackedUpData.dart';
import 'package:daily_dairies/screens/faqsQnA/other.dart';
import 'package:daily_dairies/screens/faqsQnA/setDiarylock.dart';
import 'package:daily_dairies/screens/faqsQnA/tagManagement.dart';
import 'package:daily_dairies/screens/homeScreen.dart';
import 'package:daily_dairies/screens/languageScreen.dart';
import 'package:daily_dairies/screens/loginScreen.dart';
import 'package:daily_dairies/screens/moodStyleScreen.dart';
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
            builder: (context, state) => DiarylockScreen(),
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
            path: '/settings',
            builder: (context, state) => const Settingscreen(),
          ),
          GoRoute(
            path: '/calendar',
            builder: (context, state) => CalendarScreen(),
          ),
          GoRoute(
            path: '/moodstylemanagment',
            builder: (context, state) => const Moodstylescreen(),
          ),
          GoRoute(
            path: '/lanaguagemanagement',
            builder: (context, state) => const LanguageScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const LanguageScreen(),
          ),
          GoRoute(
            path: '/achievements',
            builder: (context, state) => const Achievmentscreen(),
          ),
          GoRoute(
            path: '/faqs',
            builder: (context, state) => const FAQScreen(),
          ),
          GoRoute(
            path: '/getstarteddiary',
            builder: (context, state) => const GetStartedScreen(),
          ),
          GoRoute(
            path: '/getdiaryideas',
            builder: (context, state) => const GetDiaryIdeasScreen(),
          ),
          GoRoute(
            path: '/setdiarylock',
            builder: (context, state) => const  SetDiaryScreen(),
          ),
          GoRoute(
            path: '/forgetpassword',
            builder: (context, state) => const ForgertPasswordScreen(),
          ),
          GoRoute(
            path: '/forgetpassword',
            builder: (context, state) => const DataPrivacyScreen(),
          ),
          GoRoute(
            path: '/backupfailed',
            builder: (context, state) => const BackupFailedScreen(),
          ),
          GoRoute(
            path: '/getyourbackedupdata',
            builder: (context, state) => const GetyourbackedupdataScreen(),
          ),
          GoRoute(
            path: '/tagmanagment',
            builder: (context, state) => const TagManagementScreen(),
          ),
          GoRoute(
            path: '/otherquestions',
            builder: (context, state) => const OtherScreen(),
          ),
        ],
      ),
    ],
  );
}
