import 'package:daily_dairies/core/colorPallete.dart';
import 'package:daily_dairies/widgets/app_drawer.dart';
import 'package:flutter/material.dart';

class Tagscreen extends StatelessWidget {
  const Tagscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorpallete.bgColor,
      appBar: AppBar(
        title: const Text("Set Diary Lock"),
        foregroundColor: Colorpallete.bottomNavigationColor,
        backgroundColor: Colorpallete.backgroundColor,
        // Add this to show the drawer icon
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      drawer: AppDrawer(),
      // body: ,
    );
  }
}
