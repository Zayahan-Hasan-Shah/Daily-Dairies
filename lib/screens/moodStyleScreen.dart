import 'package:daily_dairies/core/colorPallete.dart';
import 'package:flutter/material.dart';

class Moodstylescreen extends StatefulWidget {
  const Moodstylescreen({super.key});

  @override
  _MoodstylescreenState createState() => _MoodstylescreenState();
}

class _MoodstylescreenState extends State<Moodstylescreen> {
  // Variable to track the selected group index
  int? selectedGroupIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorpallete.bgColor,
      appBar: AppBar(
        title: const Text("Mood Style"),
        foregroundColor: Colorpallete.appBarTextColor,
        backgroundColor: Colorpallete.backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: dummyEmojies.length,
          itemBuilder: (context, groupIndex) {
            final emojiGroup = dummyEmojies[groupIndex];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colorpallete.backgroundColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    // Radio button for the entire emoji group
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Radio<int>(
                          value: groupIndex,
                          groupValue: selectedGroupIndex,
                          onChanged: (int? value) {
                            setState(() {
                              selectedGroupIndex =
                                  value; // Set the selected group index
                            });
                          },
                          activeColor: Colorpallete.bgColor,
                        ),
                        Text(
                          "Select moods ${groupIndex + 1}", // Label for the group
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.center,
                      spacing: 12,
                      children: emojiGroup.map((emoji) {
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            emoji,
                            style: const TextStyle(fontSize: 24),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

final List<List<String>> dummyEmojies = [
  ["😃", "😄", "😁", "😆", "😅", "😂", "🥹", "😭", "😤", "😡"],
  ["😐", "😑", "🫨", "😦", "🫣", "🫠", "🥱", "😴", "😵", "😵‍💫"],
  ["🥵", "🤐", "🥴", "🤢", "🤮", "🤧", "😷", "🤒", "🤕", "🤑"],
  ['😈', '👹', '👺', '👻', '💀', '☠️', '👽', '🤡', '💩', '👾'],
  ['🐶', '🐱', '🐭', '🐼', '🐯', '🙊', '🐍', '🐰', '🐴', '🐧'],
  ['⚽', '🏏', '🎱', '🏉', '🏀', '🏑', '🏸', '🏓', '⚾', '🏹'],
];
