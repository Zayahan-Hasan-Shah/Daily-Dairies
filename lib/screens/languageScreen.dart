import 'package:flutter/material.dart';
import 'package:daily_dairies/core/colorPallete.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  final List<Map<String, String>> languages = [
    {'name': 'English', 'code': 'en'},
    {'name': 'Urdu', 'code': 'ur'},
    {'name': 'French', 'code': 'fr'},
    {'name': 'Spanish', 'code': 'es'},
    {'name': 'Arabic', 'code': 'ar'},
    {'name': 'German', 'code': 'de'},
    {'name': 'Chinese', 'code': 'zh'},
    {'name': 'Japanese', 'code': 'ja'},
    {'name': 'Russian', 'code': 'ru'},
  ];

  String selectedLanguage = 'en'; // Default selected language

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorpallete.bgColor,
      appBar: AppBar(
        title: const Text("Select Language"),
        foregroundColor: Colorpallete.bottomNavigationColor,
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
                      selectedLanguage = language['code']!;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: selectedLanguage == language['code']
                          ? Colorpallete.backgroundColor
                          : Colorpallete.drawericonColor.withOpacity(0.4),
                      border: Border.all(
                        color: selectedLanguage == language['code']
                            ? Colorpallete.bottomNavigationColor
                            : Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      language['name']!,
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
