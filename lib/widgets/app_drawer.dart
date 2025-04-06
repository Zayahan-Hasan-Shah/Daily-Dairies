import 'package:daily_dairies/core/colorPallete.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
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
              _buildDrawerItem(
                context,
                icon: Icons.home_outlined,
                text: 'home'.tr(),
                route: '/',
              ),
              _buildDrawerItem(
                context,
                icon: Icons.workspace_premium,
                text: 'upgrade_pro'.tr(),
                color: Colors.amber,
              ),
              _buildDrawerItem(
                context,
                icon: Icons.tag,
                text: 'tags'.tr(),
                route: '/tagmanagement',
              ),
              _buildDrawerItem(
                context,
                icon: Icons.lock,
                text: 'diary_lock'.tr(),
                onTap: () {
                  context.go('/diarylock');
                },
              ),
              _buildDrawerItem(
                context,
                icon: Icons.backup,
                text: 'backup_restore'.tr(),
                route: '/backup',
              ),
              _buildDrawerItem(
                context,
                icon: Icons.import_export,
                text: 'export_diary'.tr(),
                route: '/exportdata',
              ),
              _buildDrawerItem(
                context,
                icon: Icons.question_answer_outlined,
                text: 'faqs'.tr(),
                route: '/faqs',
              ),
              _buildDrawerItem(
                context,
                icon: Icons.facebook,
                text: 'follow_us'.tr(),
                onTap: () async {
                  final Uri url =
                      Uri.parse('https://www.facebook.com/TwitterInc/');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    _showError(context);
                  }
                },
              ),
              _buildDrawerItem(
                context,
                icon: Icons.apps,
                text: 'more_apps'.tr(),
                onTap: () async {
                  final Uri url =
                      Uri.parse('https://play.google.com/store/apps?hl=en');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    _showError(context);
                  }
                },
              ),
              _buildDrawerItem(
                context,
                icon: Icons.settings_accessibility_rounded,
                text: 'settings'.tr(),
                route: '/settings',
              ),
              _buildDrawerItem(
                context,
                icon: Icons.logout_outlined,
                text: 'logout'.tr(),
                route: '/login',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String text,
    String? route,
    Color? color,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colorpallete.drawericonColor),
      title: Text(
        text,
        style: TextStyle(color: Colorpallete.drawertextColor),
      ),
      onTap: () {
        if (route != null) {
          context.push(route);
        } else {
          onTap?.call();
        }
        Navigator.pop(context);
      },
    );
  }

  void _showError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('error_opening_page'.tr()),
      ),
    );
  }
}
