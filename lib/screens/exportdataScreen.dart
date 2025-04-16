// import 'package:daily_dairies/widgets/export_widget/export_diary_pdf.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controllers/export_controller.dart';
// import '../core/colorPallete.dart';

// class ExportScreen extends StatelessWidget {
//   final ExportController controller = Get.put(ExportController());
//   final ExportDiaryPdf exportDiaryPdf = ExportDiaryPdf();

//   ExportScreen({super.key});

//   void _showFileSelectionDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Colorpallete.backgroundColor,
//           title: const Text(
//             'Select Export Duration',
//             style: TextStyle(
//                 fontFamily: 'Poppins',
//                 fontStyle: FontStyle.italic,
//                 fontSize: 18,
//                 fontWeight: FontWeight.w400,
//                 color: Colors.white),
//           ),
//           content: SizedBox(
//             width: double.infinity,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 _buildFileSelectionRadioTile('All Files'),
//                 _buildFileSelectionRadioTile('Last 7 Days'),
//                 _buildFileSelectionRadioTile('Last 30 Days'),
//               ],
//             ),
//           ),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child:
//                   const Text('Select', style: TextStyle(color: Colors.white)),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildFileSelectionRadioTile(String value) {
//     return Obx(
//       () => RadioListTile<String>(
//         title: Text(value, style: const TextStyle(color: Colors.white)),
//         value: value,
//         groupValue: controller.selectedExportDuration.value,
//         onChanged: (val) {
//           controller.selectedExportDuration.value = val!;
//           Get.back();
//         },
//         activeColor: Colorpallete.bgColor,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Export Data'),
//         backgroundColor: Colorpallete.bgColor,
//       ),
//       backgroundColor: Colorpallete.backgroundColor,
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ListTile(
//               title: Text('Select Export Duration',
//                   style: TextStyle(color: Colorpallete.textColor)),
//               trailing: Obx(() => Text(
//                     controller.selectedExportDuration.value,
//                     style: const TextStyle(color: Colors.white70),
//                   )),
//               onTap: () => _showFileSelectionDialog(context),
//             ),
//             const SizedBox(height: 20),
//             _exportOption(
//                 "Export to .TXT", "Only text will be exported", false),
//             const SizedBox(height: 15),
//             _exportOption("Export to .PDF", "Include pictures", true),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _exportOption(String title, String subtitle, bool isPremium) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Text(title,
//                       style: const TextStyle(fontWeight: FontWeight.bold)),
//                   if (isPremium)
//                     const Icon(Icons.star, color: Colors.amber, size: 16),
//                 ],
//               ),
//               Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
//             ],
//           ),
//           ElevatedButton(
//             onPressed: () {},
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colorpallete.backgroundColor,
//               foregroundColor: Colors.white,
//             ),
//             child: const Text("EXPORT"),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:permission_handler/permission_handler.dart';
// // import '../../controller/export_controller.dart';
// // import '../../utils/colorpallete.dart';

// // class ExportScreen extends StatelessWidget {
// //   final ExportController controller = Get.put(ExportController());

// //   ExportScreen({Key? key}) : super(key: key);

// //   void _showFileSelectionDialog(BuildContext context) {
// //     showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return AlertDialog(
// //           backgroundColor: Colorpallete.backgroundColor,
// //           title: const Text(
// //             'Select Export Duration',
// //             style: TextStyle(
// //                 fontFamily: 'Poppins',
// //                 fontSize: 15,
// //                 fontWeight: FontWeight.w400,
// //                 color: Colors.white),
// //           ),
// //           content: SizedBox(
// //             width: double.infinity,
// //             child: Column(
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 _buildFileSelectionRadioTile('All Files'),
// //                 _buildFileSelectionRadioTile('Last 7 Days'),
// //                 _buildFileSelectionRadioTile('Last 30 Days'),
// //               ],
// //             ),
// //           ),
// //           shape: RoundedRectangleBorder(
// //             borderRadius: BorderRadius.circular(10),
// //           ),
// //           actions: [
// //             TextButton(
// //               onPressed: () => Navigator.pop(context),
// //               child: const Text('Select', style: TextStyle(color: Colors.white)),
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }

