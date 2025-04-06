// import 'package:daily_dairies/models/diary_entry.dart';
// import 'package:get/get.dart';

// class DiaryController extends GetxController {
//   final entries = <DiaryEntry>[].obs;

//   void addEntry(DiaryEntry entry) {
//     entries.add(entry);
//     update();
//   }

//   void deleteEntry(int index) {
//     entries.removeAt(index);
//     update();
//   }

//   void updateEntry(int index, DiaryEntry entry) {
//     entries[index] = entry;
//     update();
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:daily_dairies/models/diary_entry.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DiaryController extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final entries = <DiaryEntry>[].obs;

  String? get userId => _auth.currentUser?.uid;

  List<String> moodEmojis = [
    '😑',
    '😊',
    '😃',
    '😍',
    '😁',
    '😡',
    '😢',
    '😭',
    '😰',
    '😔',
  ];
  int emojiIndex(String? emoji) {
    return moodEmojis.indexOf(emoji ?? '');
  }

  // @override
  // void onInit() {
  //   super.onInit();
  //   fetchEntries();
  // }

  @override
  void onInit() {
    super.onInit();
    fetchEntries();
    // Observe changes in entries and update mood stats
    ever(entries, (_) => updateMoodStats());
  }

  // Map<String, List<int>> get moodStats {
  //   final now = DateTime.now();

  //   List<int> countEmojisForDays(int days) {
  //     final List<int> counts = List.filled(moodEmojis.length, 0);
  //     final cutoff = now.subtract(Duration(days: days));

  //     for (var entry in entries) {
  //       if (entry.createdAt.isAfter(cutoff)) {
  //         final index = emojiIndex(entry.mood);
  //         if (index != -1) counts[index]++;
  //       }
  //     }

  //     return counts;
  //   }

  //   return {
  //     "Last 7 days": countEmojisForDays(7),
  //     "Last 30 days": countEmojisForDays(30),
  //     "Last 90 days": countEmojisForDays(90),
  //     "All": countEmojisForDays(3650), // approx 10 years = all
  //   };
  // }
  RxMap<String, List<int>> moodStats = <String, List<int>>{}.obs;

  void updateMoodStats() {
    final now = DateTime.now();

    // Helper function to count mood emojis for a given time range
    List<int> countEmojisForDays(int days) {
      final List<int> counts = List.filled(moodEmojis.length, 0);
      final cutoff = now.subtract(Duration(days: days));

      // Debugging: Show entries being processed
      print("Counting emojis for the last $days days...");

      for (var entry in entries) {
        print("Checking entry: ${entry.title}, Created At: ${entry.createdAt}");
        if (entry.createdAt.isAfter(cutoff)) {
          final index = emojiIndex(entry.mood);
          if (index != -1) {
            counts[index]++;
            print(
                "Found mood: ${entry.mood} at index $index. Updated counts: $counts");
          } else {
            print("⚠️ Mood '${entry.mood}' not found in moodEmojis list!");
          }
        }
      }

      return counts;
    }

    moodStats.value = {
      "Last 7 days": countEmojisForDays(7),
      "Last 30 days": countEmojisForDays(30),
      "Last 90 days": countEmojisForDays(90),
      "All": countEmojisForDays(3650), // approx 10 years = all
    };

    // Debugging: Print the updated stats
    print("Updated mood stats: ${moodStats.value}");

    update(); // Notify the widget to rebuild
  }

  bool _validateEntry(DiaryEntry entry) {
    if (entry.title.isEmpty) {
      errorMessage.value = 'Title cannot be empty';
      return false;
    }
    if (entry.content.isEmpty) {
      errorMessage.value = 'Content cannot be empty';
      return false;
    }
    return true;
  }

  Future<String> _saveFileLocally(
      File file, String directory, String fileName) async {
    final appDir = await getApplicationDocumentsDirectory();
    final userDir =
        Directory('${appDir.path}/${_auth.currentUser?.uid}/$directory');
    if (!await userDir.exists()) {
      await userDir.create(recursive: true);
    }

    final savedFile = await file.copy('${userDir.path}/$fileName');
    return savedFile.path;
  }

  Future<void> addEntry(DiaryEntry entry) async {
    try {
      if (userId == null) {
        throw Exception('User not logged in');
      }

      print('Adding entry to Firestore...');
      print('Entry data: ${entry.toMap()}');
      print('Using collection: diaries');
      print('Document ID: ${entry.id}');

      await _firestore.collection('diaries').doc(entry.id).set(entry.toMap());

      print('Entry added successfully');
      await fetchEntries();
    } catch (e, stackTrace) {
      print('Error in addEntry: $e');
      print('Stack trace: $stackTrace');
      errorMessage.value = e.toString();
      throw e;
    }
  }

  Future<void> fetchEntries() async {
    try {
      print('Fetching entries...');
      print('Current userId: ${userId}');

      if (userId == null) {
        throw Exception('User not logged in');
      }

      isLoading.value = true;

      final snapshot = await _firestore
          .collection('diaries')
          .where('userId', isEqualTo: userId)
          .get();

      print('Number of documents found: ${snapshot.docs.length}');

      entries.value =
          snapshot.docs.map((doc) => DiaryEntry.fromMap(doc.data())).toList();

      // Sort locally
      entries.value.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      print('Entries loaded: ${entries.length}');
    } catch (e, stackTrace) {
      print('Error fetching entries: $e');
      print('Stack trace: $stackTrace');
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Future<void> fetchEntries() async {
  //   try {
  //     if (userId == null) {
  //       throw Exception('User not logged in');
  //     }

  //     isLoading.value = true;

  //     final snapshot = await _firestore
  //         .collection('diaries')
  //         .where('userId', isEqualTo: userId)
  //         .get();

  //     entries.value =
  //         snapshot.docs.map((doc) => DiaryEntry.fromMap(doc.data())).toList();

  //     entries.value.sort((a, b) => b.createdAt.compareTo(a.createdAt));

  //     // Recalculate mood stats when entries are fetched
  //     updateMoodStats();
  //   } catch (e) {
  //     errorMessage.value = e.toString();
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  Future<void> deleteEntry(String entryId) async {
    try {
      if (userId == null) {
        throw Exception('User not logged in');
      }

      await _firestore.collection('diaries').doc(entryId).delete();

      await fetchEntries();
    } catch (e) {
      print('Error deleting entry: $e');
      errorMessage.value = e.toString();
      throw e;
    }
  }

  Future<void> updateEntry(DiaryEntry entry) async {
    try {
      if (userId == null) {
        throw Exception('User not logged in');
      }

      await _firestore
          .collection('diaries')
          .doc(entry.id)
          .update(entry.toMap());

      await fetchEntries();
    } catch (e) {
      print('Error updating entry: $e');
      errorMessage.value = e.toString();
      throw e;
    }
  }

  Map<String, int> get tagCounts {
    final Map<String, int> counts = {};
    for (var entry in entries) {
      for (var tag in entry.tags) {
        counts[tag] = (counts[tag] ?? 0) + 1;
      }
    }
    return counts;
  }

  List<DiaryEntry> getEntriesByTag(String tag) {
    return entries.where((entry) => entry.tags.contains(tag)).toList();
  }
}
