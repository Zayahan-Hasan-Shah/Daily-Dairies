import 'package:daily_dairies/core/colorPallete.dart';
import 'package:flutter/material.dart';

class GetDiaryIdeasScreen extends StatelessWidget {
  const GetDiaryIdeasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorpallete.bgColor,
      appBar: AppBar(
        actions: const [
          Padding(
            padding: EdgeInsets.all(16),
            child: Icon(Icons.warning_rounded),
          )
        ],
        title: const Text("FAQs"),
        foregroundColor: Colorpallete.bottomNavigationColor,
        backgroundColor: Colorpallete.backgroundColor,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: 6,
            ),
            Text(
              maxLines: 4,
              'How to start my own diary if I don\'t know what to write about',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 6,
            ),
            SizedBox(
              height: 6,
            ),
            Text(
              maxLines: 4,
              '-Diaries can help you to record your unique experience and stories, you can write about your thoughts, places you want to go, stories you\'ve watched, or express your negative emotions.',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
