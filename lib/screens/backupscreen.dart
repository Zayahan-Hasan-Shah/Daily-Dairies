// import 'package:daily_dairies/controllers/backup_controller.dart';
// import 'package:daily_dairies/core/colorPallete.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:go_router/go_router.dart';

// class BackupAndRestoreScreen extends StatelessWidget {
//   BackupAndRestoreScreen({super.key});

//   final BackupController controller = Get.put(BackupController());

//   void _showReminderDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Colors.white,
//           title: const Text(
//             'Reminder Interval',
//             style: TextStyle(
//                 fontFamily: 'Poppins',
//                 fontSize: 15,
//                 fontWeight: FontWeight.w400),
//           ),
//           content: SizedBox(
//             width: double.infinity,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 RadioListTile<String>(
//                   title: const Text('Every day'),
//                   value: 'Every day',
//                   groupValue: controller.selectedReminderInterval.value,
//                   onChanged: (value) {
//                     controller.setReminderInterval(value!);
//                     Navigator.pop(context);
//                   },
//                   activeColor: Colors.blue,
//                 ),
//                 RadioListTile<String>(
//                   title: const Text('3 days'),
//                   value: '3 days',
//                   groupValue: controller.selectedReminderInterval.value,
//                   onChanged: (value) {
//                     controller.setReminderInterval(value!);
//                     Navigator.pop(context);
//                   },
//                   activeColor: Colors.blue,
//                 ),
//                 RadioListTile<String>(
//                   title: const Text('4 days'),
//                   value: '4 days',
//                   groupValue: controller.selectedReminderInterval.value,
//                   onChanged: (value) {
//                     controller.setReminderInterval(value!);
//                     Navigator.pop(context);
//                   },
//                   activeColor: Colors.blue,
//                 ),
//                 RadioListTile<String>(
//                   title: const Text('5 days'),
//                   value: '5 days',
//                   groupValue: controller.selectedReminderInterval.value,
//                   onChanged: (value) {
//                     controller.setReminderInterval(value!);
//                     Navigator.pop(context);
//                   },
//                   activeColor: Colors.blue,
//                 ),
//               ],
//             ),
//           ),
//           shape: RoundedRectangleBorder(
//             borderRadius:
//                 BorderRadius.circular(10), // Customizable border radius
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context); // Close the dialog
//               },
//               child: const Text('Select', style: TextStyle(color: Colors.blue)),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => (context).go('/'),
//         ),
//         title: const Text('Backup and Restore'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.question_answer_outlined,
//                 color: Colorpallete.drawericonColor),
//             onPressed: () => context.go('/faq'),
//           ),
//         ],
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(10),
//         children: [
//           // Google Drive Backup
//           Card(
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             elevation: 2,
//             child: Container(
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 // borderRadius: BorderRadius.circular(12),
//               ),
//               // padding: const EdgeInsets.all(16),
//               child: ListTile(
//                 leading: const CircleAvatar(
//                   backgroundColor: Colors.blue,
//                   child: Text('G', style: TextStyle(color: Colors.white)),
//                 ),
//                 title: const Text('Backup to Google Drive'),
//                 subtitle: const Text('Tap to login'),
//                 onTap: () {
//                   // Implement Google Drive login
//                 },
//               ),
//             ),
//           ),

//           const SizedBox(height: 16),

//           // Backup Data Section - Disabled
//           Container(
//             // color: Colors.grey[200],
//             decoration: BoxDecoration(
//                 border: Border.symmetric(
//                     horizontal: BorderSide(
//               color: Colors.grey.shade200,
//             ))),
//             child: ListTile(
//               enabled: false,
//               title: Text('Backup Data',
//                   style: TextStyle(color: Colors.grey[600])),
//               subtitle:
//                   const Text('Haven\'t synced', style: TextStyle(color: Colors.grey)),
//             ),
//           ),

//           const SizedBox(height: 16),

//           // Auto Backup with Premium Icon
//           Container(
//             decoration: BoxDecoration(
//                 border: Border.symmetric(
//                     horizontal: BorderSide(
//               color: Colors.grey.shade200,
//             ))),
//             child: ListTile(
//               title: Row(
//                 children: [
//                   Text('Auto Backup',
//                       style: TextStyle(color: Colors.grey[600])),
//                   const SizedBox(width: 8),
//                   Icon(Icons.workspace_premium,
//                       color: Colors.amber[700], size: 20),
//                 ],
//               ),
//               subtitle: Text(
//                   'Enable Auto Backup to prevent forgetting diary synchronization',
//                   style: TextStyle(color: Colors.grey[600])),
//               trailing: Obx(() => Switch(
//                     value: controller.isAutoBackupEnabled.value,
//                     onChanged: controller.toggleAutoBackup,
//                     activeColor: Colors.blue,
//                     inactiveThumbColor: Colors.blue,
//                     inactiveTrackColor: Colors.grey[200],
//                   )),
//             ),
//           ),

