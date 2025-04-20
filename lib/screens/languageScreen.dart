// import 'package:flutter/material.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:daily_dairies/core/colorPallete.dart';

// class LanguageScreen extends StatefulWidget {
//   static Route route() =>
//       MaterialPageRoute(builder: (_) => const LanguageScreen());

//   const LanguageScreen({super.key});

//   @override
//   State<LanguageScreen> createState() => _LanguageScreenState();
// }

// class _LanguageScreenState extends State<LanguageScreen> {
//   final List<Map<String, dynamic>> languages = [
//     {'name': 'English', 'code': 'en', 'locale': const Locale('en')},
//     {'name': 'Urdu', 'code': 'ur', 'locale': const Locale('ur')},
//     {'name': 'Arabic', 'code': 'ar', 'locale': const Locale('ar')},
//   ];

//   String selectedLanguage = "en";

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     selectedLanguage = context.locale.languageCode; // Get saved language safely
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colorpallete.bgColor,
//       appBar: AppBar(
//         title: Text("select_language".tr), // Localized text
//         foregroundColor: Colorpallete.bottomNavigationColor,
//         backgroundColor: Colorpallete.backgroundColor,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               for (var language in languages)
//                 GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       selectedLanguage = language['code'];
//                       context.setLocale(language['locale']); // Change language
//                     });
//                   },
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(vertical: 8),
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: selectedLanguage == language['code']
//                           ? Colorpallete.backgroundColor
//                           : Colorpallete.drawericonColor.withOpacity(0.4),
//                       border: Border.all(
//                         color: selectedLanguage == language['code']
//                             ? Colorpallete.bottomNavigationColor
//                             : Colors.grey,
//                       ),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Text(
//                       language['name'], // Show language name
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w500,
//                         color: selectedLanguage == language['code']
//                             ? Colorpallete.bottomNavigationColor
//                             : Colors.black,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:daily_dairies/core/colorPallete.dart';

class LanguageScreen extends StatefulWidget {
  static Route route() =>
      MaterialPageRoute(builder: (_) => const LanguageScreen());

  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  final List<Map<String, dynamic>> languages = [
    {'name': 'English', 'code': 'en', 'locale': const Locale('en')},
    {'name': 'Urdu', 'code': 'ur', 'locale': const Locale('ur')},
    {'name': 'Arabic', 'code': 'ar', 'locale': const Locale('ar')},
  ];
  String selectedLanguage = "en";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadLanguage();
  }

  // Load the saved language
  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode =
        prefs.getString('languageCode') ?? 'en'; // Default to 'en'
    setState(() {
      selectedLanguage = languageCode;
      Get.updateLocale(Locale(languageCode)); // Set locale to saved language
    });
  }

  // Save the language
  Future<void> _saveLanguage(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', code); // Save language code
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorpallete.bgColor,
      appBar: AppBar(
        title: Text("select_language".tr), // Localized text
        foregroundColor: Colorpallete.appBarTextColor,
        backgroundColor: Colorpallete.backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var language in languages)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedLanguage = language['code'];
                      Get.updateLocale(language['locale']); // Change language
                      _saveLanguage(language['code']); // Save selected language
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: selectedLanguage == language['code']
                          ? Colorpallete.backgroundColor.withOpacity(0.4)
                          : Colorpallete.drawericonColor.withOpacity(0.4),
                      border: Border.all(
                        color: selectedLanguage == language['code']
                            ? Colorpallete.bottomNavigationColor
                            : Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      language['name'], // Show language name
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: selectedLanguage == language['code']
                            ? Colorpallete.bottomNavigationColor
                            : Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
