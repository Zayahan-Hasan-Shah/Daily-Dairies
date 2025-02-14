import 'package:daily_dairies/core/colorPallete.dart';
import 'package:daily_dairies/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingWidget extends StatelessWidget {
  final String text;
  final Icon icon;
  final String route;

  const SettingWidget({
    super.key,
    required this.text,
    required this.icon,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(route),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              icon,
              const SizedBox(
                width: 4,
              ),
              Text(
                text,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colorpallete.drawericonColor,
                ),
              ),
            ],
          ),
          Icon(
            Icons.arrow_circle_right_outlined,
            size: 32,
            color: Colorpallete.drawericonColor,
          ),
        ],
      ),
    );
  }
}