//           const SizedBox(height: 16),

//           // Restore Data Section - Disabled
//           Container(
//             // color: Colors.grey[200],
//             decoration: BoxDecoration(
//                 border: Border.symmetric(
//                     horizontal: BorderSide(
//               color: Colors.grey.shade200,
//             ))),
//             child: ListTile(
//               enabled: false,
//               title: Text('Restore Data',
//                   style: TextStyle(color: Colors.grey[600])),
//             ),
//           ),

//           const SizedBox(height: 16),

//           // More Backup Account Expandable Section
//           Card(
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             elevation: 2,
//             child: Container(
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 // borderRadius: BorderRadius.circular(12),
//               ),
//               child: Column(
//                 children: [
//                   ListTile(
//                     title: const Text('More Backup Account'),
//                     trailing: Obx(() => Icon(
//                           controller.isBackupAccountExpanded.value
//                               ? Icons.keyboard_arrow_up
//                               : Icons.keyboard_arrow_down,
//                         )),
//                     onTap: controller.toggleBackupAccountExpanded,
//                   ),
//                   Obx(() => controller.isBackupAccountExpanded.value
//                       ? Column(
//                           children: [
//                             ListTile(
//                               leading: const Icon(Icons.cloud),
//                               title: const Text('Dropbox'),
//                               onTap: () {
//                                 // Implement Dropbox connection
//                               },
//                             ),
//                             ListTile(
//                               leading: const Icon(Icons.cloud),
//                               title: const Text('OneDrive'),
//                               onTap: () {
//                                 // Implement OneDrive connection
//                               },
//                             ),
//                           ],
//                         )
//                       : const SizedBox.shrink()),
//                 ],
//               ),
//             ),
//           ),

//           const SizedBox(height: 16),

//           // Backup Reminder with Popup
//           Card(
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             elevation: 2,
//             child: Container(
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 // borderRadius: BorderRadius.circular(12),
//               ),
//               child: ListTile(
//                 title: const Text('Backup Reminder'),
//                 subtitle:
//                     Obx(() => Text(controller.selectedReminderInterval.value)),
//                 onTap: () => _showReminderDialog(context),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

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
          title: const Text(
            'Reminder Interval',
            style: TextStyle(
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
                _buildRadioTile('Every day'),
                _buildRadioTile('3 days'),
                _buildRadioTile('4 days'),
                _buildRadioTile('5 days'),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:
                  const Text('Select', style: TextStyle(color: Colors.white)),
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
        // backgroundColor: Colorpallete.bottomNavigationColor,
        backgroundColor: Colorpallete.backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => (context).go('/'),
        ),
        title:
            const Text('Backup and Restore', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.question_answer_outlined, color: Colors.white),
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
              title: Text('Backup to Google Drive',
                  style: TextStyle(color: Colorpallete.textColor)),
              subtitle: Text('Tap to login',
                  style: TextStyle(color: Colorpallete.textColor)),
              onTap: () {},
            ),
          ),
          // _buildDisabledTile('Backup Data', 'Haven\'t synced'),
          _disabledCard(_buildDisabledTile('Backup Data', 'Haven\'t synced')),
          _disabledCard(_buildAutoBackupTile()),
          _disabledCard(_buildDisabledTile('Restore Data', '')),
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
          Text('Auto Backup', style: TextStyle(color: Colorpallete.textColor)),
          const SizedBox(width: 8),
          Icon(Icons.workspace_premium, color: Colors.amber[700], size: 20),
        ],
      ),
      subtitle: Text(
          'Enable Auto Backup to prevent forgetting diary synchronization',
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
            title: Text('More Backup Account',
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
                      _buildCloudTile('Dropbox'),
                      _buildCloudTile('OneDrive'),
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
        title: Text('Backup Reminder',
            style: TextStyle(color: Colorpallete.textColor)),
        subtitle: Obx(() => Text(controller.selectedReminderInterval.value,
            style: TextStyle(color: Colorpallete.textColor))),
        onTap: () => _showReminderDialog(context),
      ),
    );
  }
}
