import 'package:daily_dairies/controllers/diary_controller.dart';
import 'package:daily_dairies/core/colorPallete.dart';
import 'package:daily_dairies/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class Tagscreen extends StatelessWidget {
  const Tagscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DiaryController controller = Get.find<DiaryController>();

    return Scaffold(
      backgroundColor: Colorpallete.bgColor,
      appBar: AppBar(
        title: const Text("Tag Management"),
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
          return const Center(child: Text('No tags in your diaries.'));
        }

        return ListView.builder(
          itemCount: tagMap.length,
          itemBuilder: (context, index) {
            final tag = tagMap.keys.elementAt(index);
            final count = tagMap[tag];

            return ListTile(
              title: Text('# $tag'),
              subtitle: Text('$count ${count == 1 ? 'entry' : 'entries'}'),
              onTap: () {
                context.go('/tagged/$tag');
              },
            );
          },
        );
      }),
    );
  }
}
