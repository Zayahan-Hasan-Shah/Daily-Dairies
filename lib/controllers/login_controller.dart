import 'package:daily_dairies/models/login_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/material.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final LocalAuthentication _localAuth = LocalAuthentication();

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> login(LoginModel loginModel) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      errorMessage.value = "Email and Password cannot be empty";
      return;
    }

    try {
      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      isLoading.value = false;
      Get.offAllNamed('/home'); // Navigate to home screen
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = "Login failed: ${e.toString()}";
    }
  }

  Future<void> authenticateWithBiometrics() async {
    try {
      bool authenticated = await _localAuth.authenticate(
        localizedReason: 'Login using your fingerprint 😎',
        options: const AuthenticationOptions(
          biometricOnly: true,
        ),
      );

      if (authenticated) {
        Get.offAllNamed('/'); // ✅ Navigate only if authentication succeeds
      } else {
        errorMessage.value = "Authentication failed or was canceled.";
      }
    } on PlatformException catch (e) {
      errorMessage.value = "Biometric authentication failed: ${e.message}";
    }
  }
}
