import 'package:daily_dairies/core/colorPallete.dart';
import 'package:daily_dairies/screens/SetPatternScreen.dart';
import 'package:daily_dairies/screens/SetPinScreen.dart';
import 'package:daily_dairies/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DiarylockScreen extends StatefulWidget {
  static Route route() =>
      MaterialPageRoute(builder: (_) => const DiarylockScreen());
  const DiarylockScreen({super.key});

  @override
  State<DiarylockScreen> createState() => _DiarylockScreenState();
}

class _DiarylockScreenState extends State<DiarylockScreen> {
  bool isDiaryLockEnabled = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorpallete.bgColor,
      appBar: AppBar(
        title: const Text("Set Diary Lock"),
        foregroundColor: Colorpallete.bottomNavigationColor,
        backgroundColor: Colorpallete.backgroundColor,
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildToggleSwitch(),
            const SizedBox(
              height: 20,
            ),
            if (isDiaryLockEnabled) _buildLockOptions(context)
          ],
        ),
      ),
    );
  }

  Widget _buildToggleSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Diary Lock",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        Switch(
          value: isDiaryLockEnabled,
          activeColor: Colors.blue,
          activeTrackColor: Colorpallete.backgroundColor,
          inactiveThumbColor: Colors.blue,
          inactiveTrackColor: Colors.grey[200],
          onChanged: (bool value) {
            setState(() {
              isDiaryLockEnabled = value;
            });

            if (value) {
              _navigateToLockSetup();
            }
          },
        ),
      ],
    );
  }

  // Options to set lock type (Pattern/PIN)
  Widget _buildLockOptions(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: const Text("Set Pattern Lock",
              style: TextStyle(color: Colors.white)),
          trailing: const Icon(Icons.chevron_right, color: Colors.blue),
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const SetPatternScreen())),
        ),
        ListTile(
          title:
              const Text("Set PIN Code", style: TextStyle(color: Colors.white)),
          trailing: const Icon(Icons.chevron_right, color: Colors.blue),
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (_) => const SetPinScreen())),
        ),
      ],
    );
  }

  // Function to navigate to Pattern Lock setup
  void _navigateToLockSetup() {
    Future.delayed(const Duration(milliseconds: 300), () {
      context.push('/setPattern'); // Navigate to pattern lock setup
    });
  }
}
