import 'package:daily_dairies/core/colorPallete.dart';
import 'package:flutter/material.dart';

class ProfileSectionWidget extends StatelessWidget {
  const ProfileSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {},
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50), color: Colors.white),
              child: Icon(
                Icons.person,
                size: 40,
                color: Colorpallete.bgColor,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sign In',
                  style: TextStyle(
                    color: Colorpallete.backgroundColor,
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                const Text(
                  'Write diary everyday to remember ',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
