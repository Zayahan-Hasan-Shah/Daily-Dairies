// import 'package:daily_dairies/core/colorPallete.dart';
// import 'package:daily_dairies/screens/signupScreen.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:local_auth/local_auth.dart';

// class LoginScreen extends StatelessWidget {
//   static Route route() => MaterialPageRoute(builder: (_) => LoginScreen());
//   final LocalAuthentication auth = LocalAuthentication();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   LoginScreen({super.key});

//   Future<void> _authenticate() async {
//     try {
//       bool authenticated = await auth.authenticate(
//         localizedReason: 'Scan your fingerprint to authenticate',
//         options: const AuthenticationOptions(biometricOnly: true),
//       );
//       if (authenticated) {
//         // Navigate to home screen
//       }
//     } catch (e) {
//       print("Error: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colorpallete.backgroundColor,
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text("Login",
//                 style: TextStyle(
//                     fontSize: 32,
//                     fontWeight: FontWeight.bold,
//                     color: Colorpallete.textColor)),
//             const SizedBox(height: 20),
//             TextField(
//               controller: emailController,
//               decoration: InputDecoration(
//                 hintStyle: TextStyle(
//                   color: Colorpallete.textColor,
//                 ),
//                 labelStyle: TextStyle(
//                   color: Colorpallete.textColor,
//                 ),
//                 labelText: "Email",
//                 border: const OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: passwordController,
//               decoration: InputDecoration(
//                 hintStyle: TextStyle(
//                   color: Colorpallete.textColor,
//                 ),
//                 labelStyle: TextStyle(
//                   color: Colorpallete.textColor,
//                 ),
//                 labelText: "Password",
//                 border: const OutlineInputBorder(),
//               ),
//               obscureText: true,
//             ),
//             const SizedBox(height: 20),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colorpallete.textColor,
//                   foregroundColor: Colorpallete.backgroundColor,
//                 ),
//                 onPressed: () {
//                   context.go('/');
//                 },
//                 child: const Text(
//                   "Login",
//                   style: TextStyle(
//                     fontSize: 24,
//                   ),
//                 ),
//               ),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.push(context, SignupScreen.route());
//               },
//               child: Text(
//                 "Don't have an account? Sign Up",
//                 style: TextStyle(color: Colorpallete.textColor),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// #################################Actual#####################################################

// import 'package:daily_dairies/controllers/login_controller.dart';
// import 'package:daily_dairies/core/colorPallete.dart';
// import 'package:daily_dairies/models/login_model.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:go_router/go_router.dart';

// class LoginScreen extends StatelessWidget {
//   final LoginController loginController = Get.put(LoginController());

//   LoginScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colorpallete.backgroundColor,
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text("Login",
//                 style: TextStyle(
//                     fontSize: 32,
//                     fontWeight: FontWeight.bold,
//                     color: Colorpallete.textColor)),
//             const SizedBox(height: 20),
//             // email input
//             _buildTextField(
//                 controller: loginController.emailController,
//                 labelText: 'Email'),
//             const SizedBox(height: 10),
//             // password controller
//             _buildTextField(
//                 controller: loginController.passwordController,
//                 labelText: 'Password',
//                 obscureText: true),
//             const SizedBox(height: 10),
//             // Login Button
//             loginButton(loginController, context),
//             const SizedBox(height: 10),
//             const Divider(),
//             const SizedBox(height: 10),
//             // Biometric Authentication Button
//             biometricLogin(context),
//             // Sign Up Button
//             TextButton(
//               onPressed: () {
//                 context.go('/signup');
//               },
//               child: Text("Don't have an account? Sign Up",
//                   style: TextStyle(color: Colorpallete.textColor)),
//             ),
//             const SizedBox(height: 10),
//             // Error message
//             _errorMessage(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String labelText,
//     bool obscureText = false,
//   }) {
//     return TextField(
//       style: const TextStyle(color: Colors.white),
//       controller: controller,
//       obscureText: obscureText,
//       decoration: InputDecoration(
//         hintStyle: TextStyle(color: Colorpallete.textColor),
//         labelStyle: TextStyle(color: Colorpallete.textColor),
//         labelText: labelText,
//         border: const OutlineInputBorder(),
//       ),
//     );
//   }

//   Widget _errorMessage() {
//     return Obx(() => loginController.errorMessage.value.isNotEmpty
//         ? Text(
//             loginController.errorMessage.value,
//             style: const TextStyle(color: Colors.red),
//           )
//         : const SizedBox());
//   }

//   // Widget loginButton(LoginController loginController, BuildContext context) {
//   //   return Obx(
//   //     () => Container(
//   //       decoration: BoxDecoration(
//   //         borderRadius: BorderRadius.circular(8),
//   //         color: Colors.white,
//   //       ),
//   //       width: double.infinity,
//   //       child: ElevatedButton(
//   //         style: ElevatedButton.styleFrom(
//   //           backgroundColor: Colors.transparent,
//   //           elevation: 0,
//   //           foregroundColor: Colorpallete.backgroundColor,
//   //         ),
//   //         onPressed: loginController.isLoading.value
//   //             ? null
//   //             : () async {
//   //                 await loginController.login(
//   //                     LoginModel(
//   //                       email: loginController.emailController.text.trim(),
//   //                       password:
//   //                           loginController.passwordController.text.trim(),
//   //                     ),
//   //                     context);
//   //                 if (context.mounted) {
//   //                   context.go('/');
//   //                 }
//   //               },
//   //         child: loginController.isLoading.value
//   //             ? const CircularProgressIndicator(color: Colors.white)
//   //             : const Text("Login", style: TextStyle(fontSize: 24)),
//   //       ),
//   //     ),
//   //   );
//   // }

//   // Widget loginButton(LoginController loginController, BuildContext context) {
//   //   return Obx(
//   //     () => Container(
//   //       decoration: BoxDecoration(
//   //         borderRadius: BorderRadius.circular(8),
//   //         color: Colors.white,
//   //       ),
//   //       width: double.infinity,
//   //       child: ElevatedButton(
//   //         style: ElevatedButton.styleFrom(
//   //           backgroundColor: Colors.transparent,
//   //           elevation: 0,
//   //           foregroundColor: Colorpallete.backgroundColor,
//   //         ),
//   //         onPressed: loginController.isLoading.value
//   //             ? null
//   //             : () async {
//   //                 bool isLoggedIn = await loginController.login(
//   //                   LoginModel(
//   //                     email: loginController.emailController.text.trim(),
//   //                     password: loginController.passwordController.text.trim(),
//   //                   ),
//   //                   context,
//   //                 );
//   //                 if (isLoggedIn) {
//   //                   context.go('/'); // Proceed if login is successful
//   //                 }
//   //               },
//   //         child: loginController.isLoading.value
//   //             ? const CircularProgressIndicator(color: Colors.white)
//   //             : const Text("Login", style: TextStyle(fontSize: 24)),
//   //       ),
//   //     ),
//   //   );
//   // }

//   Widget biometricLogin(BuildContext context) {
//     return Obx(
//       () => loginController.canUseBiometric.value
//           ? Container(
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   elevation: 0,
//                   backgroundColor: Colors.transparent,
//                 ),
//                 onPressed: () async {
//                   await loginController.authenticateWithBiometrics(context);
//                 },
//                 child: const Text("Login with Fingerprint"),
//               ),
//             )
//           : const SizedBox(), // No button shown if biometric login is disabled
//     );
//   }
// }

// #########################Actual Ends##################################

import 'package:daily_dairies/controllers/biometric_controller.dart';
import 'package:daily_dairies/controllers/login_controller.dart';
import 'package:daily_dairies/core/colorPallete.dart';
import 'package:daily_dairies/models/login_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:get_storage/get_storage.dart';

class LoginScreen extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());
  final BiometricServices lockServices = Get.find<BiometricServices>();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorpallete.backgroundColor,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("login".tr,
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colorpallete.textColor)),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: loginController.emailController,
                      labelText: 'email'.tr,
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      controller: loginController.passwordController,
                      labelText: 'password'.tr,
                      obscureText: true,
                    ),
                    const SizedBox(height: 10),
                    loginButton(loginController, context),
                    const SizedBox(height: 10),
                    const Divider(),
                    const SizedBox(height: 10),
                    biometricLogin(context),
                    TextButton(
                      onPressed: () => context.go('/signup'),
                      child: Text("dont_have_account".tr,
                          style: TextStyle(color: Colorpallete.textColor)),
                    ),
                    const SizedBox(height: 10),
                    _errorMessage(),
                  ],
                ),
              ),
            ),
          ),
          // Language Icon Top-Right
          Positioned(
            top: 40,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.language, color: Colors.white),
              onPressed: () => _showLanguageSelector(context),
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageSelector(BuildContext context) {
    final box = GetStorage();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colorpallete.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title:
                    Text("english".tr, style: TextStyle(color: Colors.white)),
                onTap: () {
                  Get.updateLocale(const Locale('en', 'US'));
                  box.write('language_code', 'en');
                  box.write('country_code', 'US');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("urdu".tr, style: TextStyle(color: Colors.white)),
                onTap: () {
                  Get.updateLocale(const Locale('ur', 'PK'));
                  box.write('language_code', 'ur');
                  box.write('country_code', 'PK');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("arabic".tr, style: TextStyle(color: Colors.white)),
                onTap: () {
                  Get.updateLocale(const Locale('ar', 'SA'));
                  box.write('language_code', 'ar');
                  box.write('country_code', 'SA');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
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

  Widget _errorMessage() {
    return Obx(() => loginController.errorMessage.value.isNotEmpty
        ? Text(
            loginController.errorMessage.value,
            style: const TextStyle(color: Colors.red),
          )
        : const SizedBox());
  }

  Widget loginButton(LoginController loginController, BuildContext context) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: Colorpallete.backgroundColor,
          ),
          onPressed: loginController.isLoading.value
              ? null
              : () async {
                  await loginController.login(
                      LoginModel(
                        email: loginController.emailController.text.trim(),
                        password:
                            loginController.passwordController.text.trim(),
                      ),
                      context);
                },
          child: loginController.isLoading.value
              ? const CircularProgressIndicator(color: Colors.white)
              : Text("login".tr, style: const TextStyle(fontSize: 24)),
        ),
      ),
    );
  }

  Widget biometricLogin(BuildContext context) {
    final BiometricServices lockServices = Get.find<BiometricServices>();

    return Obx(
      () => lockServices.isBiometricSet
          ? Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                ),
                onPressed: () async {
                  await loginController.authenticateWithBiometrics(context);
                },
                child: Text("login_with_fingerprint".tr),
              ),
            )
          : const SizedBox(),
    );
  }
}
