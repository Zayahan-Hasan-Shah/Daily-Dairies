import 'package:daily_dairies/core/colorPallete.dart';
import 'package:daily_dairies/widgets/achievment_widget.dart';
import 'package:flutter/material.dart';

class Achievmentscreen extends StatelessWidget {
  const Achievmentscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorpallete.bgColor,
      appBar: AppBar(
        title: const Text("Achievments"),
        foregroundColor: Colorpallete.bottomNavigationColor,
        backgroundColor: Colorpallete.backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Achievments(),
          ],
        ),
      ),
    );
  }
}
