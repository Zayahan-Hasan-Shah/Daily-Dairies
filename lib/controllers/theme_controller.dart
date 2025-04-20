import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/colorPallete.dart';
import '../models/theme_color_model.dart';

class ThemeController extends GetxController {
  static final ThemeColorModel defaultTheme = ThemeColorModel(
    appBarColor: const Color.fromRGBO(28, 50, 91, 1),
    bodyColor: const Color.fromRGBO(132, 166, 230, 1),
  );

  Rx<ThemeColorModel> selectedTheme = defaultTheme.obs;

  @override
  void onInit() {
    super.onInit();
    loadThemeFromFirestore();
  }

  void setTheme(ThemeColorModel theme) async {
    selectedTheme.value = theme;
    Colorpallete.backgroundColor = theme.appBarColor;
    Colorpallete.bottomNavigationColor = theme.appBarColor;
    Colorpallete.bgColor = theme.bodyColor;
    update();
    await saveThemeToFirestore(theme);
  }

  Future<void> saveThemeToFirestore(ThemeColorModel theme) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await FirebaseFirestore.instance
        .collection('user_themes')
        .doc(user.uid)
        .set({
      'appBarColor': theme.appBarColor.value,
      'bodyColor': theme.bodyColor.value,
      'userId': user.uid,
    });
  }

  Future<void> loadThemeFromFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final doc = await FirebaseFirestore.instance
        .collection('user_themes')
        .doc(user.uid)
        .get();
    if (doc.exists) {
      final data = doc.data()!;
      final theme = ThemeColorModel(
        appBarColor: Color(data['appBarColor']),
        bodyColor: Color(data['bodyColor']),
      );
      selectedTheme.value = theme;
      Colorpallete.backgroundColor = theme.appBarColor;
      Colorpallete.bottomNavigationColor = theme.appBarColor;
      Colorpallete.bgColor = theme.bodyColor;
      update();
    }
  }
}
