// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:daily_dairies/models/signup_model.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:convert';
// import 'package:crypto/crypto.dart';
// import 'package:uuid/uuid.dart';

// class SignupController extends GetxController {
//   var isLoading = false.obs;
//   var errorMessage = ''.obs;
//   final Uuid uuid = Uuid();

//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // Method to handle signup
//   Future<void> signup(SignupModel model) async {
//     print("Starting signup process...");

//     // Validation checks
//     String? passwordError = validatePassword(model.password);
//     if (passwordError != null) {
//       print("Password error: $passwordError");
//       errorMessage.value = passwordError;
//       return;
//     }

//     if (model.fullName.isEmpty) {
//       print("Full name is required");
//       errorMessage.value = 'Full name is required';
//       return;
//     }
//     if (model.email.isEmpty || !GetUtils.isEmail(model.email)) {
//       print("Valid email is required");
//       errorMessage.value = 'Valid email is required';
//       return;
//     }

//     isLoading.value = true;
//     try {
//       print("Hashing password...");
//       String hashedPassword = hashPassword(model.password);
//       print("Hashed password: $hashedPassword");

//       print("Attempting to create user...");
//       UserCredential userCredential =
//           await _auth.createUserWithEmailAndPassword(
//         email: model.email,
//         password: model.password,
//       );

//       print("User created successfully!");

//       if (userCredential.user != null) {
//         print("Saving user data to Firestore...");
//         await _firestore.collection('users').doc(userCredential.user!.uid).set({
//           'id': uuid.v4(),
//           'fullName': model.fullName,
//           'email': model.email,
//           'password': hashedPassword,
//           'createdAt': FieldValue.serverTimestamp(),
//         });
//         print("User data saved to Firestore!");
//         Get.snackbar('Success', 'Account created successfully!');
//       }
//     } on FirebaseAuthException catch (e) {
//       print("FirebaseAuthException: ${e.code} - ${e.message}");
//     } catch (e) {
//       print("Unexpected error: ${e.toString()}");
//       errorMessage.value = 'An error occurred: ${e.toString()}';
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // Password validation function
//   String? validatePassword(String password) {
//     if (password.length < 8) {
//       return 'Password must be at least 8 characters long.';
//     }
//     if (!RegExp(r'(?=.*[a-z])').hasMatch(password)) {
//       return 'Password must contain at least one lowercase letter.';
//     }
//     if (!RegExp(r'(?=.*[A-Z])').hasMatch(password)) {
//       return 'Password must contain at least one uppercase letter.';
//     }
//     if (!RegExp(r'(?=.*\d)').hasMatch(password)) {
//       return 'Password must contain at least one digit.';
//     }
//     if (!RegExp(r'(?=.*[@$!%*?&])').hasMatch(password)) {
//       return 'Password must contain at least one special character (e.g., @\$!%*?&).';
//     }
//     return null; // No errors
//   }

//   String hashPassword(String password) {
//     // Note: We don't need to hash the password as Firebase Auth handles this
//     var bytes = utf8.encode(password);
//     var digest = sha256.convert(bytes);
//     return digest.toString();
//   }
// }


// ==========================================================================================

// Above code is simple 

// ==========================================================================================


// ==========================================================================================

// Below commented code is with snackbar, not working properly 

// ==========================================================================================

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:daily_dairies/models/signup_model.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
// import 'dart:convert';
// import 'package:crypto/crypto.dart';
// import 'package:uuid/uuid.dart';
// import 'package:flutter/material.dart';

// class SignupController extends GetxController {
//   var isLoading = false.obs;
//   var errorMessage = ''.obs;
//   final Uuid uuid = Uuid();

//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // Controllers for form fields
//   final TextEditingController fullNameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmPasswordController =
//       TextEditingController();

//   // Method to handle signup
//   Future<void> signup(SignupModel model) async {
//     print("Starting signup process...");

//     // Validation checks
//     if (model.fullName.isEmpty ||
//         model.email.isEmpty ||
//         model.password.isEmpty) {
//       showSnackbar('Error', 'All fields are required.');
//       return;
//     }

//     String? passwordError = validatePassword(model.password);
//     if (passwordError != null) {
//       showSnackbar('Error', passwordError);
//       return;
//     }

//     if (!GetUtils.isEmail(model.email)) {
//       showSnackbar('Error', 'Valid email is required');
//       return;
//     }

//     isLoading.value = true;
//     try {
//       print("Checking if email already exists...");
//       List<String> signInMethods =
//           await _auth.fetchSignInMethodsForEmail(model.email);
//       if (signInMethods.isNotEmpty) {
//         showSnackbar(
//             'Error', "This email is already registered. Please log in.");
//         return;
//       }

//       print("Attempting to create user...");
//       UserCredential userCredential =
//           await _auth.createUserWithEmailAndPassword(
//         email: model.email,
//         password: model.password,
//       );

