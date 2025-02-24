import 'package:daily_dairies/core/colorPallete.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DiaryDetailScreen extends StatelessWidget {
  final String title;
  final String content;
  final String mood;
  final DateTime date;

  const DiaryDetailScreen({
    super.key,
    required this.title,
    required this.content,
    required this.mood,
    required this.date,
  });

  static Route route(String title, String content, String mood, DateTime date) {
    return MaterialPageRoute(
      builder: (context) => DiaryDetailScreen(
        title: title,
        content: content,
        mood: mood,
        date: date,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colorpallete.bottomNavigationColor,
        backgroundColor: Colorpallete.backgroundColor,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue.withOpacity(0.6),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                // Handle future editing logic
              },
              child: const Text("Edit"),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colorpallete.bgColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat("dd-MM-yyyy").format(date),
                      style: TextStyle(
                        fontSize: 18,
                        color: Colorpallete.backgroundColor,
                      ),
                    ),
                    Text(
                      mood,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colorpallete.textColor,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 300,
                  child: SingleChildScrollView(
                    child: Text(
                      content,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colorpallete.textColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: BottomAppBar(
        color: const Color.fromRGBO(28, 50, 91, 1),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _bottomBarButton(Icons.brush, "Style"),
              _bottomBarButton(Icons.image, "Image"),
              _bottomBarButton(Icons.star, "Favorite"),
              _bottomBarButton(Icons.emoji_emotions, "Mood"),
              _bottomBarButton(Icons.format_size, "Text"),
              _bottomBarButton(Icons.list, "List"),
              _bottomBarButton(Icons.label, "Tags"),
              _bottomBarButton(Icons.mic, "Voice"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomBarButton(IconData icon, String tooltip) {
    return IconButton(
      icon: Icon(icon, color: Colors.white),
      onPressed: () {
        // Placeholder action
      },
      tooltip: tooltip,
    );
  }
}
