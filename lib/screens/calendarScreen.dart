import 'package:daily_dairies/core/colorPallete.dart';
import 'package:daily_dairies/screens/addDiaryScreen.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorpallete.bgColor, // Match your background color
      appBar: AppBar(
        title: Text("Calendar"),
        foregroundColor: Colorpallete.bottomNavigationColor,
        backgroundColor: Colorpallete.backgroundColor,
        elevation: 0,
      ),
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
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(
                    fontSize: 20, color: Colorpallete.backgroundColor),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(color: Colorpallete.backgroundColor),
                weekendStyle: TextStyle(color: Colors.redAccent),
              ),
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Colorpallete.backgroundColor,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colorpallete.backgroundColor.withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
                defaultTextStyle: TextStyle(
                    fontSize: 16, color: Colorpallete.backgroundColor),
                weekendTextStyle: TextStyle(
                    fontSize: 16, color: Colorpallete.backgroundColor),
              ),
            ),
            SizedBox(height: 20),
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colorpallete.backgroundColor.withOpacity(0.4),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
