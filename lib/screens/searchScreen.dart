import 'package:daily_dairies/core/colorPallete.dart';
import 'package:daily_dairies/models/diary_entry.dart';
import 'package:daily_dairies/screens/diaryDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends StatefulWidget {
  final List<DiaryEntry> entries;
  const SearchScreen({super.key, required this.entries});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  late final List<DiaryEntry> _allEntries;
  List<String> recentSearch = [];
  List<DiaryEntry> _filteredEntries = [];

  @override
  void initState() {
    super.initState();
    _allEntries = widget.entries;
    _filteredEntries = List.from(_allEntries); // Initialize with all entries
  }

  void _filterEntries(String query) {
    setState(() {
      _filteredEntries = _allEntries
          .where((entry) =>
              entry.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });

    if (query.trim().isNotEmpty && !recentSearch.contains(query)) {
      setState(() {
        recentSearch.insert(0, query);
        if (recentSearch.length > 5) {
          recentSearch = recentSearch.sublist(0, 5);
        }
      });
    }
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
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: _filterEntries,
              decoration: InputDecoration(
                hintText: "Search entries...",
                hintStyle: TextStyle(color: Colorpallete.backgroundColor),
                prefixIcon:
                    Icon(Icons.search, color: Colorpallete.backgroundColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: Colorpallete.backgroundColor, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                      color: Colorpallete.backgroundColor, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: Colorpallete.backgroundColor, width: 2),
                ),
              ),
              style: TextStyle(color: Colorpallete.backgroundColor),
            ),
            if (recentSearch.isNotEmpty) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Recent Searches",
                  style: TextStyle(
                    color: Colorpallete.backgroundColor,
                    fontSize: 16,
                  ),
                ),
              ),
              Wrap(
                spacing: 8,
                children: recentSearch.map((search) {
                  return ActionChip(
                    label: Text(search),
                    onPressed: () {
                      _searchController.text = search;
                      _filterEntries(search);
                    },
                    backgroundColor: Colors.grey[300],
                  );
                }).toList(),
              ),
              const Divider(),
            ],
            Expanded(
              child: ListView.builder(
                itemCount: _filteredEntries.length,
                itemBuilder: (context, index) {
                  final entry = _filteredEntries[index];
                  return ListTile(
                    title: Text(
                      entry.title,
                      style: TextStyle(color: Colorpallete.backgroundColor),
                    ),
                    subtitle: Text(
                      "Date: ${entry.date.toLocal()}",
                      style: TextStyle(color: Colorpallete.backgroundColor),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DiaryDetailScreen(
                            id: entry.id,
                            title: entry.title,
                            content: entry.content,
                            mood: entry.mood,
                            date: entry.date,
                            images: entry.images,
                            videos: entry.videos,
                            audioRecordings: entry.audioRecordings,
                            bulletPoints: entry.bulletPoints,
                            textColor: entry.textColor,
                            textStyle: entry.textStyle,
                          ),
                        ),
                      );
                    },
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
