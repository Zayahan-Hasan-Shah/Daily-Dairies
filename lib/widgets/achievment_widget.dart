import 'package:daily_dairies/core/colorPallete.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';

class Achievements extends StatelessWidget {
  const Achievements({super.key});

  final List<Map<String, String>> achievements = const [
    {'name': 'diary_apprentice', 'image': 'assets/images/achievemnet1.png'},
    {'name': 'will_power', 'image': 'assets/images/achievemnet1.png'},
    {'name': 'growing_strong', 'image': 'assets/images/achievemnet1.png'},
    {'name': 'diary_talent', 'image': 'assets/images/achievemnet1.png'},
    {'name': 'mydiary_hero', 'image': 'assets/images/achievemnet1.png'},
    {'name': 'aesthetic_sense', 'image': 'assets/images/achievemnet1.png'},
    {'name': 'modern_generation', 'image': 'assets/images/achievemnet1.png'},
    {'name': 'creative_mind', 'image': 'assets/images/achievemnet1.png'},
    {'name': 'daily_thinker', 'image': 'assets/images/achievemnet1.png'},
    {'name': 'memories_keeper', 'image': 'assets/images/achievemnet1.png'},
    {'name': 'thoughtful_writer', 'image': 'assets/images/achievemnet1.png'},
    {'name': 'story_weaver', 'image': 'assets/images/achievemnet1.png'},
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
          /// Title & More Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'achievements'.tr,
                style: TextStyle(fontSize: 20, color: Colorpallete.bgColor),
              ),
              GestureDetector(
                onTap: () {
                  context.push('/achievements', extra: achievements);
                },
                child: Text(
                  'more'.tr,
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

          /// First 3 achievements
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

class AchievementBadge extends StatelessWidget {
  final String name;
  final String imagePath;

  const AchievementBadge({
    super.key,
    required this.name,
    required this.imagePath,
  });

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
            name.tr,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colorpallete.textColor),
          ),
        ),
      ],
    );
  }
}
