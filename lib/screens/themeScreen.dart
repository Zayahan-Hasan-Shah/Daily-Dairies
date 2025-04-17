import 'package:daily_dairies/core/colorPallete.dart';
import 'package:flutter/material.dart';

class ThemeScreen extends StatefulWidget {
  const ThemeScreen({super.key});

  @override
  State<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  int? selectedThemeIndex;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorpallete.bgColor.withOpacity(0.3),
      appBar: AppBar(
        title: const Text("Theme Color"),
        foregroundColor: Colorpallete.bottomNavigationColor,
        backgroundColor: Colorpallete.backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: themeColorList.length,
          itemBuilder: (context, groupIndex) {
            final themeGroup = themeColorList[groupIndex];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                height: 100,
                padding: const EdgeInsets.all(4),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      themeGroup['themeAppBarColor1'],
                      themeGroup['themeBodyColor1'],
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    // Radio button for the entire emoji group
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Radio<int>(
                          value: groupIndex,
                          groupValue: selectedThemeIndex,
                          onChanged: (int? value) {
                            setState(() {
                              selectedThemeIndex =
                                  value; // Set the selected group index
                            });
                          },
                          activeColor: Colorpallete.bgColor,
                        ),
                        Container(
                          child: Text(
                            "Select moods ${groupIndex + 1}", // Label for the group
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  final List<Map<dynamic, dynamic>> themeColorList = [
    {
      "id": 1,
      "themeAppBarColor1": Color.fromRGBO(28, 50, 91, 1),
      "themeBodyColor1": Color.fromRGBO(132, 166, 230, 1),
    },
    {
      "id": 2,
      "themeAppBarColor1": Color.fromRGBO(142, 125, 190, 1),
      "themeBodyColor1": Color.fromRGBO(228, 177, 240, 1),
    },
    {
      "id": 3,
      "themeAppBarColor1": Color.fromRGBO(114, 191, 120, 1),
      "themeBodyColor1": Color.fromRGBO(254, 255, 159, 1),
    },
    {
      "id": 4,
      "themeAppBarColor1": Color.fromRGBO(100, 130, 173, 1),
      "themeBodyColor1": Color.fromRGBO(245, 237, 237, 1),
    },
    {
      "id": 5,
      "themeAppBarColor1": Color.fromRGBO(53, 66, 89, 1),
      "themeBodyColor1": Color.fromRGBO(236, 229, 199, 1),
    },
    {
      "id": 6,
      "themeAppBarColor1": Color.fromRGBO(73, 54, 40, 1),
      "themeBodyColor1": Color.fromRGBO(228, 234, 225, 1),
    },
    {
      "id": 7,
      "themeAppBarColor1": Color.fromRGBO(142, 22, 22, 1),
      "themeBodyColor1": Color.fromRGBO(216, 64, 64, 1).withOpacity(0.6),
    },
    {
      "id": 8,
      "themeAppBarColor1": Color.fromRGBO(236, 82, 40, 1),
      "themeBodyColor1": Color.fromRGBO(239, 150, 81, 1),
    },
  ];
}
