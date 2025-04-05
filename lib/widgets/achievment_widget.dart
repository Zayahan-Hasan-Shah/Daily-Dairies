import 'package:daily_dairies/core/colorPallete.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Achievements extends StatelessWidget {
  const Achievements({super.key});

  final List<Map<String, String>> achievements = const [
    {'name': 'Diary Apprentice', 'image': 'assets/images/achievemnet1.png'},
    {'name': 'Will Power', 'image': 'assets/images/achievemnet1.png'},
    {'name': 'Growing Strong', 'image': 'assets/images/achievemnet1.png'},
    {'name': 'Diary Talent', 'image': 'assets/images/achievemnet1.png'},
    {'name': 'MyDiary Hero', 'image': 'assets/images/achievemnet1.png'},
    {'name': 'Aesthetic Sense', 'image': 'assets/images/achievemnet1.png'},
    {'name': 'Modern Generation', 'image': 'assets/images/achievemnet1.png'},
    {'name': 'Creative Mind', 'image': 'assets/images/achievemnet1.png'},
    {'name': 'Daily Thinker', 'image': 'assets/images/achievemnet1.png'},
    {'name': 'Memories Keeper', 'image': 'assets/images/achievemnet1.png'},
    {'name': 'Thoughtful Writer', 'image': 'assets/images/achievemnet1.png'},
    {'name': 'Story Weaver', 'image': 'assets/images/achievemnet1.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colorpallete.backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// **Title & More Button**
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Achievements',
                style: TextStyle(fontSize: 20, color: Colorpallete.bgColor),
              ),
              GestureDetector(
                onTap: () {
                  context.push('/achievements',
                      extra: achievements); // Navigate with data
                },
                child: Text(
                  'MORE',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Colorpallete.bgColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          /// **Show only first 3 achievements**
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: achievements
                .take(3)
                .map((ach) => AchievementBadge(
                      name: ach['name']!,
                      imagePath: ach['image']!,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

/// **Reusable Achievement Badge Widget**
class AchievementBadge extends StatelessWidget {
  final String name;
  final String imagePath;

  const AchievementBadge(
      {super.key, required this.name, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 64,
          width: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 80,
          child: Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colorpallete.textColor),
          ),
        ),
      ],
    );
  }
}
