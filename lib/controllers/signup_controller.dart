import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/signup_model.dart';

class SignupController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController bioController = TextEditingController();

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<bool> signup(SignupModel model) async {
    // Input validation
    if (model.fullName.isEmpty ||
        model.email.isEmpty ||
        model.password.isEmpty ||
        model.confirmPassword.isEmpty ||
        model.bio.isEmpty) {
      errorMessage.value = "All fields are required";
      return false;
    }

    if (model.password != model.confirmPassword) {
      errorMessage.value = "Passwords do not match";
      return false;
    }

    if (model.password.length < 6) {
      errorMessage.value = "Password must be at least 6 characters long";
      return false;
    }

    try {
      isLoading.value = true;

      // Create user with email and password
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: model.email,
        password: model.password,
      );

      // If user creation is successful, store additional user data in Firestore
      if (userCredential.user != null) {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'fullName': model.fullName,
          'email': model.email,
          'bio': model.bio,
          'createdAt': FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
          // Add any additional user data fields you want to store
        });

        // Update user profile
        await userCredential.user!.updateDisplayName(model.fullName);

        isLoading.value = false;
        return true;
      }

      isLoading.value = false;
      return false;
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage.value = "Email is already registered";
          break;
        case 'invalid-email':
          errorMessage.value = "Invalid email address";
          break;
        case 'operation-not-allowed':
          errorMessage.value = "Email/password accounts are not enabled";
          break;
        case 'weak-password':
          errorMessage.value = "Password is too weak";
          break;
        default:
          errorMessage.value = "An error occurred during signup";
      }
      return false;
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = "Unexpected error: ${e.toString()}";
      return false;
    }
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    bioController.dispose();
    super.onClose();
  }
}
