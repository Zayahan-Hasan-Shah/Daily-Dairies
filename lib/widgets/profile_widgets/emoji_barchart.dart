import 'package:daily_dairies/core/colorPallete.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class EmojiBarChart extends StatefulWidget {
  const EmojiBarChart({super.key});

  @override
  State<EmojiBarChart> createState() => _EmojiBarChartState();
}

class _EmojiBarChartState extends State<EmojiBarChart> {
  String selectedFilter = "Last 7 days";

  // Mood Data (Counts for each mood in different filters)
  final Map<String, List<int>> moodData = {
    "Last 7 days": [4, 0, 0, 0, 0, 1, 0, 0, 0, 0],
    "Last 30 days": [8, 3, 2, 5, 6, 4, 7, 3, 2, 4],
    "Last 90 days": [12, 5, 4, 8, 10, 6, 9, 4, 3, 7],
    "All": [20, 10, 15, 12, 18, 14, 16, 9, 5, 11]
  };

  final List<String> moodEmojis = [
    "🙂",
    "😊",
    "😁",
    "🥰",
    "☺️",
    "😌",
    "😡",
    "😢",
    "😞",
    "🤢"
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Mood Statistics",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
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

          // Bar Chart
          SizedBox(
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
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
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
                  moodData[selectedFilter]!.length,
                  (index) => BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: moodData[selectedFilter]![index].toDouble(),
                        color: Colorpallete.bgColor,
                        width: 16,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
