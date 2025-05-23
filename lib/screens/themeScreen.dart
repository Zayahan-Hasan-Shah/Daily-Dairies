import 'package:daily_dairies/core/colorPallete.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/theme_controller.dart';
import '../models/theme_color_model.dart';

class ThemeScreen extends StatelessWidget {
  const ThemeScreen({super.key});

  static const List<ThemeColorModel> themeColorList = [
    ThemeColorModel(
      appBarColor: Color.fromRGBO(28, 50, 91, 1),
      bodyColor: Color.fromRGBO(132, 166, 230, 1),
    ),
    ThemeColorModel(
      appBarColor: Color.fromRGBO(142, 125, 190, 1),
      bodyColor: Color.fromRGBO(228, 177, 240, 1),
    ),
    ThemeColorModel(
      appBarColor: Color.fromRGBO(114, 191, 120, 1),
      bodyColor: Color.fromRGBO(254, 255, 159, 1),
    ),
    ThemeColorModel(
      appBarColor: Color.fromRGBO(100, 130, 173, 1),
      bodyColor: Color.fromRGBO(245, 237, 237, 1),
    ),
    ThemeColorModel(
      appBarColor: Color.fromRGBO(53, 66, 89, 1),
      bodyColor: Color.fromRGBO(236, 229, 199, 1),
    ),
    ThemeColorModel(
      appBarColor: Color.fromRGBO(73, 54, 40, 1),
      bodyColor: Color.fromRGBO(228, 234, 225, 1),
    ),
    ThemeColorModel(
      appBarColor: Color.fromRGBO(142, 22, 22, 1),
      bodyColor: Color.fromRGBO(216, 64, 64, 1),
    ),
    ThemeColorModel(
      appBarColor: Color.fromRGBO(236, 82, 40, 1),
      bodyColor: Color.fromRGBO(239, 150, 81, 1),
    ),
    ThemeColorModel(
      appBarColor: Color.fromRGBO(87, 73, 100, 1),
      bodyColor: Color.fromRGBO(255, 218, 179, 1),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeController _themeController = Get.find<ThemeController>();

    return Obx(() {
      final selectedTheme = _themeController.selectedTheme.value;
      final backgroundColor = _themeController.backgroundColor.value;
      final bgColor = _themeController.bgColor.value;

      return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          title: Text('theme_color'.tr),
          foregroundColor: Colorpallete.appBarTextColor,
          backgroundColor: backgroundColor,
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
                        themeGroup.appBarColor,
                        themeGroup.bodyColor,
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Radio<int>(
                            value: groupIndex,
                            groupValue: themeColorList.indexWhere((theme) =>
                                theme.appBarColor ==
                                    selectedTheme.appBarColor &&
                                theme.bodyColor == selectedTheme.bodyColor),
                            onChanged: (int? value) {
                              if (value != null) {
                                _themeController
                                    .setTheme(themeColorList[value]);
                              }
                            },
                            activeColor: Colorpallete.bgColor,
                          ),
                          Container(
                            child: Text(
                              "${'select_mood'.tr} ${groupIndex + 1}",
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
    });
  }
}

// class DummyController extends GetxController {
//   var count = 0.obs;
// }
