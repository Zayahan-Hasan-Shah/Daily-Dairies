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
       
        title: const Text("FAQ"),
        foregroundColor: Colorpallete.bottomNavigationColor,
        backgroundColor: Colorpallete.backgroundColor,
        // Add this to show the drawer icon
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Get Started',
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
              child: const GetStartedWidget(
                  text: 'Start a diary',
                  route: '/getstarteddiary'),
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
              child: const GetStartedWidget(
                  text: 'Get diary ideas',
                  route: '/getstarteddiary'),
            ),
            const SizedBox(
              height: 6,
            ),
            Text(
              'Lock and Privacy Protection',
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
              child: const GetStartedWidget(
                  text: 'Set diary lock',
                  route: '/setdiarylock'),
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
              child: const GetStartedWidget(
                  text: 'Forget password',
                  route: '/setdiarylock'),
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
              child: const GetStartedWidget(
                  text: 'Data privacy',
                  route: '/setdiarylock'),
            ),
            const SizedBox(
              height: 6,
            ),
            Text(
              'Backup and Restore',
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
              child: const GetStartedWidget(
                  text: 'Backup Failed',
                  route: '/backupfailed'),
            ),
            const SizedBox(
              height: 6,
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
              child: const GetStartedWidget(
                  text: 'Get your backed-up data',
                  route: '/getyourbackedupdata'),
            ),
            const SizedBox(
              height: 6,
            ),
            Text(
              'Manage Entries',
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
              child: const GetStartedWidget(
                  text: 'Tag management',
                  route: '/tagmanagment'),
            ),
            const SizedBox(
              height: 6,
            ),
            Text(
              'Other',
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
              child: const GetStartedWidget(
                  text: 'Other questions',
                  route: '/otherquestions'),
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
