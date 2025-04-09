import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ExportController extends GetxController {
  var selectedExportDuration = 'All Files'.obs;

  void exportData() {
    DateTime? startDate;
    DateTime now = DateTime.now();

    switch (selectedExportDuration.value) {
      case 'Last 7 Days':
        startDate = now.subtract(const Duration(days: 7));
        break;
      case 'Last 30 Days':
        startDate = now.subtract(const Duration(days: 30));
        break;
      case 'All Files':
      default:
        startDate = null; // Export all files without filtering
        break;
    }

    // Format the start date if needed
    String formattedStartDate =
        startDate != null ? DateFormat('yyyy-MM-dd').format(startDate) : 'All';

    // Simulate export process
    print("Exporting data from: $formattedStartDate");

    // Call actual export function with the filtered data (to be implemented)
  }
}

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/widgets.dart' as pdfWidgets;
// import 'package:pdf/pdf.dart';

// class ExportController extends GetxController {
//   var selectedExportDuration = "All Files".obs;

//   Future<void> requestPermission() async {
//     if (await Permission.storage.request().isGranted) {
//       return;
//     } else {
//       Get.snackbar("Permission Denied", "Storage permission is required to export files.");
//     }
//   }

//   Future<void> exportToTxt() async {
//     await requestPermission();

//     try {
//       final Directory? directory = await getExternalStorageDirectory();
//       if (directory == null) {
//         Get.snackbar("Error", "Could not access storage directory.");
//         return;
//       }

//       final String filePath = '${directory.path}/exported_data.txt';
//       final File file = File(filePath);
//       await file.writeAsString("Sample exported text data for ${selectedExportDuration.value}");

//       Get.snackbar("Success", "File exported successfully to: $filePath");
//     } catch (e) {
//       Get.snackbar("Error", "Failed to export data: $e");
//     }
//   }

//   Future<void> exportToPdf() async {
//     await requestPermission();

//     try {
//       final Directory? directory = await getExternalStorageDirectory();
//       if (directory == null) {
//         Get.snackbar("Error", "Could not access storage directory.");
//         return;
//       }

//       final pdfWidgets.Document pdf = pdfWidgets.Document();

//       pdf.addPage(
//         pdfWidgets.Page(
//           pageFormat: PdfPageFormat.a4,
//           build: (pdfWidgets.Context context) {
//             return pdfWidgets.Center(
//               child: pdfWidgets.Text("Sample exported PDF data for ${selectedExportDuration.value}"),
//             );
//           },
//         ),
//       );

//       final String filePath = '${directory.path}/exported_data.pdf';
//       final File file = File(filePath);
//       await file.writeAsBytes(await pdf.save());

//       Get.snackbar("Success", "PDF exported successfully to: $filePath");
//     } catch (e) {
//       Get.snackbar("Error", "Failed to export PDF: $e");
//     }
//   }
// }
