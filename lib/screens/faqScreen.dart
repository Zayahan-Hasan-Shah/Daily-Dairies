import 'package:daily_dairies/core/colorPallete.dart';
import 'package:daily_dairies/widgets/faq_widgets/get_Started.dart';
import 'package:flutter/material.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorpallete.bgColor,
      appBar: AppBar(
        title: const Text("FAQ", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.blue), // Blue arrow
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
              sectionTitle('Get Started'),
              faqItem('Start a diary', '/getstarteddiary'),
              faqItem('Get diary ideas', '/getstarteddiary'),
              sectionTitle('Lock and Privacy Protection'),
              faqItem('Set diary lock', '/setdiarylock'),
              faqItem('Forget password', '/setdiarylock'),
              faqItem('Data privacy', '/setdiarylock'),
              sectionTitle('Backup and Restore'),
              faqItem('Backup Failed', '/backupfailed'),
              faqItem('Get your backed-up data', '/getyourbackedupdata'),
              sectionTitle('Manage Entries'),
              faqItem('Tag management', '/tagmanagment'),
              sectionTitle('Other'),
              faqItem('Other questions', '/otherquestions'),
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
          color: Colors.white, // White text
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
