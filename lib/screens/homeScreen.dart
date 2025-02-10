import 'package:daily_dairies/core/colorPallete.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorpallete.backgroundColor,
      appBar: AppBar(
        title: Text("Journal Dashboard"),
        foregroundColor: Colorpallete.bottomNavigationColor,
        backgroundColor: Colorpallete.backgroundColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 200, // Added height
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32), // Define border radius
              ),
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(32), // Apply border radius to image
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
            SizedBox(height: 10),
            Expanded(
              // Correctly placing Expanded
              child: ListView.builder(
                itemCount: 5, // Replace with dynamic data
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      "Journal Entry #$index",
                      style: TextStyle(color: Colorpallete.textColor),
                    ),
                    subtitle: Text(
                      "Date: 2025-02-10",
                      style: TextStyle(color: Colorpallete.textColor),
                    ),
                    onTap: () {},
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {}, // Navigate to Add Entry Screen
        backgroundColor: Colorpallete.textColor,
        child: Icon(Icons.add, color: Colorpallete.backgroundColor),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colorpallete.bottomNavigationColor,
        shape: CircularNotchedRectangle(),
        notchMargin: 10.0,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(icon: Icon(Icons.book), onPressed: () {}),
              SizedBox(width: 40), // Space for Floating Action Button
              IconButton(icon: Icon(Icons.calendar_today), onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
