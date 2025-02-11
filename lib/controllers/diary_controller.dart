import 'package:daily_dairies/models/diary_entry.dart';
import 'package:get/get.dart';

class DiaryController extends GetxController {
  final entries = <DiaryEntry>[].obs;
  
  void addEntry(DiaryEntry entry) {
    entries.add(entry);
    update();
  }
  
  void deleteEntry(int index) {
    entries.removeAt(index);
    update();
  }
  
  void updateEntry(int index, DiaryEntry entry) {
    entries[index] = entry;
    update();
  }
}