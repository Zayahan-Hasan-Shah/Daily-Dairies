// import 'dart:io';
// import 'package:intl/intl.dart';
// import 'package:flutter/material.dart';

// class DiaryEntry {
//   final String id;
//   final String userId;
//   final String title;
//   final String content;
//   final DateTime date;
//   final String mood; // For emoji selection
//   final Color textColor; // For text color styling
//   final TextStyle textStyle; // For text styling (italic, size, etc.)
//   final List<String> images;
//   final List<String> videos;
//   final List<String> audioRecordings;
//   final List<String> bulletPoints;
//   final DateTime createdAt;

//   DiaryEntry({
//     required this.id,
//     required this.userId,
//     required this.title,
//     required this.content,
//     required this.date,
//     required this.mood,
//     required this.textColor,
//     required this.textStyle,
//     this.images = const [],
//     this.videos = const [],
//     this.audioRecordings = const [],
//     this.bulletPoints = const [],
//     DateTime? createdAt,
//   }) : createdAt = createdAt ?? DateTime.now();

//   // Add fromMap factory constructor
//   factory DiaryEntry.fromMap(Map<String, dynamic> map) {
//     final dateFormatter = DateFormat('dd-MM-yyyy');
//     return DiaryEntry(
//       id: map['id'] ?? '',
//       userId: map['userId'] ?? '',
//       title: map['title'] ?? '',
//       content: map['content'] ?? '',
//       date: dateFormatter.parse(map['date']),
//       mood: map['mood'] ?? '😊',
//       textColor: Color(map['textColor'] ?? Colors.black.value),
//       textStyle: TextStyle(
//         fontSize: (map['textStyle']?['fontSize'] as num?)?.toDouble() ?? 16.0,
//         fontStyle: FontStyle.values[map['textStyle']?['fontStyle'] ?? 0],
//         letterSpacing:
//             (map['textStyle']?['letterSpacing'] as num?)?.toDouble() ?? 0.0,
//         color: Color(map['textStyle']?['color'] ?? Colors.black.value),
//       ),
//       images: List<String>.from(map['images'] ?? []),
//       videos: List<String>.from(map['videos'] ?? []),
//       audioRecordings: List<String>.from(map['audioRecordings'] ?? []),
//       bulletPoints: List<String>.from(map['bulletPoints'] ?? []),
//       createdAt: dateFormatter.parse(map['createdAt']),
//     );
//   }

//   // Add toMap method for Firebase
//   Map<String, dynamic> toMap() {
//     final dateFormatter = DateFormat('dd-MM-yyyy');
//     return {
//       'id': id,
//       'userId': userId,
//       'title': title,
//       'content': content,
//       'date': dateFormatter.format(date),
//       'mood': mood,
//       'textColor': textColor.value,
//       'textStyle': {
//         'fontSize': textStyle.fontSize,
//         'fontStyle': textStyle.fontStyle?.index ?? FontStyle.normal.index,
//         'letterSpacing': textStyle.letterSpacing,
//         'color': textStyle.color?.value ?? Colors.black.value,
//       },
//       'images': images,
//       'videos': videos,
//       'audioRecordings': audioRecordings,
//       'bulletPoints': bulletPoints,
//       'createdAt': dateFormatter.format(createdAt),
//     };
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart'; // For Timestamp
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class DiaryEntry {
  final String id;
  final String userId;
  final String title;
  final String content;
  final DateTime date;
  final String mood; // For emoji selection
  final Color textColor; // For text color styling
  final TextStyle textStyle; // For text styling (italic, size, etc.)
  final List<String> tags;
  final List<String> images;
  final List<String> videos;
  final List<String> audioRecordings;
  final List<String> bulletPoints;
  final DateTime createdAt;

  DiaryEntry({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.date,
    required this.mood,
    required this.textColor,
    required this.textStyle,
    this.tags = const [],
    this.images = const [],
    this.videos = const [],
    this.audioRecordings = const [],
    this.bulletPoints = const [],
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // fromMap method with Firestore Timestamp handling
  factory DiaryEntry.fromMap(Map<String, dynamic> map) {
    final dateFormatter = DateFormat('dd-MM-yyyy');
    return DiaryEntry(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      date: (map['date'] is Timestamp)
          ? (map['date'] as Timestamp).toDate()
          : dateFormatter.parse(map['date']),
      mood: map['mood'] ?? '😊',
      textColor: Color(map['textColor'] ?? Colors.black.value),
      textStyle: TextStyle(
        fontSize: (map['textStyle']?['fontSize'] as num?)?.toDouble() ?? 16.0,
        fontStyle: FontStyle.values[map['textStyle']?['fontStyle'] ?? 0],
        letterSpacing:
            (map['textStyle']?['letterSpacing'] as num?)?.toDouble() ?? 0.0,
        color: Color(map['textStyle']?['color'] ?? Colors.black.value),
      ),
      tags: List<String>.from(map['tags'] ?? []),
      images: List<String>.from(map['images'] ?? []),
      videos: List<String>.from(map['videos'] ?? []),
      audioRecordings: List<String>.from(map['audioRecordings'] ?? []),
      bulletPoints: List<String>.from(map['bulletPoints'] ?? []),
      createdAt: (map['createdAt'] is Timestamp)
          ? (map['createdAt'] as Timestamp).toDate().toUtc()
          : dateFormatter.parse(map['createdAt']).toUtc(),
    );
  }

  // toMap method for Firebase with Firestore Timestamp
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'content': content,
      'date': date.toUtc(),
      'mood': mood,
      'textColor': textColor.value,
      'textStyle': {
        'fontSize': textStyle.fontSize,
        'fontStyle': textStyle.fontStyle?.index ?? FontStyle.normal.index,
        'letterSpacing': textStyle.letterSpacing,
        'color': textStyle.color?.value ?? Colors.black.value,
      },
      'tags': tags,
      'images': images,
      'videos': videos,
      'audioRecordings': audioRecordings,
      'bulletPoints': bulletPoints,
      'createdAt': createdAt.toUtc(),
    };
  }
}
