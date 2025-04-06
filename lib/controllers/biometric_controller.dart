import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BiometricServices extends GetxController {
  static final BiometricServices _instance = BiometricServices._internal();
  factory BiometricServices() => _instance;
  BiometricServices._internal();

  final RxBool _isBiometricSet = false.obs;
  bool get isBiometricSet => _isBiometricSet.value;

  @override
  void onInit() {
    super.onInit();
    loadBiometricState();
  }

  void toggleBiometricSet() {
    _isBiometricSet.value = !_isBiometricSet.value;
    saveBiometricState();
  }

  void setBiometricState(bool state) {
    _isBiometricSet.value = state;
    saveBiometricState();
  }

  Future<void> saveBiometricState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isBiometricSet', _isBiometricSet.value);
  }

  Future<void> loadBiometricState() async {
    final prefs = await SharedPreferences.getInstance();
    _isBiometricSet.value = prefs.getBool('isBiometricSet') ?? false;
  }
}