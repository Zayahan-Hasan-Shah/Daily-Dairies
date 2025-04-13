import 'package:daily_dairies/controllers/signup_controller.dart';
import 'package:daily_dairies/core/colorPallete.dart';
import 'package:daily_dairies/models/signup_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends StatelessWidget {
  static Route route() => MaterialPageRoute(builder: (_) => SignupScreen());
  final SignupController signupController = Get.put(SignupController());

  SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorpallete.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Sign Up",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colorpallete.textColor,
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: signupController.fullNameController,
              labelText: "Full Name",
            ),
            const SizedBox(height: 10),
            _buildTextField(
              controller: signupController.emailController,
              labelText: "Email",
            ),
            const SizedBox(height: 10),
            _buildTextField(
              controller: signupController.passwordController,
              labelText: "Password",
              obscureText: true,
            ),
            const SizedBox(height: 10),
            _buildTextField(
              controller: signupController.confirmPasswordController,
              labelText: "Confirm Password",
              obscureText: true,
            ),
            const SizedBox(height: 10),
            _buildTextField(
              controller: signupController.bioController,
              labelText: "Enter Bio",
              // obscureText: true,
            ),
            const SizedBox(height: 20),
            signupButton(signupController, context),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                context.go('/login');
              },
              child: Text(
                "Already have an account? Login",
                style: TextStyle(color: Colorpallete.textColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    bool obscureText = false,
  }) {
    return TextField(
      style: const TextStyle(color: Colors.white),
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintStyle: TextStyle(color: Colorpallete.textColor),
        labelStyle: TextStyle(color: Colorpallete.textColor),
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
    );
  }

  // Widget signupButton(SignupController signupController, BuildContext context) {
  //   return Obx(() => signupController.isLoading.value
  //       ? const CircularProgressIndicator()
  //       : Container(
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(8),
  //             color: Colors.white,
  //           ),
  //           width: double.infinity,
  //           child: ElevatedButton(
  //             style: ElevatedButton.styleFrom(
  //               elevation: 0,
  //               backgroundColor: Colors.transparent,
  //               foregroundColor: Colorpallete.backgroundColor,
  //             ),
  //             onPressed: () async {
  //               final model = SignupModel(
  //                 fullName: signupController.fullNameController.text.trim(),
  //                 email: signupController.emailController.text.trim(),
  //                 password: signupController.passwordController.text,
  //                 confirmPassword:
  //                     signupController.confirmPasswordController.text,
  //               );

  //               await signupController.signup(model);
  //               context.go('/');
  //             },
  //             child: const Text("Sign Up", style: TextStyle(fontSize: 24)),
  //           ),
  //         ));
  // }

  Widget signupButton(SignupController signupController, BuildContext context) {
    return Obx(() => signupController.isLoading.value
        ? const CircularProgressIndicator()
        : Column(
            children: [
              if (signupController.errorMessage.value.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    signupController.errorMessage.value,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colorpallete.backgroundColor,
                  ),
                  onPressed: () async {
                    final model = SignupModel(
                        fullName:
                            signupController.fullNameController.text.trim(),
                        email: signupController.emailController.text.trim(),
                        password: signupController.passwordController.text,
                        confirmPassword:
                            signupController.confirmPasswordController.text,
                        bio: signupController.bioController.text);

                    final success = await signupController.signup(model);
                    if (success) {
                      context.go('/login'); // Navigate to home on success
                    }
                  },
                  child: const Text("Sign Up", style: TextStyle(fontSize: 24)),
                ),
              ),
            ],
          ));
  }
}
