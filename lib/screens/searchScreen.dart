import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:daily_dairies/controllers/diary_controller.dart';
import 'package:daily_dairies/core/colorPallete.dart';
import 'package:daily_dairies/screens/diaryDetailScreen.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final DiaryController _diaryController = Get.find<DiaryController>();
  List<String> _filteredEntries = [];

  @override
  void initState() {
    super.initState();
    // Initialize with all entries from the controller
    _filteredEntries =
        _diaryController.entries.map((entry) => entry.title).toList();
  }

  void _filterEntries(String query) {
    setState(() {
      // Filter entries from the controller based on the query
      _filteredEntries = _diaryController.entries
          .where((entry) =>
              entry.title.toLowerCase().contains(query.toLowerCase()))
          .map((entry) => entry.title)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorpallete.bgColor,
      appBar: AppBar(
        backgroundColor: Colorpallete.backgroundColor,
        iconTheme: IconThemeData(color: Colorpallete.textColor),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                onChanged: _filterEntries,
                decoration: InputDecoration(
                  hintText: 'search_entries'.tr,
                  hintStyle: TextStyle(color: Colorpallete.backgroundColor),
                  prefixIcon:
                      Icon(Icons.search, color: Colorpallete.backgroundColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: Colorpallete.backgroundColor, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: Colorpallete.backgroundColor, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: Colorpallete.backgroundColor, width: 2),
                  ),
                ),
                style: TextStyle(color: Colorpallete.backgroundColor),
              ),
              const SizedBox(height: 16),
              Container(
                child: GetBuilder<DiaryController>(
                  builder: (controller) {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (_diaryController.errorMessage.value.isNotEmpty) {
                      return Center(
                        child: Text(
                          'error'.tr +
                              ": ${_diaryController.errorMessage.value}",
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                          ),
                        ),
                      );
                    }

                    if (_filteredEntries.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'no_diaries_found'.tr, // Localized
                              style: TextStyle(
                                color: Colorpallete.textColor,
                                fontSize: 16,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  controller.refreshEntries();
                                });
                              },
                              child: Text('refresh'.tr), // Localized
                            ),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () => _diaryController.refreshEntries(),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _filteredEntries.length,
                        itemBuilder: (context, index) {
                          var entry;
                          try {
                            entry = _diaryController.entries.firstWhere(
                              (e) => e.title == _filteredEntries[index],
                            );
                          } catch (e) {
                            entry = null;
                          }

                          if (entry == null) return const SizedBox.shrink();

                          final formattedDate =
                              DateFormat('dd-MM-yyyy').format(entry.date);

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                          context,
                          DiaryDetailScreen.route(
                            textColor: entry.textColor,
                            date: entry.date,
                            id: entry.id,
                            title: entry.title,
                            content: entry.content,
                            mood: entry.mood,
                            tags: entry.tags,
                            currentTextColor: entry.textColor,
                            bulletPointColor:
                                entry.bulletPointColor ?? entry.textColor,
                            images: entry.images ?? [],
                            videos: entry.videos ?? [],
                            audioRecordings: entry.audioRecordings ?? [],
                            bulletPoints: entry.bulletPoints ?? [],
                            textStyle: entry.textStyle,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
