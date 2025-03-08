import 'package:daily_dairies/core/colorPallete.dart';
import 'package:daily_dairies/dummyData/dummData.dart';
import 'package:daily_dairies/screens/addDiaryScreen.dart';
import 'package:daily_dairies/screens/diaryDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  static Route route() => MaterialPageRoute(builder: (_) => CalendarScreen());
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  // Method to filter diaries based on selected date
  List<Map<String, dynamic>> _getDiariesForSelectedDate() {
    String formattedSelectedDate =
        DateFormat('dd-MM-yyyy').format(_selectedDay);
    return dummyData
        .where((entry) => entry['date'] == formattedSelectedDate)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> selectedDiaries = _getDiariesForSelectedDate();

    return Scaffold(
      backgroundColor: Colorpallete.bgColor, // Match your background color
      appBar: AppBar(
        title: const Text("Calendar"),
        foregroundColor: Colorpallete.bottomNavigationColor,
        backgroundColor: Colorpallete.backgroundColor,
        elevation: 0,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FloatingActionButton(
          backgroundColor: Colorpallete.bottomNavigationColor.withOpacity(0.4),
          elevation: 0,
          onPressed: () {
            Navigator.push(context, AddDiaryScreen.route());
          },
          child: RippleAnimation(
            color: Colorpallete.backgroundColor,
            minRadius: 10,
            maxRadius: 32,
            delay: const Duration(milliseconds: 320),
            repeat: true,
            ripplesCount: 5,
            duration: const Duration(milliseconds: 6 * 360),
            child: Icon(
              Icons.add,
              color: Colorpallete.backgroundColor,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TableCalendar(
              firstDay: DateTime(2000),
              lastDay: DateTime(2300),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  String formattedDay = DateFormat('dd-MM-yyyy').format(day);

                  // Find the most recent diary for the given day
                  var diariesForDay = dummyData
                      .where((entry) => entry['date'] == formattedDay)
                      .toList();

                  if (diariesForDay.isNotEmpty) {
                    // Get the most recent diary
                    var recentDiary = diariesForDay.last;

                    return Center(
                      child: Text(
                        recentDiary['emoji'], // Show emoji instead of the date
                        style: const TextStyle(fontSize: 24),
                      ),
                    );
                  }

                  // If no diary exists, show the default day number
                  return Center(
                    child: Text(
                      '${day.day}',
                      style: TextStyle(
                        color: Colorpallete.backgroundColor,
                        fontSize: 16,
                      ),
                    ),
                  );
                },
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  color: Colorpallete.backgroundColor,
                ),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(color: Colorpallete.backgroundColor),
                weekendStyle: const TextStyle(color: Colors.red),
              ),
              calendarStyle: CalendarStyle(
                outsideTextStyle:
                    TextStyle(color: Colorpallete.backgroundColor),
                selectedDecoration: BoxDecoration(
                  color: Colorpallete.backgroundColor,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colorpallete.backgroundColor.withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
                defaultTextStyle: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  color: Colorpallete.backgroundColor,
                ),
                weekendTextStyle: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  color: Colorpallete.backgroundColor,
                ),
              ),
            ),

            SizedBox(height: 20),
            Text(
              "${DateFormat('EEEE, yyyy-MM-dd').format(_selectedDay.toLocal())} ${DateFormat('dd-MM-yyyy').format(_selectedDay.toLocal())}",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
                color: Colorpallete.backgroundColor,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 20),

            // Displaying filtered diaries
            Expanded(
              child: selectedDiaries.isEmpty
                  ? Center(
                      child: Text(
                        "",
                        style: TextStyle(
                          color: Colorpallete.backgroundColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: selectedDiaries.length,
                      itemBuilder: (context, index) {
                        var diary = selectedDiaries[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              DiaryDetailScreen.route(
                                dummyData[index]["title"],
                                dummyData[index]["description"],
                                dummyData[index]["emoji"],
                                DateFormat("dd-MM-yyyy")
                                    .parse(dummyData[index]["date"]),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colorpallete.drawericonColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      diary['date']!,
                                      style: TextStyle(
                                        color: Colorpallete.textColor,
                                        fontSize: 22,
                                      ),
                                    ),
                                    Text(diary['emoji']),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  diary['title'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colorpallete.textColor,
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
