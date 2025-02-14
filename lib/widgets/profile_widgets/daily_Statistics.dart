import 'package:daily_dairies/core/colorPallete.dart';
import 'package:flutter/material.dart';

class DailyStatistics extends StatefulWidget {
  const DailyStatistics({super.key});

  @override
  State<DailyStatistics> createState() => _DailyStatisticsState();
}

class _DailyStatisticsState extends State<DailyStatistics> {
  List<int> diaryEntries = [0, 3, 1, 1, 4, 0, 0]; // Example data
  List<String> days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
  String dateRange = "2/9 - 2/15"; // Default Date Range

  void changeDateRange(String newRange) {
    setState(() {
      dateRange = newRange;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colorpallete.backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Header Row (Title + Filter)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Diary Statistics',
                style: TextStyle(fontSize: 18, color: Colorpallete.bgColor),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_left, color: Colors.white),
                    onPressed: () {
                      changeDateRange("2/2 - 2/8"); // Example change
                    },
                  ),
                  Text(
                    dateRange,
                    style: TextStyle(fontSize: 14, color: Colorpallete.bgColor),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_right, color: Colors.white),
                    onPressed: () {
                      changeDateRange("2/16 - 2/22"); // Example change
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Circular Day Statistics
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(days.length, (index) {
              bool hasEntries = diaryEntries[index] > 0;
              return Column(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: hasEntries
                          ? Colorpallete.bgColor
                          : Colors.transparent,
                      border: Border.all(color: Colors.white, width: 1),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      diaryEntries[index].toString(),
                      style: TextStyle(
                        fontSize: 16,
                        color: hasEntries ? Colors.black : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    days[index],
                    style: TextStyle(color: Colorpallete.bgColor, fontSize: 14),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
