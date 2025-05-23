import 'package:daily_dairies/models/diary_entry.dart';
import 'package:daily_dairies/screens/SetPatternScreen.dart';
import 'package:daily_dairies/screens/SetPinScreen.dart';
import 'package:daily_dairies/screens/achievmentScreen.dart';
import 'package:daily_dairies/screens/addDiaryScreen.dart';
import 'package:daily_dairies/screens/backupscreen.dart';
import 'package:daily_dairies/screens/calendarScreen.dart';
import 'package:daily_dairies/screens/diarylock.dart';
import 'package:daily_dairies/screens/entries_by_tag_screen.dart';
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
import 'package:daily_dairies/screens/profileScreen.dart';
import 'package:daily_dairies/screens/searchScreen.dart';
import 'package:daily_dairies/screens/settingScreen.dart';
import 'package:daily_dairies/screens/signupScreen.dart';
import 'package:daily_dairies/screens/splashScreen.dart';
import 'package:daily_dairies/screens/tagScreen.dart';
import 'package:daily_dairies/screens/themeScreen.dart';
import 'package:daily_dairies/widgets/app_drawer.dart';
import 'package:daily_dairies/screens/profile_section.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:get/get.dart';

class AppRoutes {
  static final router = GoRouter(
    initialLocation: '/splash',
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
            path: '/splash',
            builder: (context, state) => const SplashScreen(),
          ),
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
            builder: (context, state) {
              final user = FirebaseAuth.instance.currentUser;
              return user == null ? LoginScreen() : const HomeScreen();
            },
          ),
          GoRoute(
            path: '/search',
            builder: (context, state) {
              return SearchScreen();
            },
          ),
          GoRoute(
            path: '/profilesection',
            builder: (context, state) => const ProfileSectionWidget(),
          ),
          GoRoute(
            path: '/add-diary',
            builder: (context, state) => AddDiaryScreen(),
          ),
          GoRoute(
            path: '/tagmanagement',
            builder: (context, state) => const Tagscreen(),
          ),
          GoRoute(
            path: '/tagged/:tag',
            builder: (context, state) {
              final tag = state.pathParameters['tag']!;
              return EntriesByTagScreen(tag: tag);
            },
          ),
          GoRoute(
            path: '/diarylock',
            builder: (context, state) => const DiarylockScreen(),
          ),
          GoRoute(
            path: '/backup',
            builder: (context, state) => BackupAndRestoreScreen(),
          ),
          GoRoute(
            path: '/exportdata',
            builder: (context, state) => ExportScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingScreen(),
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
            path: '/thememanagment',
            builder: (context, state) => const ThemeScreen(),
          ),
          GoRoute(
            path: '/lanaguagemanagement',
            builder: (context, state) => const LanguageScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/achievements',
            builder: (context, state) {
              final achievements = state.extra as List<Map<String, String>>?;
              return AchievementsScreen(
                achievements: achievements ?? [], // Fallback in case of null
              );
            },
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
            builder: (context, state) => const SetDiaryScreen(),
          ),
          GoRoute(
            path: '/forgetpassword',
            builder: (context, state) => const ForgertPasswordScreen(),
          ),
          GoRoute(
            path: '/dataprivacy',
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
          GoRoute(
              path: '/setPattern',
              builder: (context, state) => const SetPatternScreen()),
          GoRoute(
              path: '/setPin',
              builder: (context, state) => const SetPinScreen()),
        ],
      ),
    ],
  );
}
