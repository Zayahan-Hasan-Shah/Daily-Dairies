import 'package:daily_dairies/core/colorPallete.dart';
import 'package:daily_dairies/widgets/faq_widgets/get_started.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:easy_localization/easy_localization.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorpallete.bgColor,
      appBar: AppBar(
        title:
            Text("faq_title".tr, style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white), // Blue arrow
        backgroundColor: Colorpallete.backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sectionTitle("get_started".tr),
              faqItem("start_diary".tr, '/getstarteddiary'),
              faqItem("diary_ideas".tr, '/getdiaryideas'),
              sectionTitle("lock_privacy".tr),
              faqItem("set_diary_lock".tr, '/setdiarylock'),
              faqItem("forget_password".tr, '/forgetpassword'),
              faqItem("data_privacy".tr, '/dataprivacy'),
              sectionTitle("backup_restore".tr),
              faqItem("backup_failed".tr, '/backupfailed'),
              faqItem("get_backedup_data".tr, '/getyourbackedupdata'),
              sectionTitle("manage_entries".tr),
              faqItem("tag_management".tr, '/tagmanagment'),
              sectionTitle("other".tr),
              faqItem("other_questions".tr, '/otherquestions'),
            ],
          ),
        ),
      ),
    );
  }

  Widget sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget faqItem(String text, String route) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colorpallete.backgroundColor.withOpacity(0.4),
      ),
      child: GetStartedWidget(
        text: text,
        route: route,
        iconColor: Colors.blue,
      ),
    );
  }
}
