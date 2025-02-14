import 'package:daily_dairies/core/colorPallete.dart';
import 'package:daily_dairies/widgets/app_drawer.dart';
import 'package:daily_dairies/widgets/setting_widget/setting_widget.dart';
import 'package:flutter/material.dart';

class Settingscreen extends StatelessWidget {
  const Settingscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorpallete.bgColor,
      appBar: AppBar(
        title: const Text("Settings"),
        foregroundColor: Colorpallete.bottomNavigationColor,
        backgroundColor: Colorpallete.backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'General',
              style: TextStyle(
                fontSize: 20,
                color: Colorpallete.backgroundColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colorpallete.backgroundColor.withOpacity(0.4),
              ),
              child: SettingWidget(
                  text: 'Mood Style',
                  icon: Icon(Icons.emoji_emotions_outlined,
                      size: 28, color: Colorpallete.drawericonColor),
                  route: '/moodstylemanagment'),
            ),
            const SizedBox(
              height: 6,
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colorpallete.backgroundColor.withOpacity(0.4),
              ),
              child: SettingWidget(
                  text: 'Tag',
                  icon: Icon(Icons.tag_outlined,
                      size: 28, color: Colorpallete.drawericonColor),
                  route: '/tagmanagement'),
            ),
            const SizedBox(
              height: 6,
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colorpallete.backgroundColor.withOpacity(0.4),
              ),
              child: SettingWidget(
                  text: 'Diary Lock',
                  icon: Icon(Icons.lock_outline_sharp,
                      size: 28, color: Colorpallete.drawericonColor),
                  route: '/diarylock'),
            ),
            const SizedBox(
              height: 6,
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colorpallete.backgroundColor.withOpacity(0.4),
              ),
              child: SettingWidget(
                  text: 'Backup and Restore',
                  icon: Icon(Icons.backup_outlined,
                      size: 28, color: Colorpallete.drawericonColor),
                  route: '/backup'),
            ),
            const SizedBox(
              height: 6,
            ),
            Text(
              'About',
              style: TextStyle(
                fontSize: 20,
                color: Colorpallete.backgroundColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colorpallete.backgroundColor.withOpacity(0.4),
              ),
              child: SettingWidget(
                  text: 'Language',
                  icon: Icon(Icons.language_outlined,
                      size: 28, color: Colorpallete.drawericonColor),
                  route: '/lanaguagemanagement'),
            ),
            const SizedBox(
              height: 6,
            ),
          ],
        ),
      ),
    );
  }
}
