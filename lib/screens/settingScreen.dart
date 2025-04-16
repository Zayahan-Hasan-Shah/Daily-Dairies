import 'package:daily_dairies/core/colorPallete.dart';
import 'package:daily_dairies/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class Settingscreen extends StatelessWidget {
  const Settingscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorpallete.bgColor,
      appBar: AppBar(
        title: Text(
          "settings".tr, // Localized text
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colorpallete.backgroundColor,
        elevation: 5,
        shadowColor: Colors.black54,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
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
            _buildSectionTitle("general".tr), // General Section
            _buildSettingItem("mood_style".tr, Icons.emoji_emotions_outlined,
                '/moodstylemanagment', context),
            _buildSettingItem(
                "tag".tr, Icons.tag_outlined, '/tagmanagement', context),
            _buildSettingItem("diary_lock".tr, Icons.lock_outline_sharp,
                '/diarylock', context),
            _buildSettingItem("export_diary".tr, Icons.backup_outlined,
                '/exportdata', context),
            const SizedBox(height: 20),
            _buildSectionTitle("about".tr), // About Section
            _buildSettingItem("language".tr, Icons.language_outlined,
                '/lanaguagemanagement', context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
          color: Colors.white, // White font color
        ),
      ),
    );
  }

  Widget _buildSettingItem(
      String text, IconData icon, String route, BuildContext context) {
    return Card(
      color: Colorpallete.backgroundColor.withOpacity(0.6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(icon, size: 28, color: Colors.blue), // Icons in blue
        title: Text(
          text,
          style: const TextStyle(
              fontSize: 18, color: Colors.white), // Text in white
        ),
        trailing: const Icon(Icons.arrow_forward_ios,
            color: Colors.blue, size: 18), // Arrow in blue
        onTap: () {
          context.push(route); // Use GoRouter for navigation
        },
      ),
    );
  }
}
