import 'package:daily_dairies/controllers/diary_controller.dart';
import 'package:daily_dairies/core/colorPallete.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmojiBarChart extends StatefulWidget {
  const EmojiBarChart({super.key});

  @override
  State<EmojiBarChart> createState() => _EmojiBarChartState();
}

class _EmojiBarChartState extends State<EmojiBarChart> {
  final diaryController = Get.find<DiaryController>();
  String selectedFilter = "Last 7 days";

  final List<String> moodEmojis = [
    '😑',
    '😊',
    '😃',
    '😍',
    '😁',
    '😡',
    '😢',
    '😭',
    '😰',
    '😔',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colorpallete.backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title & Dropdown
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "mood_statistics".tr,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              DropdownButton<String>(
                borderRadius: BorderRadius.circular(8),
                elevation: 0,
                value: selectedFilter,
                dropdownColor: Colorpallete.bgColor.withOpacity(0.4),
                style: const TextStyle(color: Colors.white),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                items: ["Last 7 days", "Last 30 days", "Last 90 days", "All"]
                    .map((String filter) => DropdownMenuItem(
                          value: filter,
                          child: Text(filter),
                        ))
                    .toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedFilter = newValue!;
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Bar Chart wrapped in Obx
          Obx(() {
            final moodData =
                diaryController.moodStats[selectedFilter] ?? List.filled(10, 0);
            print("Rebuilding mood stats for $selectedFilter: ${moodData}");

            return SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(
                    border: const Border(
                      bottom: BorderSide(color: Colors.white, width: 1),
                      left: BorderSide(color: Colors.white, width: 1),
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        getTitlesWidget: (value, _) => Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        reservedSize: 28,
                        showTitles: true,
                        getTitlesWidget: (value, _) => Text(
                          moodEmojis[value.toInt()],
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  barGroups: List.generate(
                    moodData.length,
                    (index) => BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: moodData[index].toDouble(),
                          color: Colorpallete.bgColor,
                          width: 16,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
