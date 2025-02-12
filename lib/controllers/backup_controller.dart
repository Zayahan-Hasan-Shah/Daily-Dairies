import 'package:get/get.dart';

class BackupController extends GetxController {
  final RxBool isAutoBackupEnabled = true.obs;
  final RxString selectedReminderInterval = '3 days'.obs;
  final RxBool isBackupAccountExpanded = false.obs;
  final RxBool isGoogleDriveConnected = false.obs;

  void toggleAutoBackup(bool value) {
    isAutoBackupEnabled.value = value;
  }

  void setReminderInterval(String interval) {
    selectedReminderInterval.value = interval;
  }

  void toggleBackupAccountExpanded() {
    isBackupAccountExpanded.value = !isBackupAccountExpanded.value;
  }
}
