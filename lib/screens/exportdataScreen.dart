import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/export_controller.dart';
import '../core/colorPallete.dart';

class ExportScreen extends StatelessWidget {
  final ExportController controller = Get.put(ExportController());

  ExportScreen({Key? key}) : super(key: key);

  void _showFileSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colorpallete.backgroundColor,
          title: const Text(
            'Select Export Duration',
            style: TextStyle(
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
                _buildFileSelectionRadioTile('All Files'),
                _buildFileSelectionRadioTile('Last 7 Days'),
                _buildFileSelectionRadioTile('Last 30 Days'),
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

  Widget _buildFileSelectionRadioTile(String value) {
    return Obx(
      () => RadioListTile<String>(
        title: Text(value, style: TextStyle(color: Colors.white)),
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
        title: const Text('Export Data'),
        backgroundColor: Colorpallete.bgColor,
      ),
      backgroundColor: Colorpallete.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text('Select Export Duration',
                  style: TextStyle(color: Colorpallete.textColor)),
              trailing: Obx(() => Text(
                    controller.selectedExportDuration.value,
                    style: TextStyle(color: Colors.white70),
                  )),
              onTap: () => _showFileSelectionDialog(context),
            ),
            const SizedBox(height: 20),
            _exportOption(
                "Export to .TXT", "Only text will be exported", false),
            const SizedBox(height: 15),
            _exportOption("Export to .PDF", "Include pictures", true),
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
            onPressed: () {},
            child: const Text("EXPORT"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colorpallete.backgroundColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:permission_handler/permission_handler.dart';
// import '../../controller/export_controller.dart';
// import '../../utils/colorpallete.dart';

// class ExportScreen extends StatelessWidget {
//   final ExportController controller = Get.put(ExportController());

//   ExportScreen({Key? key}) : super(key: key);

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
//                 fontSize: 15,
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
//               child: const Text('Select', style: TextStyle(color: Colors.white)),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildFileSelectionRadioTile(String value) {
//     return Obx(
//       () => RadioListTile<String>(
//         title: Text(value, style: TextStyle(color: Colors.white)),
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
//         backgroundColor: Colorpallete.primaryColor,
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
//                     style: TextStyle(color: Colors.white70),
//                   )),
//               onTap: () => _showFileSelectionDialog(context),
//             ),
//             const SizedBox(height: 20),
//             _exportOption("Export to .TXT", "Only text will be exported", false, () => controller.exportToTxt()),
//             const SizedBox(height: 15),
//             _exportOption("Export to .PDF", "Include pictures", true, () => controller.exportToPdf()),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _exportOption(String title, String subtitle, bool isPremium, VoidCallback onExport) {
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
//                   Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
//                   if (isPremium)
//                     const Icon(Icons.star, color: Colors.amber, size: 16),
//                 ],
//               ),
//               Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
//             ],
//           ),
//           ElevatedButton(
//             onPressed: onExport,
//             child: const Text("EXPORT"),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colorpallete.primaryColor,
//               foregroundColor: Colors.white,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
