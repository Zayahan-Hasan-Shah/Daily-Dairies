import 'package:daily_dairies/controllers/diary_controller.dart';
import 'package:daily_dairies/core/colorPallete.dart';
import 'package:daily_dairies/screens/diaryDetailScreen.dart';
import 'package:daily_dairies/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Tagscreen extends StatelessWidget {
  const Tagscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DiaryController controller = Get.find<DiaryController>();

    return Scaffold(
      backgroundColor: Colorpallete.bgColor,
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text("tag_management".tr),
        foregroundColor: Colorpallete.bottomNavigationColor,
        backgroundColor: Colorpallete.backgroundColor,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: Obx(() {
        final tagMap = controller.tagCounts;

        if (tagMap.isEmpty) {
          return Center(child: Text('no_tags_in_diaries'.tr));
        }

        return ListView.builder(
          itemCount: tagMap.length,
          itemBuilder: (context, index) {
            final entry = controller.entries[index];
            final tag = tagMap.keys.elementAt(index);
            final count = tagMap[tag];

            // return ListTile(
            //   title: Text('# $tag'),
            //   subtitle: Text('$count ${count == 1 ? 'entry' : 'entries'}'),
            //   onTap: () {
            //     context.go('/tagged/$tag');
            //   },
            // );

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    DiaryDetailScreen.route(
                      id: entry.id,
                      title: entry.title,
                      content: entry.content,
                      mood: entry.mood,
                      tags: entry.tags,
                      date: entry.date,
                      images: entry.images ?? [],
                      videos: entry.videos ?? [],
                      audioRecordings: entry.audioRecordings ?? [],
                      bulletPoints: entry.bulletPoints ?? [],
                      textColor: entry.textColor ?? Colors.black,
                      textStyle: entry.textStyle ??
                          const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                    ),
                  ).then((_) {
                    // Use post frame callback for refresh after navigation
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      controller.refreshEntries();
                    });
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colorpallete.drawericonColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tag,
                        style: TextStyle(
                          color: Colorpallete.textColor,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        '$count ${count == 1 ? 'entry'.tr : 'entries'.tr}',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colorpallete.bgColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
