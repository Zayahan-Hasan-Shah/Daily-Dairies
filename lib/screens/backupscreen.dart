import 'package:daily_dairies/controllers/backup_controller.dart';
import 'package:daily_dairies/core/colorPallete.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class BackupAndRestoreScreen extends StatelessWidget {
  BackupAndRestoreScreen({super.key});

  final BackupController controller = Get.put(BackupController());

  void _showReminderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Reminder Interval',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                fontWeight: FontWeight.w400),
          ),
          content: Container(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<String>(
                  title: Text('Every day'),
                  value: 'Every day',
                  groupValue: controller.selectedReminderInterval.value,
                  onChanged: (value) {
                    controller.setReminderInterval(value!);
                    Navigator.pop(context);
                  },
                  activeColor: Colors.blue,
                ),
                RadioListTile<String>(
                  title: Text('3 days'),
                  value: '3 days',
                  groupValue: controller.selectedReminderInterval.value,
                  onChanged: (value) {
                    controller.setReminderInterval(value!);
                    Navigator.pop(context);
                  },
                  activeColor: Colors.blue,
                ),
                RadioListTile<String>(
                  title: Text('4 days'),
                  value: '4 days',
                  groupValue: controller.selectedReminderInterval.value,
                  onChanged: (value) {
                    controller.setReminderInterval(value!);
                    Navigator.pop(context);
                  },
                  activeColor: Colors.blue,
                ),
                RadioListTile<String>(
                  title: Text('5 days'),
                  value: '5 days',
                  groupValue: controller.selectedReminderInterval.value,
                  onChanged: (value) {
                    controller.setReminderInterval(value!);
                    Navigator.pop(context);
                  },
                  activeColor: Colors.blue,
                ),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(10), // Customizable border radius
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Select', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => (context).go('/'),
        ),
        title: const Text('Backup and Restore'),
        actions: [
          IconButton(
            icon: Icon(Icons.question_answer_outlined,
                color: Colorpallete.drawericonColor),
            onPressed: () => context.go('/faq'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          // Google Drive Backup
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                // borderRadius: BorderRadius.circular(12),
              ),
              // padding: const EdgeInsets.all(16),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text('G', style: TextStyle(color: Colors.white)),
                ),
                title: Text('Backup to Google Drive'),
                subtitle: Text('Tap to login'),
                onTap: () {
                  // Implement Google Drive login
                },
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Backup Data Section - Disabled
          Container(
            // color: Colors.grey[200],
            decoration: BoxDecoration(
                border: Border.symmetric(
                    horizontal: BorderSide(
              color: Colors.grey.shade200,
            ))),
            child: ListTile(
              enabled: false,
              title: Text('Backup Data',
                  style: TextStyle(color: Colors.grey[600])),
              subtitle:
                  Text('Haven\'t synced', style: TextStyle(color: Colors.grey)),
            ),
          ),

          const SizedBox(height: 16),

          // Auto Backup with Premium Icon
          Container(
            decoration: BoxDecoration(
                border: Border.symmetric(
                    horizontal: BorderSide(
              color: Colors.grey.shade200,
            ))),
            child: ListTile(
              title: Row(
                children: [
                  Text('Auto Backup',
                      style: TextStyle(color: Colors.grey[600])),
                  const SizedBox(width: 8),
                  Icon(Icons.workspace_premium,
                      color: Colors.amber[700], size: 20),
                ],
              ),
              subtitle: Text(
                  'Enable Auto Backup to prevent forgetting diary synchronization',
                  style: TextStyle(color: Colors.grey[600])),
              trailing: Obx(() => Switch(
                    value: controller.isAutoBackupEnabled.value,
                    onChanged: controller.toggleAutoBackup,
                    activeColor: Colors.blue,
                    inactiveThumbColor: Colors.blue,
                    inactiveTrackColor: Colors.grey[200],
                  )),
            ),
          ),

          const SizedBox(height: 16),

          // Restore Data Section - Disabled
          Container(
            // color: Colors.grey[200],
            decoration: BoxDecoration(
                border: Border.symmetric(
                    horizontal: BorderSide(
              color: Colors.grey.shade200,
            ))),
            child: ListTile(
              enabled: false,
              title: Text('Restore Data',
                  style: TextStyle(color: Colors.grey[600])),
            ),
          ),

          const SizedBox(height: 16),

          // More Backup Account Expandable Section
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                // borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ListTile(
                    title: Text('More Backup Account'),
                    trailing: Obx(() => Icon(
                          controller.isBackupAccountExpanded.value
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                        )),
                    onTap: controller.toggleBackupAccountExpanded,
                  ),
                  Obx(() => controller.isBackupAccountExpanded.value
                      ? Column(
                          children: [
                            ListTile(
                              leading: Icon(Icons.cloud),
                              title: Text('Dropbox'),
                              onTap: () {
                                // Implement Dropbox connection
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.cloud),
                              title: Text('OneDrive'),
                              onTap: () {
                                // Implement OneDrive connection
                              },
                            ),
                          ],
                        )
                      : SizedBox.shrink()),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Backup Reminder with Popup
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                // borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text('Backup Reminder'),
                subtitle:
                    Obx(() => Text(controller.selectedReminderInterval.value)),
                onTap: () => _showReminderDialog(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
