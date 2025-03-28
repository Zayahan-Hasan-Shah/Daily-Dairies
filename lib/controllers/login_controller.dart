// import 'package:daily_dairies/models/login_model.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:go_router/go_router.dart';
// import 'package:local_auth/local_auth.dart';
// import 'package:flutter/material.dart';

// class LoginController extends GetxController {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final LocalAuthentication _localAuth = LocalAuthentication();

//   var isLoading = false.obs;
//   var errorMessage = ''.obs;

//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   Future<void> login(LoginModel loginModel, BuildContext context) async {
//     String email = emailController.text.trim();
//     String password = passwordController.text.trim();

//     if (email.isEmpty || password.isEmpty) {
//       errorMessage.value = "Email and Password cannot be empty";
//       return;
//     }

//     try {
//       isLoading.value = true;
//       await _auth.signInWithEmailAndPassword(email: email, password: password);
//       isLoading.value = false;
//       // Get.offAllNamed('/home'); // Navigate to home screen
//       if (context.mounted) {
//         context.go('/'); // Navigate to home screen using GoRouter
//       }
//     } catch (e) {
//       isLoading.value = false;
//       errorMessage.value = "Login failed: ${e.toString()}";
//     }
//   }

//   Future<void> authenticateWithBiometrics(BuildContext context) async {
//     try {
//       bool authenticated = await _localAuth.authenticate(
//         localizedReason: 'Login using your fingerprint 😎',
//         options: const AuthenticationOptions(
//           biometricOnly: true,
//         ),
//       );

//       if (authenticated) {
//         Get.testMode = true;
//         // Get.offAllNamed('/'); // ✅ Navigate only if authentication succeeds
//         if (context.mounted) {
//           context.go('/'); // Navigate to home screen using GoRouter
//         }
//       } else {
//         errorMessage.value = "Authentication failed or was canceled.";
//       }
//     } on PlatformException catch (e) {
//       errorMessage.value = "Biometric authentication failed: ${e.message}";
//     }
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/material.dart';
import '../models/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Add this for biometric login persistence

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LocalAuthentication _localAuth = LocalAuthentication();
  late SharedPreferences _prefs;

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var canUseBiometric = false.obs;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void onInit() async {
    super.onInit();
    _prefs = await SharedPreferences.getInstance();
    checkBiometricAvailability();
  }

  Future<void> checkBiometricAvailability() async {
    try {
      canUseBiometric.value = await _localAuth.canCheckBiometrics;
      if (canUseBiometric.value) {
        // Check if user has previously enabled biometric login
        final String? savedEmail = _prefs.getString('biometric_email');
        canUseBiometric.value = savedEmail != null;
      }
    } catch (e) {
      canUseBiometric.value = false;
    }
  }

  Future<bool> login(LoginModel loginModel, BuildContext context) async {
    String email = loginModel.email;
    String password = loginModel.password;

    // Input validation
    if (email.isEmpty || password.isEmpty) {
      errorMessage.value = "Email and Password cannot be empty";
      return false;
    }

    if (!GetUtils.isEmail(email)) {
      errorMessage.value = "Please enter a valid email";
      return false;
    }

    try {
      isLoading.value = true;
      
      // Attempt to sign in
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password
      );

      if (userCredential.user != null) {
        // Update last login timestamp
        await _firestore.collection('users').doc(userCredential.user!.uid).update({
          'lastLogin': FieldValue.serverTimestamp(),
        });

        // Save email for biometric login if not already saved
        if (!canUseBiometric.value) {
          await _prefs.setString('biometric_email', email);
          await _prefs.setString('biometric_password', password); // Consider encrypting this
          canUseBiometric.value = true;
        }

        isLoading.value = false;
        errorMessage.value = '';
        
        if (context.mounted) {
          context.go('/');
        }
        return true;
      }

      isLoading.value = false;
      return false;

    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      switch (e.code) {
        case 'user-not-found':
          errorMessage.value = "No user found with this email";
          break;
        case 'wrong-password':
          errorMessage.value = "Incorrect password";
          break;
        case 'user-disabled':
          errorMessage.value = "This account has been disabled";
          break;
        case 'too-many-requests':
          errorMessage.value = "Too many attempts. Please try again later";
          break;
        default:
          errorMessage.value = "Login failed: ${e.message}";
      }
      return false;
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = "An unexpected error occurred";
      return false;
    }
  }

  Future<void> authenticateWithBiometrics(BuildContext context) async {
    try {
      // Check if biometric login is set up
      final String? savedEmail = _prefs.getString('biometric_email');
      final String? savedPassword = _prefs.getString('biometric_password');

      if (savedEmail == null || savedPassword == null) {
        errorMessage.value = "Please login with email first to set up biometric login";
        return;
      }

      bool authenticated = await _localAuth.authenticate(
        localizedReason: 'Login using your fingerprint 😎',
        options: const AuthenticationOptions(
          biometricOnly: true,
        ),
      );

      if (authenticated) {
        // Use saved credentials to login
        await login(LoginModel(
          email: savedEmail,
          password: savedPassword,
        ), context);
      } else {
        errorMessage.value = "Authentication failed or was canceled.";
      }
    } on PlatformException catch (e) {
      errorMessage.value = "Biometric authentication failed: ${e.message}";
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      // Don't clear biometric credentials on logout
    } catch (e) {
      errorMessage.value = "Logout failed: $e";
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      errorMessage.value = "Password reset email sent. Please check your inbox.";
    } on FirebaseAuthException catch (e) {
      errorMessage.value = "Password reset failed: ${e.message}";
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}