// //   Widget _buildFileSelectionRadioTile(String value) {
// //     return Obx(
// //       () => RadioListTile<String>(
// //         title: Text(value, style: TextStyle(color: Colors.white)),
// //         value: value,
// //         groupValue: controller.selectedExportDuration.value,
// //         onChanged: (val) {
// //           controller.selectedExportDuration.value = val!;
// //           Get.back();
// //         },
// //         activeColor: Colorpallete.bgColor,
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Export Data'),
// //         backgroundColor: Colorpallete.primaryColor,
// //       ),
// //       backgroundColor: Colorpallete.backgroundColor,
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             ListTile(
// //               title: Text('Select Export Duration',
// //                   style: TextStyle(color: Colorpallete.textColor)),
// //               trailing: Obx(() => Text(
// //                     controller.selectedExportDuration.value,
// //                     style: TextStyle(color: Colors.white70),
// //                   )),
// //               onTap: () => _showFileSelectionDialog(context),
// //             ),
// //             const SizedBox(height: 20),
// //             _exportOption("Export to .TXT", "Only text will be exported", false, () => controller.exportToTxt()),
// //             const SizedBox(height: 15),
// //             _exportOption("Export to .PDF", "Include pictures", true, () => controller.exportToPdf()),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _exportOption(String title, String subtitle, bool isPremium, VoidCallback onExport) {
// //     return Container(
// //       padding: const EdgeInsets.all(12),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(8),
// //       ),
// //       child: Row(
// //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //         children: [
// //           Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Row(
// //                 children: [
// //                   Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
// //                   if (isPremium)
// //                     const Icon(Icons.star, color: Colors.amber, size: 16),
// //                 ],
// //               ),
// //               Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
// //             ],
// //           ),
// //           ElevatedButton(
// //             onPressed: onExport,
// //             child: const Text("EXPORT"),
// //             style: ElevatedButton.styleFrom(
// //               backgroundColor: Colorpallete.primaryColor,
// //               foregroundColor: Colors.white,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import '../controllers/export_controller.dart';
import '../core/colorPallete.dart';
import '../widgets/export_widget/export_diary_pdf.dart'; // Import the ExportDiaryPdf class

class ExportScreen extends StatelessWidget {
  final ExportController controller = Get.put(ExportController());
  final ExportDiaryPdf exportDiaryPdf =
      ExportDiaryPdf(); // Create an instance of ExportDiaryPdf

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  ExportScreen({super.key}) {
    _initializeNotifications();
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'diary_export_channel', // Channel ID
      'Diary Export Notifications', // Channel name
      channelDescription: 'Notifications for diary export events',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      title,
      body,
      platformChannelSpecifics,
      payload: 'Diary Exported',
    );
  }

  void _showFileSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colorpallete.backgroundColor,
          title: Text(
            'Select Export Duration'.tr,
            style: const TextStyle(
                fontFamily: 'Poppins',
                fontStyle: FontStyle.italic,
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.white),
          ),
          content: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildFileSelectionRadioTile('All Files'.tr),
                _buildFileSelectionRadioTile('Last 7 Days'.tr),
                _buildFileSelectionRadioTile('Last 30 Days'.tr),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Select'.tr,
                  style: const TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFileSelectionRadioTile(String value) {
    return Obx(
      () => RadioListTile<String>(
        title: Text(value, style: const TextStyle(color: Colors.white)),
        value: value,
        groupValue: controller.selectedExportDuration.value,
        onChanged: (val) {
          controller.selectedExportDuration.value = val!;
          Get.back();
        },
        activeColor: Colorpallete.bgColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Export Data'.tr),
        backgroundColor: Colorpallete.bgColor,
      ),
      backgroundColor: Colorpallete.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text('Select Export Duration'.tr,
                  style: TextStyle(color: Colorpallete.textColor)),
              trailing: Obx(() => Text(
                    controller.selectedExportDuration.value,
                    style: const TextStyle(color: Colors.white70),
                  )),
              onTap: () => _showFileSelectionDialog(context),
            ),
            const SizedBox(height: 20),
            _exportOption(
                'Export to .TXT'.tr, 'Only text will be exported'.tr, false),
            const SizedBox(height: 15),
            _exportOption('Export to .PDF'.tr, 'Include pictures'.tr, true),
          ],
        ),
      ),
    );
  }

  Widget _exportOption(String title, String subtitle, bool isPremium) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(title,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  if (isPremium)
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                ],
              ),
              Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
            ],
          ),
          ElevatedButton(
            onPressed: () async {
              if (isPremium) {
                await exportDiaryPdf.printDiaryPDF();
                // Show notification after export
                _showNotification("Export Successful",
                    "Your diary has been exported successfully.");
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colorpallete.backgroundColor,
              foregroundColor: Colors.white,
            ),
            child: Text('EXPORT'.tr),
          ),
        ],
      ),
    );
  }
}
