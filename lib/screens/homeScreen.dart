// import 'package:daily_dairies/core/colorPallete.dart';
// import 'package:daily_dairies/dummyData/dummData.dart';
// import 'package:daily_dairies/screens/addDiaryScreen.dart';
// import 'package:daily_dairies/screens/calendarScreen.dart';
// import 'package:daily_dairies/screens/diaryDetailScreen.dart';
// import 'package:daily_dairies/screens/profileScreen.dart';
// import 'package:daily_dairies/screens/searchScreen.dart';
// import 'package:daily_dairies/widgets/app_drawer.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:simple_ripple_animation/simple_ripple_animation.dart';
// import 'package:easy_localization/easy_localization.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colorpallete.bgColor,
//       appBar: AppBar(
//         actions: [
//           IconButton(
//             onPressed: () {
//               context.go('/search');
//             },
//             icon: const Icon(Icons.search_rounded),
//           ),
//         ],
//         title: Text(
//           "app_title".tr(),
//           style: const TextStyle(fontFamily: 'Poppins'),
//         ),
//         foregroundColor: Colorpallete.bottomNavigationColor,
//         backgroundColor: Colorpallete.backgroundColor,
//         leading: IconButton(
//           icon: const Icon(Icons.menu),
//           onPressed: () {
//             Scaffold.of(context).openDrawer();
//           },
//         ),
//       ),
//       drawer: const AppDrawer(),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               width: double.infinity,
//               height: 200,
//               padding: const EdgeInsets.all(2),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(32),
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(32),
//                 child: Image.asset(
//                   'assets/images/homeScreenImage.png',
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               "diaries".tr(),
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colorpallete.bottomNavigationColor,
//               ),
//             ),
//             const SizedBox(height: 10),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: dummyData.length,
//                 itemBuilder: (context, index) {
//                   return GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         DiaryDetailScreen.route(
//                           dummyData[index]["title"],
//                           dummyData[index]["description"],
//                           dummyData[index]["emoji"],
//                           DateFormat("dd-MM-yyyy").parse(dummyData[index]["date"]),
//                         ),
//                       );
//                     },
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colorpallete.drawericonColor,
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       margin: const EdgeInsets.only(bottom: 10),
//                       padding: const EdgeInsets.all(10),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 dummyData[index]["date"],
//                                 style: TextStyle(
//                                   color: Colorpallete.textColor,
//                                   fontSize: 22,
//                                 ),
//                               ),
//                                Text(dummyData[index]["emoji"], style: const TextStyle(fontSize: 18),),
//                             ],
//                           ),
//                           const SizedBox(height: 6),
//                           Text(
//                             dummyData[index]["title"],
//                             style: TextStyle(
//                               fontSize: 18,
//                               color: Colorpallete.textColor,
//                             ),
//                           ),
//                           const SizedBox(height: 20),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colorpallete.textColor.withOpacity(0.4),
//         elevation: 0,
//         onPressed: () {
//           Navigator.push(context, AddDiaryScreen.route());
//         },
//         child: RippleAnimation(
//           color: Colorpallete.backgroundColor,
//           minRadius: 10,
//           maxRadius: 16,
//           delay: const Duration(milliseconds: 320),
//           repeat: true,
//           ripplesCount: 4,
//           duration: const Duration(milliseconds: 2160),
//           child: Icon(
//             Icons.add,
//             color: Colorpallete.backgroundColor,
//           ),
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       bottomNavigationBar: BottomAppBar(
//         color: Colorpallete.bottomNavigationColor.withOpacity(0.4),
//         shape: const CircularNotchedRectangle(),
//         notchMargin: 10.0,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.person),
//                 onPressed: () {
//                   Navigator.push(context, ProfileScreen.route());
//                 },
//               ),
//               const SizedBox(width: 40),
//               IconButton(
//                 icon: const Icon(Icons.calendar_today),
//                 onPressed: () {
//                   Navigator.push(context, CalendarScreen.route());
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:daily_dairies/core/colorPallete.dart';
import 'package:daily_dairies/controllers/diary_controller.dart';
import 'package:daily_dairies/screens/addDiaryScreen.dart';
import 'package:daily_dairies/screens/calendarScreen.dart';
import 'package:daily_dairies/screens/diaryDetailScreen.dart';
import 'package:daily_dairies/screens/profileScreen.dart';
import 'package:daily_dairies/screens/searchScreen.dart';
import 'package:daily_dairies/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DiaryController _diaryController = Get.find<DiaryController>();

  @override
  void initState() {
    super.initState();
    _diaryController.fetchEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorpallete.bgColor,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              context.go('/search');
            },
            icon: const Icon(Icons.search_rounded),
          ),
        ],
        title: Text(
          context.tr("app_title"),
          style: const TextStyle(fontFamily: 'Poppins'),
        ),
        foregroundColor: Colorpallete.bottomNavigationColor,
        backgroundColor: Colorpallete.backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      drawer: const AppDrawer(),
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
              context.tr("diaries"),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colorpallete.bottomNavigationColor,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(() {
                if (_diaryController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (_diaryController.errorMessage.value.isNotEmpty) {
                  return Center(
                    child: Text(
                      'Error: ${_diaryController.errorMessage.value}',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    ),
                  );
                }

                if (_diaryController.entries.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'No diaries found',
                          style: TextStyle(
                            color: Colorpallete.textColor,
                            fontSize: 16,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _diaryController.fetchEntries(),
                          child: const Text('Refresh'),
                        ),
                        Text(
                          'User ID: ${_diaryController.userId ?? "No user ID"}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: _diaryController.entries.length,
                  itemBuilder: (context, index) {
                    final entry = _diaryController.entries[index];
                    final formattedDate =
                        DateFormat('dd-MM-yyyy').format(entry.date);

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          DiaryDetailScreen.route(
                            entry.title,
                            entry.content,
                            entry.mood,
                            entry.date,
                          ),
                        ).then((_) {
                          // Refresh entries when returning from detail screen
                          _diaryController.fetchEntries();
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
                                  formattedDate,
                                  style: TextStyle(
                                    color: Colorpallete.textColor,
                                    fontSize: 22,
                                  ),
                                ),
                                Text(
                                  entry.mood,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              entry.title,
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colorpallete.textColor.withOpacity(0.4),
        elevation: 0,
        onPressed: () {
          Navigator.push(
            context,
            AddDiaryScreen.route(),
          ).then((_) {
            // Refresh entries when returning from add screen
            _diaryController.fetchEntries();
          });
        },
        child: RippleAnimation(
          color: Colorpallete.backgroundColor,
          minRadius: 10,
          maxRadius: 16,
          delay: const Duration(milliseconds: 320),
          repeat: true,
          ripplesCount: 4,
          duration: const Duration(milliseconds: 2160),
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
              IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {
                  Navigator.push(context, ProfileScreen.route());
                },
              ),
              const SizedBox(width: 40),
              IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () {
                  Navigator.push(context, CalendarScreen.route());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
