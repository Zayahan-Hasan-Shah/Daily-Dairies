import 'package:daily_dairies/core/colorPallete.dart';
import 'package:daily_dairies/widgets/achievment_widget.dart';
import 'package:daily_dairies/widgets/app_drawer.dart';
import 'package:daily_dairies/widgets/profile_widgets/daily_Statistics.dart';
import 'package:daily_dairies/widgets/profile_widgets/emoji_barchart.dart';
import 'package:daily_dairies/widgets/profile_widgets/profile_section_widget.dart';
import 'package:daily_dairies/widgets/profile_widgets/total_diaries.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatefulWidget {
  static Route route() =>
      MaterialPageRoute(builder: (_) => const ProfileScreen());
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ProfileSectionWidget(),
              SizedBox(
                height: 16,
              ),
              TotalDiaries(),
              SizedBox(
                height: 16,
              ),
              EmojiBarChart(),
              SizedBox(
                height: 16,
              ),
              Achievments(),
              SizedBox(
                height: 16,
              ),
              DailyStatistics(),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
