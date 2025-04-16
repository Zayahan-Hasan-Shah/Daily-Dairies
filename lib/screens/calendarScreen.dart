// import 'package:daily_dairies/core/colorPallete.dart';
// import 'package:daily_dairies/controllers/diary_controller.dart';
// import 'package:daily_dairies/screens/addDiaryScreen.dart';
// import 'package:daily_dairies/screens/diaryDetailScreen.dart';
// import 'package:flutter/material.dart';
// import 'package:simple_ripple_animation/simple_ripple_animation.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:intl/intl.dart';
// import 'package:get/get.dart';

// class CalendarScreen extends GetView<DiaryController> {
//   static Route route() => MaterialPageRoute(builder: (_) => CalendarScreen());

//   final Rx<DateTime> _selectedDay = DateTime.now().obs;
//   final Rx<DateTime> _focusedDay = DateTime.now().obs;
//   final Rx<CalendarFormat> _calendarFormat = CalendarFormat.month.obs;

//   CalendarScreen({super.key});

//   // Method to filter diaries based on selected date
//   List<dynamic> _getDiariesForSelectedDate() {
//     final selectedDate = DateFormat('yyyy-MM-dd').format(_selectedDay.value);
//     return controller.entries
//         .where((entry) =>
//             DateFormat('yyyy-MM-dd').format(entry.date) == selectedDate)
//         .toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colorpallete.bgColor,
//       appBar: AppBar(
//         title: const Text("Calendar"),
//         foregroundColor: Colorpallete.bottomNavigationColor,
//         backgroundColor: Colorpallete.backgroundColor,
//         elevation: 0,
//       ),
//       floatingActionButton: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: FloatingActionButton(
//           backgroundColor: Colorpallete.bottomNavigationColor.withOpacity(0.4),
//           elevation: 0,
//           onPressed: () {
//             Navigator.push(context, AddDiaryScreen.route()).then((_) {
//               controller.refreshEntries();
//             });
//           },
//           child: RippleAnimation(
//             color: Colorpallete.backgroundColor,
//             minRadius: 10,
//             maxRadius: 32,
//             delay: const Duration(milliseconds: 320),
//             repeat: true,
//             ripplesCount: 5,
//             duration: const Duration(milliseconds: 6 * 360),
//             child: Icon(
//               Icons.add,
//               color: Colorpallete.backgroundColor,
//             ),
//           ),
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Obx(() => TableCalendar(
//                   firstDay: DateTime(2000),
//                   lastDay: DateTime(2300),
//                   focusedDay: _focusedDay.value,
//                   calendarFormat: _calendarFormat.value,
//                   selectedDayPredicate: (day) =>
//                       isSameDay(_selectedDay.value, day),
//                   onDaySelected: (selectedDay, focusedDay) {
//                     _selectedDay.value = selectedDay;
//                     _focusedDay.value = focusedDay;
//                   },
//                   calendarBuilders: CalendarBuilders(
//                     defaultBuilder: (context, day, focusedDay) {
//                       final formattedDay = DateFormat('yyyy-MM-dd').format(day);

//                       // Find diaries for the given day
//                       final diariesForDay = controller.entries
//                           .where((entry) =>
//                               DateFormat('yyyy-MM-dd').format(entry.date) ==
//                               formattedDay)
//                           .toList();

//                       if (diariesForDay.isNotEmpty) {
//                         return Center(
//                           child: Text(
//                             diariesForDay.last.mood,
//                             style: const TextStyle(fontSize: 24),
//                           ),
//                         );
//                       }

//                       return Center(
//                         child: Text(
//                           '${day.day}',
//                           style: TextStyle(
//                             color: Colorpallete.backgroundColor,
//                             fontSize: 16,
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                   headerStyle: HeaderStyle(
//                     formatButtonVisible: false,
//                     titleCentered: true,
//                     titleTextStyle: TextStyle(
//                       fontSize: 20,
//                       fontFamily: 'Poppins',
//                       color: Colorpallete.backgroundColor,
//                     ),
//                   ),
//                   daysOfWeekStyle: DaysOfWeekStyle(
//                     weekdayStyle:
//                         TextStyle(color: Colorpallete.backgroundColor),
//                     weekendStyle: const TextStyle(color: Colors.red),
//                   ),
//                   calendarStyle: CalendarStyle(
//                     outsideTextStyle:
//                         TextStyle(color: Colorpallete.backgroundColor),
//                     selectedDecoration: BoxDecoration(
//                       color: Colorpallete.backgroundColor,
//                       shape: BoxShape.circle,
//                     ),
//                     todayDecoration: BoxDecoration(
//                       color: Colorpallete.backgroundColor.withOpacity(0.7),
//                       shape: BoxShape.circle,
//                     ),
//                     defaultTextStyle: TextStyle(
//                       fontSize: 16,
//                       fontFamily: 'Poppins',
//                       color: Colorpallete.backgroundColor,
//                     ),
//                     weekendTextStyle: TextStyle(
//                       fontSize: 16,
//                       fontFamily: 'Poppins',
//                       color: Colorpallete.backgroundColor,
//                     ),
//                   ),
//                 )),

//             const SizedBox(height: 20),
//             Obx(() => Text(
//                   DateFormat('EEEE, MMMM d, yyyy').format(_selectedDay.value),
//                   style: TextStyle(
//                     fontWeight: FontWeight.w600,
//                     fontStyle: FontStyle.italic,
//                     color: Colorpallete.backgroundColor,
//                     fontSize: 16,
//                   ),
//                 )),
//             const SizedBox(height: 20),

//             // Displaying filtered diaries
//             Expanded(
//               child: Obx(() {
//                 if (controller.isLoading.value) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 final selectedDiaries = _getDiariesForSelectedDate();

//                 if (selectedDiaries.isEmpty) {
//                   return Center(
//                     child: Text(
//                       "No entries for this date",
//                       style: TextStyle(
//                         color: Colorpallete.backgroundColor,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   );
//                 }

//                 return ListView.builder(
//                   itemCount: selectedDiaries.length,
//                   itemBuilder: (context, index) {
//                     final diary = selectedDiaries[index];
//                     return GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           DiaryDetailScreen.route(
//                             tags: diary.tags,
//                             title: diary.title,
//                             content: diary.content,
//                             mood: diary.mood,
//                             date: diary.date,
//                             images: diary.images ?? [],
//                             videos: diary.videos ?? [],
//                             audioRecordings: diary.audioRecordings ?? [],
//                             bulletPoints: diary.bulletPoints ?? [],
//                             textColor: diary.textColor ?? Colors.black,
//                             textStyle: diary.textStyle ??
//                                 const TextStyle(
//                                   fontSize: 16,
//                                   color: Colors.black,
//                                 ),
//                             id: '',
//                           ),
//                         ).then((_) {
//                           controller.refreshEntries();
//                         });
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colorpallete.drawericonColor,
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         margin: const EdgeInsets.only(bottom: 10),
//                         padding: const EdgeInsets.all(10),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   DateFormat('dd-MM-yyyy').format(diary.date),
//                                   style: TextStyle(
//                                     color: Colorpallete.textColor,
//                                     fontSize: 22,
//                                   ),
//                                 ),
//                                 Text(
//                                   diary.mood,
//                                   style: const TextStyle(fontSize: 24),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 6),
//                             Text(
//                               diary.title,
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 color: Colorpallete.textColor,
//                               ),
//                             ),
//                             const SizedBox(height: 20),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:daily_dairies/core/colorPallete.dart';
import 'package:daily_dairies/controllers/diary_controller.dart';
import 'package:daily_dairies/screens/addDiaryScreen.dart';
import 'package:daily_dairies/screens/diaryDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class CalendarScreen extends GetView<DiaryController> {
  static Route route() => MaterialPageRoute(builder: (_) => CalendarScreen());

  final Rx<DateTime> _selectedDay = DateTime.now().obs;
  final Rx<DateTime> _focusedDay = DateTime.now().obs;
  final Rx<CalendarFormat> _calendarFormat = CalendarFormat.month.obs;

  CalendarScreen({super.key});

  List<dynamic> _getDiariesForSelectedDate() {
    final selectedDate = DateFormat('yyyy-MM-dd').format(_selectedDay.value);
    return controller.entries
        .where((entry) =>
            DateFormat('yyyy-MM-dd').format(entry.date) == selectedDate)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorpallete.bgColor,
      appBar: AppBar(
        title: Text("calendar_title".tr),
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
            Navigator.push(context, AddDiaryScreen.route()).then((_) {
              controller.refreshEntries();
            });
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
            Obx(() => TableCalendar(
                  firstDay: DateTime(2000),
                  lastDay: DateTime(2300),
                  focusedDay: _focusedDay.value,
                  calendarFormat: _calendarFormat.value,
                  selectedDayPredicate: (day) =>
                      isSameDay(_selectedDay.value, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    _selectedDay.value = selectedDay;
                    _focusedDay.value = focusedDay;
                  },
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                      final formattedDay = DateFormat('yyyy-MM-dd').format(day);

                      final diariesForDay = controller.entries
                          .where((entry) =>
                              DateFormat('yyyy-MM-dd').format(entry.date) ==
                              formattedDay)
                          .toList();

                      if (diariesForDay.isNotEmpty) {
                        return Center(
                          child: Text(
                            diariesForDay.last.mood,
                            style: const TextStyle(fontSize: 24),
                          ),
                        );
                      }

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
                    weekdayStyle:
                        TextStyle(color: Colorpallete.backgroundColor),
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
                )),
            const SizedBox(height: 20),
            Obx(() => Text(
                  DateFormat('EEEE, MMMM d, yyyy').format(_selectedDay.value),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                    color: Colorpallete.backgroundColor,
                    fontSize: 16,
                  ),
                )),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final selectedDiaries = _getDiariesForSelectedDate();

                if (selectedDiaries.isEmpty) {
                  return Center(
                    child: Text(
                      "no_entries".tr,
                      style: TextStyle(
                        color: Colorpallete.backgroundColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: selectedDiaries.length,
                  itemBuilder: (context, index) {
                    final diary = selectedDiaries[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          DiaryDetailScreen.route(
                            textColor: diary.textColor,
                            date: diary.date,
                            id: diary.id,
                            title: diary.title,
                            content: diary.content,
                            mood: diary.mood,
                            tags: diary.tags,
                            currentTextColor: diary.textColor,
                            bulletPointColor:
                                diary.bulletPointColor ?? diary.textColor,
                            images: diary.images ?? [],
                            videos: diary.videos ?? [],
                            audioRecordings: diary.audioRecordings ?? [],
                            bulletPoints: diary.bulletPoints ?? [],
                            textStyle: diary.textStyle,
                          ),
                        ).then((_) {
                          // Use post frame callback for refresh after navigation
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            controller.refreshEntries();
                          });
                        });
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  DateFormat('dd-MM-yyyy').format(diary.date),
                                  style: TextStyle(
                                    color: Colorpallete.textColor,
                                    fontSize: 22,
                                  ),
                                ),
                                Text(
                                  diary.mood,
                                  style: const TextStyle(fontSize: 24),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              diary.title,
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
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
