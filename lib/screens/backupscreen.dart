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
          backgroundColor: Colorpallete.backgroundColor,
          title: Text(
            'reminder_interval'.tr,
            style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.white),
          ),
          content: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildRadioTile('every_day'.tr),
                _buildRadioTile('three_days'.tr),
                _buildRadioTile('four_days'.tr),
                _buildRadioTile('five_days'.tr),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('select'.tr,
                  style: const TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRadioTile(String value) {
    return Obx(
      () => RadioListTile<String>(
        title: Text(value, style: const TextStyle(color: Colors.white)),
        value: value,
        groupValue: controller.selectedReminderInterval.value,
        onChanged: (val) {
          controller.setReminderInterval(val!);
          Get.back();
        },
        activeColor: Colorpallete.bgColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorpallete.bgColor,
      appBar: AppBar(
        backgroundColor: Colorpallete.backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => (context).go('/'),
        ),
        title: Text('backup_and_restore'.tr,
            style: const TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.question_answer_outlined, color: Colors.white),
            onPressed: () => context.go('/faqs'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          _buildCard(
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colorpallete.bgColor,
                child: const Text('G', style: TextStyle(color: Colors.white)),
              ),
              title: Text('backup_to_google_drive'.tr,
                  style: TextStyle(color: Colorpallete.textColor)),
              subtitle: Text('tap_to_login'.tr,
                  style: TextStyle(color: Colorpallete.textColor)),
              onTap: () {},
            ),
          ),
          _disabledCard(_buildDisabledTile('backup_data'.tr, 'not_synced'.tr)),
          _disabledCard(_buildAutoBackupTile()),
          _disabledCard(_buildDisabledTile('restore_data'.tr, '')),
          _buildExpandableBackupAccount(),
          _buildBackupReminderTile(context),
        ],
      ),
    );
  }

  Widget _buildCard(Widget child) {
    return Card(
      color: Colorpallete.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: child,
    );
  }

  Widget _disabledCard(Widget child) {
    return Card(
      color: Colorpallete.disabledErrorColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: child,
    );
  }

  Widget _buildDisabledTile(String title, String subtitle) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.white)),
      enabled: false,
    );
  }

  Widget _buildAutoBackupTile() {
    return ListTile(
      title: Row(
        children: [
          Text('auto_backup'.tr,
              style: TextStyle(color: Colorpallete.textColor)),
          const SizedBox(width: 8),
          Icon(Icons.workspace_premium, color: Colors.amber[700], size: 20),
        ],
      ),
      subtitle: Text('auto_backup_description'.tr,
          style: TextStyle(color: Colorpallete.textColor)),
      trailing: Obx(() => Switch(
            value: controller.isAutoBackupEnabled.value,
            onChanged: controller.toggleAutoBackup,
            activeColor: Colorpallete.bgColor,
          )),
    );
  }

  Widget _buildExpandableBackupAccount() {
    return _buildCard(
      Column(
        children: [
          ListTile(
            title: Text('more_backup_account'.tr,
                style: TextStyle(color: Colorpallete.textColor)),
            trailing: Obx(() => Icon(
                  controller.isBackupAccountExpanded.value
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colorpallete.textColor,
                )),
            onTap: controller.toggleBackupAccountExpanded,
          ),
          Obx(
            () => controller.isBackupAccountExpanded.value
                ? Column(
                    children: [
                      _buildCloudTile('dropbox'.tr),
                      _buildCloudTile('onedrive'.tr),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildCloudTile(String name) {
    return ListTile(
      leading: Icon(Icons.cloud, color: Colorpallete.drawericonColor),
      title: Text(name, style: TextStyle(color: Colorpallete.textColor)),
      onTap: () {},
    );
  }

  Widget _buildBackupReminderTile(BuildContext context) {
    return _buildCard(
      ListTile(
        title: Text('backup_reminder'.tr,
            style: TextStyle(color: Colorpallete.textColor)),
        subtitle: Obx(() => Text(controller.selectedReminderInterval.value,
            style: TextStyle(color: Colorpallete.textColor))),
        onTap: () => _showReminderDialog(context),
      ),
    );
  }
}
