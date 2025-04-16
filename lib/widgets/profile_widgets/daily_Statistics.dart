// import 'package:daily_dairies/core/colorPallete.dart';
// import 'package:flutter/material.dart';

// class DailyStatistics extends StatefulWidget {
//   const DailyStatistics({super.key});

//   @override
//   State<DailyStatistics> createState() => _DailyStatisticsState();
// }

// class _DailyStatisticsState extends State<DailyStatistics> {
//   List<int> diaryEntries = [0, 3, 1, 1, 4, 0, 0]; // Example data
//   List<String> days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
//   String dateRange = "2/9 - 2/15"; // Default Date Range

//   void changeDateRange(String newRange) {
//     setState(() {
//       dateRange = newRange;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colorpallete.backgroundColor,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         children: [
//           // Header Row (Title + Filter)
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Diary Statistics',
//                 style: TextStyle(fontSize: 18, color: Colorpallete.bgColor),
//               ),
//               Row(
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.arrow_left, color: Colors.white),
//                     onPressed: () {
//                       changeDateRange("2/2 - 2/8"); // Example change
//                     },
//                   ),
//                   Text(
//                     dateRange,
//                     style: TextStyle(fontSize: 14, color: Colorpallete.bgColor),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.arrow_right, color: Colors.white),
//                     onPressed: () {
//                       changeDateRange("2/16 - 2/22"); // Example change
//                     },
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),

//           // Circular Day Statistics
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: List.generate(days.length, (index) {
//               bool hasEntries = diaryEntries[index] > 0;
//               return Column(
//                 children: [
//                   Container(
//                     width: 40,
//                     height: 40,
//                     decoration: BoxDecoration(
//                       color: hasEntries
//                           ? Colorpallete.bgColor
//                           : Colors.transparent,
//                       border: Border.all(color: Colors.white, width: 1),
//                       shape: BoxShape.circle,
//                     ),
//                     alignment: Alignment.center,
//                     child: Text(
//                       diaryEntries[index].toString(),
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: hasEntries ? Colors.black : Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     days[index],
//                     style: TextStyle(color: Colorpallete.bgColor, fontSize: 14),
//                   ),
//                 ],
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:daily_dairies/models/diary_entry.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:daily_dairies/core/colorPallete.dart';
import 'package:get/get.dart';

class DailyStatistics extends StatefulWidget {
  final List<DiaryEntry> entries;

  const DailyStatistics({super.key, required this.entries});

  @override
  State<DailyStatistics> createState() => _DailyStatisticsState();
}

class _DailyStatisticsState extends State<DailyStatistics> {
  late DateTime _startOfWeek;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _startOfWeek = now.subtract(Duration(days: now.weekday % 7));
  }

  void _changeWeek(int offsetDays) {
    setState(() {
      _startOfWeek = _startOfWeek.add(Duration(days: offsetDays));
    });
  }

  List<int> _getEntriesCountPerDay() {
    List<int> counts = List.filled(7, 0);
    for (var entry in widget.entries) {
      for (int i = 0; i < 7; i++) {
        DateTime day = _startOfWeek.add(Duration(days: i));
        if (_isSameDay(entry.createdAt, day)) {
          counts[i]++;
        }
      }
    }
    return counts;
  }

  String _getDateRangeString() {
    final formatter = DateFormat('M/d');
    final start = formatter.format(_startOfWeek);
    final end = formatter.format(_startOfWeek.add(const Duration(days: 6)));
    return "$start - $end";
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    final diaryEntries = _getEntriesCountPerDay();
    final days = [
      'sunday',
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday'
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colorpallete.backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'diary_statistics'.tr,
                  style: TextStyle(fontSize: 18, color: Colorpallete.bgColor),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_left, color: Colors.white),
                    onPressed: () => _changeWeek(-7),
                  ),
                  Text(
                    _getDateRangeString(),
                    style: TextStyle(fontSize: 14, color: Colorpallete.bgColor),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_right, color: Colors.white),
                    onPressed: () => _changeWeek(7),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Circular Day Statistics
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(7, (index) {
              final count = diaryEntries[index];
              final hasEntries = count > 0;

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
                      count.toString(),
                      style: TextStyle(
                        fontSize: 16,
                        color: hasEntries ? Colors.black : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    days[index].tr,
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
