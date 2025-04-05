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

  @override
  void onInit() {
    super.onInit();
    fetchEntries();
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
}
