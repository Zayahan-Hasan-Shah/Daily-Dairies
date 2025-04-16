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
  final String mood;
  final List<String> tags;
  final Color textColor;
  final Color bulletPointColor;
  final TextStyle textStyle;
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
    required this.tags,
    required this.textColor,
    required this.bulletPointColor,
    required this.textStyle,
    required this.images,
    required this.videos,
    required this.audioRecordings,
    required this.bulletPoints,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // toMap method for Firebase with Firestore Timestamp
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'content': content,
      'date': date.toUtc(),
      'mood': mood,
      'tags': tags,
      'textColor': textColor.value,
      'bulletPointColor': bulletPointColor.value,
      // Store text style properties directly in the main map
      'fontSize': textStyle.fontSize,
      'fontWeight': textStyle.fontWeight?.index,
      'fontStyle': textStyle.fontStyle?.index,
      'letterSpacing': textStyle.letterSpacing,
      // Keep textStyle map for backward compatibility
      'textStyle': {
        'fontSize': textStyle.fontSize,
        'fontWeight': textStyle.fontWeight?.index,
        'fontStyle': textStyle.fontStyle?.index,
        'letterSpacing': textStyle.letterSpacing,
        'color': textStyle.color?.value ?? Colors.black.value,
      },
      'images': images,
      'videos': videos,
      'audioRecordings': audioRecordings,
      'bulletPoints': bulletPoints,
      'createdAt': createdAt.toUtc(),
    };
  }

  // fromMap method with Firestore Timestamp handling
  factory DiaryEntry.fromMap(Map<String, dynamic> map) {
    final dateFormatter = DateFormat('dd-MM-yyyy');

    // Helper function to convert fontWeight integer to FontWeight
    FontWeight getFontWeight(int? weightIndex) {
      if (weightIndex == null) return FontWeight.normal;

      // Map index to actual FontWeight values
      switch (weightIndex) {
        case 0:
          return FontWeight.w100;
        case 1:
          return FontWeight.w200;
        case 2:
          return FontWeight.w300;
        case 3:
          return FontWeight.w400; // normal
        case 4:
          return FontWeight.w500;
        case 5:
          return FontWeight.w600;
        case 6:
          return FontWeight.w700; // bold
        case 7:
          return FontWeight.w800;
        case 8:
          return FontWeight.w900;
        default:
          return FontWeight.normal;
      }
    }

    // Get fontWeight value from map
    final int? fontWeightIndex =
        map['fontWeight'] as int? ?? map['textStyle']?['fontWeight'] as int?;

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
      bulletPointColor: Color(map['bulletPointColor'] ?? Colors.black.value),
      textStyle: TextStyle(
        // Get fontSize from direct property first, or textStyle map, or default
        fontSize: (map['fontSize'] as num?)?.toDouble() ??
            (map['textStyle']?['fontSize'] as num?)?.toDouble() ??
            16.0,
        // Use the helper function to convert fontWeight
        fontWeight: getFontWeight(fontWeightIndex),
        // Get fontStyle from direct property first, or textStyle map, or default
        fontStyle: map['fontStyle'] != null
            ? FontStyle.values[map['fontStyle'] as int]
            : map['textStyle']?['fontStyle'] != null
                ? FontStyle.values[map['textStyle']['fontStyle'] as int]
                : FontStyle.normal,
        // Get letterSpacing from direct property first, or textStyle map, or default
        letterSpacing: (map['letterSpacing'] as num?)?.toDouble() ??
            (map['textStyle']?['letterSpacing'] as num?)?.toDouble() ??
            0.0,
        color: Color(map['textColor'] ?? Colors.black.value),
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
  // Map<String, dynamic> toMap() {
  //   return {
  //     'id': id,
  //     'userId': userId,
  //     'title': title,
  //     'content': content,
  //     'date': date.toUtc(),
  //     'mood': mood,
  //     'tags': tags,
  //     'textColor': textColor.value,
  //     'bulletPointColor': bulletPointColor.value,
  //     'textStyle': {
  //       'fontSize': textStyle.fontSize,
  //       'fontWeight': textStyle.fontWeight?.index,
  //       'fontStyle': textStyle.fontStyle?.index,
  //       'letterSpacing': textStyle.letterSpacing,
  //       'color': textStyle.color?.value ?? Colors.black.value,
  //     },
  //     // 'tags': tags,
  //     'images': images,
  //     'videos': videos,
  //     'audioRecordings': audioRecordings,
  //     'bulletPoints': bulletPoints,
  //     'createdAt': createdAt.toUtc(),
  //   };
  // }

  // factory DiaryEntry.fromMap(Map<String, dynamic> map) {
  //   return DiaryEntry(
  //     id: map['id'] ?? '',
  //     userId: map['userId'] ?? '',
  //     title: map['title'] ?? '',
  //     content: map['content'] ?? '',
  //     date: DateTime.parse(map['date']),
  //     mood: map['mood'] ?? '😊',
  //     tags: List<String>.from(map['tags'] ?? []),
  //     textColor: Color(map['textColor'] ?? Colors.black.value),
  //     textStyle: TextStyle(
  //       fontSize: map['textStyle']?['fontSize'] ?? 16,
  //       fontWeight: map['textStyle']?['fontWeight'] != null
  //           ? FontWeight.values[map['textStyle']['fontWeight']]
  //           : FontWeight.normal,
  //       fontStyle: map['textStyle']?['fontStyle'] != null
  //           ? FontStyle.values[map['textStyle']['fontStyle']]
  //           : FontStyle.normal,
  //       letterSpacing: map['textStyle']?['letterSpacing'] ?? 0,
  //     ),
  //     images: List<String>.from(map['images'] ?? []),
  //     videos: List<String>.from(map['videos'] ?? []),
  //     audioRecordings: List<String>.from(map['audioRecordings'] ?? []),
  //     bulletPoints: List<String>.from(map['bulletPoints'] ?? []),
  //     createdAt:
  //         DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
  //   );
  // }
}
