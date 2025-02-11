import 'package:daily_dairies/core/colorPallete.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colorpallete.bgColor, // Dark blue background
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              padding: EdgeInsets.zero,
              child: Image.asset(
                'assets/images/md_logo.png',
                fit: BoxFit.cover,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.workspace_premium, color: Colors.amber),
              title: Text(
                'Upgrade to PRO',
                style: TextStyle(color: Colorpallete.drawertextColor),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.tag, color: Colorpallete.drawericonColor),
              title: Text(
                'Tags',
                style: TextStyle(color: Colorpallete.drawertextColor),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.lock, color: Colorpallete.drawericonColor),
              title: Text(
                'Diary Lock',
                style: TextStyle(color: Colorpallete.drawertextColor),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.backup, color: Colorpallete.drawericonColor),
              title: Text(
                'Backup & Restore',
                style: TextStyle(color: Colorpallete.drawertextColor),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.import_export,
                  color: Colorpallete.drawericonColor),
              title: Text(
                'Export Diary',
                style: TextStyle(color: Colorpallete.drawertextColor),
              ),
              onTap: () {},
            ),
            ListTile(
              leading:
                  Icon(Icons.facebook, color: Colorpallete.drawericonColor),
              title: Text(
                'Follow Us',
                style: TextStyle(color: Colorpallete.drawertextColor),
              ),
            ),
            ListTile(
              leading: Icon(Icons.apps, color: Colorpallete.drawericonColor),
              title: Text(
                'More Apps',
                style: TextStyle(color: Colorpallete.drawertextColor),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.settings_accessibility_rounded,
                  color: Colorpallete.drawericonColor),
              title: Text(
                'Settings',
                style: TextStyle(color: Colorpallete.drawertextColor),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.settings_accessibility_rounded,
                  color: Colorpallete.drawericonColor),
              title: Text(
                'Logout',
                style: TextStyle(color: Colorpallete.drawertextColor),
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
