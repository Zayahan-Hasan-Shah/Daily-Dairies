import 'package:daily_dairies/controllers/diary_controller.dart';
import 'package:daily_dairies/core/colorPallete.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EntriesByTagScreen extends StatelessWidget {
  final String tag;

  EntriesByTagScreen({required this.tag});

  final DiaryController _diaryController = Get.find<DiaryController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorpallete.bgColor,
      appBar: AppBar(
        title: Text('#$tag Entries'),
        foregroundColor: Colorpallete.appBarTextColor,
        backgroundColor: Colorpallete.backgroundColor,
      ),
      body: Obx(() {
        final taggedEntries = _diaryController.getEntriesByTag(tag);
        if (taggedEntries.isEmpty) {
          return const Center(child: Text('No entries with this tag'));
        }
        return ListView.builder(
          itemCount: taggedEntries.length,
          itemBuilder: (context, index) {
            final entry = taggedEntries[index];
            return ListTile(
              title: Text(entry.title),
              subtitle: Text(entry.content),
              trailing: Text(entry.mood ?? ''),
              onTap: () {
                // TODO: Open details or editing screen
              },
            );
          },
        );
      }),
    );
  }
}
