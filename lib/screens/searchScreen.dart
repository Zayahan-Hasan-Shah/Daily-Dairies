import 'package:daily_dairies/core/colorPallete.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  List<String> _allEntries = [
    "Morning Reflection",
    "Workout Log",
    "Project Ideas",
    "Weekend Plans",
    "Book Summary"
  ];
  List<String> _filteredEntries = [];

  @override
  void initState() {
    super.initState();
    _filteredEntries = List.from(_allEntries); // Initialize with all entries
  }

  void _filterEntries(String query) {
    setState(() {
      _filteredEntries = _allEntries
          .where((entry) => entry.toLowerCase().contains(query.toLowerCase()))
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
          icon: Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Container(
        child: Padding(
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
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                    borderSide: BorderSide(
                        color: Colorpallete.backgroundColor,
                        width: 2), // Border color and width
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: Colorpallete.backgroundColor,
                        width: 1.5), // Default border
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: Colorpallete.backgroundColor,
                        width: 2), // Focused border color
                  ),
                ),
                style: TextStyle(color: Colorpallete.backgroundColor),
              ),
              Container(
                child: Expanded(
                  child: ListView.builder(
                    itemCount: _filteredEntries.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          _filteredEntries[index],
                          style: TextStyle(color: Colorpallete.backgroundColor),
                        ),
                        subtitle: Text(
                          "Date: 2025-02-10",
                          style: TextStyle(color: Colorpallete.backgroundColor),
                        ),
                        onTap: () {},
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
