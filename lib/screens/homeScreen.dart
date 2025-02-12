import 'package:daily_dairies/core/colorPallete.dart';
import 'package:daily_dairies/screens/addDiaryScreen.dart';
import 'package:daily_dairies/screens/calendarScreen.dart';
import 'package:daily_dairies/screens/diaryDetailScreen.dart';
import 'package:daily_dairies/screens/searchScreen.dart';
import 'package:daily_dairies/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorpallete.bgColor,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, SearchScreen.route());
            },
            icon: Icon(Icons.search_rounded),
          ),
        ],
        title: const Text("Journal Dashboard"),
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
      // Add the drawer here
      drawer: AppDrawer(),
      // Rest of your existing code remains the same
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Image.asset(
                  'assets/images/homeScreenImage.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Diaries",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colorpallete.bottomNavigationColor,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              // color:
                              //     Colorpallete.backgroundColor.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(16)),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                DiaryDetailScreen.route(
                                  "My Diary Title",
                                  "This is the full content of my diary entry...",
                                  "😊",
                                  DateTime.now(),
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colorpallete.backgroundColor
                                        .withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "2025-02-10",
                                              style: TextStyle(
                                                  color: Colorpallete.textColor,
                                                  fontSize: 20),
                                            ),
                                            Text(
                                              "😑",
                                              style: TextStyle(
                                                  color: Colorpallete.textColor,
                                                  fontSize: 20),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          "Journal Entry #$index",
                                          style: TextStyle(
                                              color: Colorpallete.textColor),
                                        ),
                                        const SizedBox(height: 20),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ),
                        // const SizedBox(
                        //   height: 20,
                        // ),
                      ],
                    ),
                  );
                },
              ),
            ),
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
          maxRadius: 16,
          delay: const Duration(milliseconds: 320),
          repeat: true,
          ripplesCount: 4,
          duration: const Duration(milliseconds: 6 * 360),
          child: Icon(
            Icons.add,
            color: Colorpallete.backgroundColor,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colorpallete.bottomNavigationColor.withOpacity(0.4),
        shape: const CircularNotchedRectangle(),
        notchMargin: 10.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(icon: const Icon(Icons.book), onPressed: () {}),
              const SizedBox(width: 40),
              IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () {
                    Navigator.push(context, CalendarScreen.route());
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
