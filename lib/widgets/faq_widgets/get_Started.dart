import 'package:daily_dairies/core/colorPallete.dart';
import 'package:daily_dairies/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GetStartedWidget extends StatelessWidget {
  final String text;
  final String route;

  const GetStartedWidget({
    super.key,
    required this.text,
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