//       if (userCredential.user == null) {
//         showSnackbar('Error', 'User  creation failed.');
//         return;
//       }

//       print("User  created successfully! UID: ${userCredential.user!.uid}");
//       print("Saving user data to Firestore...");
//       await _firestore.collection('users').doc(userCredential.user!.uid).set({
//         'id': uuid.v4(),
//         'fullName': model.fullName,
//         'email': model.email,
//         'password':
//             hashPassword(model.password), // Consider not saving the password
//         'createdAt': FieldValue.serverTimestamp(),
//       });
//       print("User  data saved to Firestore!");

//       // Show success snackbar
//       showSnackbar('Success', 'Account created successfully!');

//       // Reset form fields
//       clearForm();
//     } on FirebaseAuthException catch (e) {
//       print("FirebaseAuthException: ${e.code} - ${e.message}");
//       showSnackbar('Error', e.message ?? 'Signup failed');
//     } catch (e) {
//       print("Unexpected error: ${e.toString()}");
//       showSnackbar('Error', 'An error occurred: ${e.toString()}');
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // Password validation function
//   String? validatePassword(String password) {
//     if (password.length < 8) {
//       return 'Password must be at least 8 characters long.';
//     }
//     if (!RegExp(r'(?=.*[a-z])').hasMatch(password)) {
//       return 'Password must contain at least one lowercase letter.';
//     }
//     if (!RegExp(r'(?=.*[A-Z])').hasMatch(password)) {
//       return 'Password must contain at least one uppercase letter.';
//     }
//     if (!RegExp(r'(?=.*\d)').hasMatch(password)) {
//       return 'Password must contain at least one digit.';
//     }
//     if (!RegExp(r'(?=.*[@\$!%*?&])').hasMatch(password)) {
//       return 'Password must contain at least one special character (e.g., @\$!%*?&).';
//     }
//     return null; 
//   }

//   String hashPassword(String password) {
//     var bytes = utf8.encode(password);
//     var digest = sha256.convert(bytes);
//     return digest.toString();
//   }

//   void showSnackbar(String title, String message) {
//     Get.snackbar(
//       title,
//       message,
//       snackPosition: SnackPosition.TOP,
//       duration: const Duration(seconds: 2),
//       backgroundColor: title == 'Error' ? Colors.red : Colors.green,
//       colorText: Colors.white,
//     );
//   }

//   void clearForm() {
//     fullNameController.clear();
//     emailController.clear();
//     passwordController.clear();
//     confirmPasswordController.clear();
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_dairies/models/signup_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

class SignupController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  final Uuid uuid = Uuid();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Controllers for form fields
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // Method to handle signup
  Future<void> signup(SignupModel model) async {
    print("Starting signup process...");

    // Validation checks
    if (model.fullName.isEmpty || model.email.isEmpty || model.password.isEmpty) {
      return;
    }

    String? passwordError = validatePassword(model.password);
    if (passwordError != null) {
      return;
    }

    if (!GetUtils.isEmail(model.email)) {
      return;
    }

    isLoading.value = true;
    print("Checking if email already exists...");
    List<String> signInMethods = await _auth.fetchSignInMethodsForEmail(model.email);
    if (signInMethods.isNotEmpty) {
      return;
    }

    print("Hashing password...");
    String hashedPassword = hashPassword(model.password);
    print("Hashed password: $hashedPassword");

    print("Attempting to create user...");
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: model.email,
      password: model.password,
    );

    if (userCredential.user == null) {
      return;
    }

    print("User created successfully!");
    print("Saving user data to Firestore...");
    await _firestore.collection('users').doc(userCredential.user!.uid).set({
      'id': uuid.v4(),
      'fullName': model.fullName,
      'email': model.email,
      'password': hashedPassword,
      'createdAt': FieldValue.serverTimestamp(),
    });
    print("User data saved to Firestore!");

    // Reset form fields
    clearForm();
    isLoading.value = false;
  }

  // Password validation function
  String? validatePassword(String password) {
    if (password.length < 8) {
      return 'Password must be at least 8 characters long.';
    }
    if (!RegExp(r'(?=.*[a-z])').hasMatch(password)) {
      return 'Password must contain at least one lowercase letter.';
    }
    if (!RegExp(r'(?=.*[A-Z])').hasMatch(password)) {
      return 'Password must contain at least one uppercase letter.';
    }
    if (!RegExp(r'(?=.*\d)').hasMatch(password)) {
      return 'Password must contain at least one digit.';
    }
    if (!RegExp(r'(?=.*[@\\$!%*?&])').hasMatch(password)) {
      return 'Password must contain at least one special character (e.g., @\\\$!%*?&).';
    }
    return null; // No errors
  }

  String hashPassword(String password) {
    // Note: We don't need to hash the password as Firebase Auth handles this
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  void clearForm() {
    fullNameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }
}
