import 'package:daily_dairies/core/colorPallete.dart';
import 'package:flutter/material.dart';

class TotalDiaries extends StatelessWidget {
  const TotalDiaries({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage('assets/images/profile_screen_background.png',),
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
                'Keep writing diaries',
                style: TextStyle(fontSize: 18, color: Colorpallete.bgColor),
              ),
              IconButton(
                onPressed: () {},
                icon:  Icon(
                  Icons.share,
                  color: Colorpallete.bgColor
                ),
              ),
            ],
          ),
           Text(
            '5',
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold,color: Colorpallete.backgroundColor),
          ),
           Text(
            'A Diary Mean Yes Indeed',
            style: TextStyle(fontStyle: FontStyle.italic, fontSize: 20, color: Colorpallete.bgColor),
          ),
        ],
      ),
    );
  }
}
