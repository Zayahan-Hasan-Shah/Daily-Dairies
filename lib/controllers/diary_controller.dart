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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  final entries = <DiaryEntry>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchEntries();
  }

  Future<String> _saveFileLocally(File file, String directory, String fileName) async {
    final appDir = await getApplicationDocumentsDirectory();
    final userDir = Directory('${appDir.path}/${_auth.currentUser?.uid}/$directory');
    if (!await userDir.exists()) {
      await userDir.create(recursive: true);
    }
    
    final savedFile = await file.copy('${userDir.path}/$fileName');
    return savedFile.path;
  }

  Future<void> addEntry(DiaryEntry entry, {
    List<File>? images,
    List<File>? videos,
    List<File>? audioFiles,
  }) async {
    try {
      isLoading.value = true;
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      // Save media files locally
      List<String> imagePaths = [];
      List<String> videoPaths = [];
      List<String> audioPaths = [];

      if (images != null) {
        for (var image in images) {
          final fileName = '${DateTime.now().millisecondsSinceEpoch}_${imagePaths.length}.jpg';
          final path = await _saveFileLocally(image, 'images', fileName);
          imagePaths.add(path);
        }
      }

      if (videos != null) {
        for (var video in videos) {
          final fileName = '${DateTime.now().millisecondsSinceEpoch}_${videoPaths.length}.mp4';
          final path = await _saveFileLocally(video, 'videos', fileName);
          videoPaths.add(path);
        }
      }

      if (audioFiles != null) {
        for (var audio in audioFiles) {
          final fileName = '${DateTime.now().millisecondsSinceEpoch}_${audioPaths.length}.m4a';
          final path = await _saveFileLocally(audio, 'audio', fileName);
          audioPaths.add(path);
        }
      }

      // Create entry with local file paths
      final entryMap = entry.toMap();
      if (imagePaths.isNotEmpty) entryMap['images'] = imagePaths;
      if (videoPaths.isNotEmpty) entryMap['videos'] = videoPaths;
      if (audioPaths.isNotEmpty) entryMap['audioRecordings'] = audioPaths;

      final docRef = await _firestore
          .collection('users')
          .doc(userId)
          .collection('diaries')
          .add(entryMap);

      final newEntry = DiaryEntry.fromMap({...entryMap, 'id': docRef.id});
      entries.add(newEntry);
      
    } catch (e) {
      errorMessage.value = 'Failed to add entry: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteEntry(String entryId) async {
    try {
      isLoading.value = true;
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      // Delete local media files
      final entry = entries.firstWhere((e) => e.id == entryId);
      
      // Delete images
      if (entry.images != null) {
        for (var path in entry.images!) {
          final file = File(path);
          if (await file.exists()) {
            await file.delete();
          }
        }
      }

      // Delete videos
      if (entry.videos != null) {
        for (var path in entry.videos!) {
          final file = File(path);
          if (await file.exists()) {
            await file.delete();
          }
        }
      }

      // Delete audio recordings
      if (entry.audioRecordings != null) {
        for (var path in entry.audioRecordings!) {
          final file = File(path);
          if (await file.exists()) {
            await file.delete();
          }
        }
      }

      // Delete entry document
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('diaries')
          .doc(entryId)
          .delete();

      entries.removeWhere((e) => e.id == entryId);
      
    } catch (e) {
      errorMessage.value = 'Failed to delete entry: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchEntries() async {
    try {
      isLoading.value = true;
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('diaries')
          .orderBy('date', descending: true)
          .get();

      entries.value = snapshot.docs
          .map((doc) => DiaryEntry.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      errorMessage.value = 'Failed to fetch entries: $e';
    } finally {
      isLoading.value = false;
    }
  }
}