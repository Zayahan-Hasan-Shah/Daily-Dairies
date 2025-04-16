import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_dairies/core/colorPallete.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:daily_dairies/controllers/diary_controller.dart';

class TotalDiaries extends StatefulWidget {
  const TotalDiaries({super.key});

  @override
  State<TotalDiaries> createState() => _TotalDiariesState();
}

class _TotalDiariesState extends State<TotalDiaries> {
  final DiaryController _diaryController = Get.find<DiaryController>();
  final RxInt diaryCount = 0.obs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchDiaryCount();
    });
  }

  Future<void> _fetchDiaryCount() async {
    try {
      final userId = _diaryController.userId;

      if (userId == null) {
        diaryCount.value = 0;
        return;
      }

      var snapshot = await FirebaseFirestore.instance
          .collection('diaries')
          .where('userId', isEqualTo: userId)
          .get();

      diaryCount.value = snapshot.docs.length;
    } catch (e) {
      print("Error fetching diary count: $e");
      diaryCount.value = 0;
    }
  }

  Future<void> _shareImage() async {
    try {
      final ByteData data =
          await rootBundle.load('assets/images/profile_screen_background.png');
      final List<int> bytes = data.buffer.asUint8List();

      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/profile_screen_background.png');

      await file.writeAsBytes(bytes);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: "i_have_written_diaries"
            .trParams({'count': diaryCount.value.toString()}),
      );
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
                'keep_writing_diaries'.tr,
                style: TextStyle(fontSize: 18, color: Colorpallete.bgColor),
              ),
              IconButton(
                onPressed: _shareImage,
                icon: Icon(Icons.share, color: Colorpallete.bgColor),
              ),
            ],
          ),
          Obx(() => Text(
                _diaryController.userId == null ? '0' : '${diaryCount.value}',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colorpallete.backgroundColor,
                ),
              )),
          Text(
            'diary_motto'.tr,
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 20,
              color: Colorpallete.bgColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    diaryCount.close();
    super.dispose();
  }
}
