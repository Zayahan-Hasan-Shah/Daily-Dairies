import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_dairies/core/colorPallete.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

class TotalDiaries extends StatefulWidget {
  const TotalDiaries({super.key});

  @override
  State<TotalDiaries> createState() => _TotalDiariesState();
}

class _TotalDiariesState extends State<TotalDiaries> {
  int diaryCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchDiaryCount();
  }

  Future<void> _fetchDiaryCount() async {
    try {
      // Fetch diary count from Firestore
      // Assuming you have a "diaries" collection in Firebase
      var snapshot =
          await FirebaseFirestore.instance.collection('diaries').get();
      setState(() {
        diaryCount = snapshot.docs.length; // Get total document count
      });
    } catch (e) {
      print("Error fetching diary count: $e");
    }
  }

  // Share image functionality
  Future<void> _shareImage() async {
    try {
      // Load image from assets
      final ByteData data =
          await rootBundle.load('assets/images/profile_screen_background.png');
      final List<int> bytes = data.buffer.asUint8List();

      // Get the temporary directory
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/profile_screen_background.png');

      // Write the image bytes to a temporary file
      await file.writeAsBytes(bytes);

      // Share the file using the share_plus package
      await Share.shareXFiles([XFile(file.path)],
          text:
              "I'm using My Diary to capture all my thoughts and memories. Now, I'm sharing it with you.");
    } catch (e) {
      print("Error sharing image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: AssetImage(
            'assets/images/profile_screen_background.png',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Keep writing diaries',
                style: TextStyle(fontSize: 18, color: Colorpallete.bgColor),
              ),
              IconButton(
                onPressed: _shareImage, // Share image when button is pressed
                icon: Icon(Icons.share, color: Colorpallete.bgColor),
              ),
            ],
          ),
          Text(
            '$diaryCount', // Display the dynamic diary count
            style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colorpallete.backgroundColor),
          ),
          Text(
            'A Diary Means Yes Indeed',
            style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 20,
                color: Colorpallete.bgColor),
          ),
        ],
      ),
    );
  }
}
