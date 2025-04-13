import 'package:daily_dairies/controllers/diary_controller.dart';
import 'package:daily_dairies/core/colorPallete.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ExportDiaryPdf {
  Future<void> printDiaryPDF() async {
    final pdf = pw.Document();
    final controller = Get.find<DiaryController>();

    // Ensure diary entries are loaded
    if (controller.isLoading.value) {
      return; // or show a snackbar, etc.
    }

    // Fetch all diary entries for the logged-in user
    final entries = controller
        .entries; // Assuming this returns the entries for the logged-in user

    // Check if there are entries to export
    if (entries.isEmpty) {
      print("No diary entries found for export.");
      return; // Optionally, show a message to the user
    }

    // Add a page for each diary entry
    for (var entry in entries) {
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Container(
              decoration: pw.BoxDecoration(
                color: PdfColor.fromHex('#224a94'),
                borderRadius: pw.BorderRadius.circular(16),
              ),
              child: pw.Column(
                children: [
                  pw.Text(entry.title, style: pw.TextStyle(fontSize: 24)),
                  pw.SizedBox(height: 10),
                  pw.Text(entry.content, style: pw.TextStyle(fontSize: 12)),
                  pw.SizedBox(height: 20),
                  pw.Text("Mood: ${entry.mood}",
                      style: pw.TextStyle(fontSize: 12)),
                  pw.Text(
                      "Date: ${entry.date.toLocal().toString().split(' ')[0]}",
                      style: pw.TextStyle(fontSize: 12)),
                  pw.Divider(),
                ],
              ),
            );
          },
        ),
      );
    }

    // Save the PDF file in the documents directory
    // final output =
    //     await getApplicationDocumentsDirectory(); // Use getApplicationDocumentsDirectory
    // final file = File("${output.path}/diary_export.pdf");
    // await file.writeAsBytes(await pdf.save());
    Directory? downloadsDir;
    if (Platform.isAndroid) {
      downloadsDir = Directory('/storage/emulated/0/Download');
    } else {
      downloadsDir = await getApplicationDocumentsDirectory();
    }

    // Create a unique filename with timestamp
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${downloadsDir.path}/Exported_Diaries_$timestamp.pdf');

    // Save the PDF
    await file.writeAsBytes(await pdf.save());

    // Optional: Show success or open the file
    print("PDF saved at: ${file.path}");
  }
}
