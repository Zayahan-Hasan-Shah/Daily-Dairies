import 'package:daily_dairies/controllers/diary_controller.dart';
import 'package:daily_dairies/core/colorPallete.dart';
import 'package:daily_dairies/widgets/achievment_widget.dart';
import 'package:daily_dairies/widgets/profile_widgets/daily_Statistics.dart';
import 'package:daily_dairies/widgets/profile_widgets/emoji_barchart.dart';
import 'package:daily_dairies/widgets/profile_widgets/sign_in_widget.dart';
import 'package:daily_dairies/widgets/profile_widgets/total_diaries.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:daily_dairies/controllers/diary_controller.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  static Route route() =>
      MaterialPageRoute(builder: (_) => const ProfileScreen());
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final DiaryController _diaryController = Get.find<DiaryController>();

  @override
  void initState() {
    super.initState();
    _diaryController.fetchEntries();
  }

  @override
  void initState() {
    super.initState();
    // Ensure DiaryController is initialized
    try {
      Get.find<DiaryController>();
    } catch (e) {
      Get.put(DiaryController());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorpallete.bgColor,
      appBar: AppBar(
        title: const Text("Mine"),
        foregroundColor: Colorpallete.bottomNavigationColor,
        backgroundColor: Colorpallete.backgroundColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.pushReplacement('/settings');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SignInWidget(),
              const SizedBox(
                height: 16,
              ),
              const TotalDiaries(),
              const SizedBox(
                height: 16,
              ),
              const EmojiBarChart(),
              const SizedBox(
                height: 16,
              ),
              const Achievements(),
              const SizedBox(
                height: 16,
              ),
              DailyStatistics(entries: _diaryController.entries.toList()),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
