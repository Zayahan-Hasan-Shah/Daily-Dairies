import 'package:daily_dairies/core/colorPallete.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/theme_controller.dart';
import '../models/theme_color_model.dart';

class ThemeScreen extends StatefulWidget {
  const ThemeScreen({super.key});

  @override
  State<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  final ThemeController _themeController = Get.find<ThemeController>();

  // @override
  // void initState() {
  //   super.initState();
  //   // Select the first theme by default if none is selected
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     if (_themeController.selectedTheme.value.appBarColor ==
  //             const Color.fromRGBO(28, 50, 91, 1) &&
  //         _themeController.selectedTheme.value.bodyColor ==
  //             const Color.fromRGBO(132, 166, 230, 1)) {
  //       _themeController.setTheme(themeColorList[0]);
  //     }
  //   });
  // }
  // final DummyController dummy = Get.put(DummyController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedTheme = _themeController.selectedTheme.value;
      return Scaffold(
        backgroundColor: Colorpallete.bgColor,
        appBar: AppBar(
          title: const Text("Theme Color"),
          foregroundColor: Colorpallete.appBarTextColor,
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
                              "Select moods ${groupIndex + 1}",
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

  final List<ThemeColorModel> themeColorList = [
    ThemeController.defaultTheme,
    ThemeColorModel(
      appBarColor: const Color.fromRGBO(142, 125, 190, 1),
      bodyColor: const Color.fromRGBO(228, 177, 240, 1),
    ),
    ThemeColorModel(
      appBarColor: const Color.fromRGBO(114, 191, 120, 1),
      bodyColor: const Color.fromRGBO(254, 255, 159, 1),
    ),
    ThemeColorModel(
      appBarColor: const Color.fromRGBO(100, 130, 173, 1),
      bodyColor: const Color.fromRGBO(225, 170, 116, 1),
    ),
    ThemeColorModel(
      appBarColor: const Color.fromRGBO(53, 66, 89, 1),
      bodyColor: const Color.fromRGBO(236, 229, 199, 1),
    ),
    ThemeColorModel(
      appBarColor: const Color.fromRGBO(73, 54, 40, 1),
      bodyColor: const Color.fromRGBO(228, 234, 225, 1),
    ),
    ThemeColorModel(
      appBarColor: const Color.fromRGBO(142, 22, 22, 1),
      bodyColor: const Color.fromRGBO(216, 64, 64, 1),
    ),
    ThemeColorModel(
      appBarColor: const Color.fromRGBO(236, 82, 40, 1),
      bodyColor: const Color.fromRGBO(239, 150, 81, 1),
    ),
    ThemeColorModel(
      appBarColor: const Color.fromRGBO(87, 73, 100, 1),
      bodyColor: const Color.fromRGBO(255, 218, 179, 1),
    ),
  ];
}

// class DummyController extends GetxController {
//   var count = 0.obs;
// }
