// import 'package:daily_dairies/core/colorPallete.dart';
// import 'package:daily_dairies/widgets/achievment_widget.dart';
// import 'package:flutter/material.dart';

// class Achievmentscreen extends StatelessWidget {
//   const Achievmentscreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colorpallete.bgColor,
//       appBar: AppBar(
//         title: const Text("Achievments"),
//         foregroundColor: Colorpallete.bottomNavigationColor,
//         backgroundColor: Colorpallete.backgroundColor,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Achievments(),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:daily_dairies/core/colorPallete.dart';
import 'package:daily_dairies/widgets/achievment_widget.dart';
import 'package:flutter/material.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key, required this.achievements});

  final List<Map<String, String>> achievements;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorpallete.bgColor,
      appBar: AppBar(
        title: const Text('All Achievements'),
        backgroundColor: Colorpallete.backgroundColor,
        iconTheme: IconThemeData(color: Colorpallete.bgColor),
        foregroundColor: Colorpallete.appBarTextColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: achievements.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 3 items per row
            childAspectRatio: 0.8, // Adjust size
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            final achievement = achievements[index];
            return AchievementBadge(
              name: achievement['name']!,
              imagePath: achievement['image']!,
            );
          },
        ),
      ),
    );
  }
}
