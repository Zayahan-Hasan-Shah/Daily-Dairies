import 'package:flutter/material.dart';

class DiaryEntry {
  final String id;
  final String title;
  final String content;
  final DateTime date;
  final String mood; // For emoji selection
  final Color textColor; // For text color styling
  final TextStyle textStyle; // For text styling (italic, size, etc.)
  final List<String>? images; // Optional
  final List<String>? videos; // Optional
  final List<String>? audioRecordings; // Optional

  DiaryEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.mood,
    required this.textColor,
    required this.textStyle,
    this.images,
    this.videos,
    this.audioRecordings,
  });

  // Add toMap method for Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date.toIso8601String(),
      'mood': mood,
      'textColor': textColor.value,
      'textStyle': {
        'fontSize': textStyle.fontSize,
        'fontStyle': textStyle.fontStyle?.index,
      },
      'images': images,
      'videos': videos,
      'audioRecordings': audioRecordings,
    };
  }

  // Add fromMap method for Firebase
  // factory DiaryEntry.fromMap(Map<String, dynamic> map) {
  //   return DiaryEntry(
  //     id: map['id'],
  //     title: map['title'],
  //     content: map['content'],
  //     date: DateTime.parse(map['date']),
  //     mood: map['mood'],
  //     textColor: Color(map['textColor']),
  //     textStyle: TextStyle(
  //       fontSize: map['textStyle']['fontSize'],
  //       fontStyle: map['textStyle']['fontStyle'] != null
  //           ? FontStyle.values[map['textStyle']['fontStyle']]
  //           : null,
  //     ),
  //     images: map['images'] != null ? List<String>.from(map['images']) : null,
  //     videos: map['videos'] != null ? List<String>.from(map['videos']) : null,
  //     audioRecordings: map['audioRecordings'] != null
  //         ? List<String>.from(map['audioRecordings'])
  //         : null,
  //   );
  // }
}
