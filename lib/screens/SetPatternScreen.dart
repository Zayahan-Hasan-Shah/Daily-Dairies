import 'package:flutter/material.dart';
import 'package:pattern_lock/pattern_lock.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:daily_dairies/core/colorPallete.dart';

class SetPatternScreen extends StatefulWidget {
  const SetPatternScreen({super.key});

  @override
  State<SetPatternScreen> createState() => _SetPatternScreenState();
}

class _SetPatternScreenState extends State<SetPatternScreen> {
  List<int>? _pattern;

  void _savePattern(List<int> pattern) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('diary_pattern', pattern.join(','));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorpallete.bgColor,
      appBar: AppBar(
        title: const Text("Set Pattern Lock"),
        foregroundColor: Colorpallete.bottomNavigationColor,
        backgroundColor: Colorpallete.backgroundColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Draw a pattern to lock your diary",
            style: TextStyle(
              color: Colorpallete.textColor,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: SizedBox(
              width: 300,
              height: 300,
              child: PatternLock(
                selectedColor: Colorpallete.bottomNavigationColor,
                notSelectedColor: Colorpallete.drawericonColor,
                pointRadius: 10,
                showInput: true,
                fillPoints: true,
                onInputComplete: (List<int> pattern) {
                  setState(() {
                    _pattern = pattern;
                  });
                  _savePattern(pattern);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
