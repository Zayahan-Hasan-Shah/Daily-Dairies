import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class AppTranslations extends Translations {
  // This will store the dynamically loaded translations
  static Map<String, Map<String, String>> translationsMap = {};

  // Override the `keys` getter to return the loaded translations
  @override
  Map<String, Map<String, String>> get keys => translationsMap;

  // Load all translations dynamically from JSON files
  static Future<void> loadTranslations() async {
    List<String> locales = ['en', 'ur', 'ar'];
    Map<String, Map<String, String>> result = {};

    for (var locale in locales) {
      // Load each JSON file from the assets
      String jsonString =
          await rootBundle.loadString('assets/lang/$locale.json');
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      result[locale] =
          jsonMap.map((key, value) => MapEntry(key, value.toString()));
    }

    // Update the translationsMap with loaded data
    translationsMap = result; // Assign the loaded translations to the map
  }
}
