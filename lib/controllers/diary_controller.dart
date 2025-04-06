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

  // Make these RxVariables
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<DiaryEntry> entries = <DiaryEntry>[].obs;

  // Make userId reactive
  final Rxn<String> _userId = Rxn<String>();
  String? get userId => _userId.value;

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
    print('DiaryController: Initializing...');
    // Listen to auth state changes
    _auth.authStateChanges().listen((user) async {
      try {
        print('DiaryController: Auth state changed - User: ${user?.uid}');
        _userId.value = user?.uid;
        if (user != null) {
          print('DiaryController: User is authenticated, fetching entries...');
          await refreshEntries();
        } else {
          print('DiaryController: No user, clearing entries...');
          entries.clear();
        }
      } catch (e) {
        print('DiaryController: Error in auth state change: $e');
        errorMessage.value = 'Authentication error: ${e.toString()}';
      }
    });
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

  // Private method for internal fetching
  Future<void> _fetchEntriesInternal() async {
    try {
      if (_userId.value == null) {
        print('DiaryController: No user ID available, clearing entries');
        entries.clear();
        return;
      }

      print(
          'DiaryController: Starting to fetch entries for user: ${_userId.value}');
      isLoading.value = true;
      errorMessage.value = '';

      final QuerySnapshot snapshot = await _firestore
          .collection('diaries')
          .where('userId', isEqualTo: _userId.value)
          .get();

      print(
          'DiaryController: Retrieved ${snapshot.docs.length} entries from Firestore');

      final List<DiaryEntry> tempEntries = snapshot.docs
          .map((doc) => DiaryEntry.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      tempEntries.sort((a, b) => b.date.compareTo(a.date));
      entries.assignAll(tempEntries);
      print(
          'DiaryController: Successfully updated entries list with ${entries.length} items');
    } catch (e) {
      print('DiaryController: Error in fetchEntries: $e');
      errorMessage.value = 'Failed to fetch entries: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  // Public method for manual refresh
  Future<void> refreshEntries() async {
    await _fetchEntriesInternal();
  }

  Future<void> addEntry(DiaryEntry entry) async {
    try {
      if (_userId.value == null) {
        throw Exception('User not logged in');
      }

      if (!_validateEntry(entry)) {
        return;
      }

      isLoading.value = true;
      errorMessage.value = '';

      await _firestore.collection('diaries').doc(entry.id).set(entry.toMap());
      await refreshEntries();
    } catch (e) {
      errorMessage.value = e.toString();
      print('Error adding entry: $e');
      throw e;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateEntry(DiaryEntry entry) async {
    try {
      if (_userId.value == null) {
        throw Exception('User not logged in');
      }

      if (!_validateEntry(entry)) {
        return;
      }

      isLoading.value = true;
      errorMessage.value = '';

      await _firestore
          .collection('diaries')
          .doc(entry.id)
          .update(entry.toMap());

      await refreshEntries();
    } catch (e) {
      errorMessage.value = e.toString();
      print('Error updating entry: $e');
      throw e;
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
      if (_userId.value == null) {
        throw Exception('User not logged in');
      }

      isLoading.value = true;
      errorMessage.value = '';

      await _firestore.collection('diaries').doc(entryId).delete();

      await refreshEntries();
    } catch (e) {
      errorMessage.value = e.toString();
      print('Error deleting entry: $e');
      throw e;
    } finally {
      isLoading.value = false;
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
