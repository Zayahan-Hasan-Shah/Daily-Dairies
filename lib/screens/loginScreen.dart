import 'package:daily_dairies/core/colorPallete.dart';
import 'package:daily_dairies/screens/signupScreen.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class LoginScreen extends StatelessWidget {
  static Route route() => MaterialPageRoute(builder: (_) => LoginScreen());
  final LocalAuthentication auth = LocalAuthentication();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _authenticate() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Scan your fingerprint to authenticate',
        options: const AuthenticationOptions(biometricOnly: true),
      );
      if (authenticated) {
        // Navigate to home screen
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorpallete.backgroundColor,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Text("Login",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colorpallete.textColor)),
            SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration:  InputDecoration(
                hintStyle: TextStyle(
                    color: Colorpallete.textColor,
                  ),
                  labelStyle: TextStyle(color: Colorpallete.textColor,),
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration:  InputDecoration(
                hintStyle: TextStyle(
                    color: Colorpallete.textColor,
                  ),
                  labelStyle: TextStyle(color: Colorpallete.textColor,),
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colorpallete.textColor,
                  foregroundColor: Colorpallete.backgroundColor,
                ),
                onPressed: () {},
                child:  Text("Login", style: TextStyle(fontSize: 24,),),
              ),
            ),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colorpallete.textColor,
                    foregroundColor: Colorpallete.backgroundColor,
                  ),
                onPressed: _authenticate,
                child: const Text("Login with Biometrics"),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context, SignupScreen.route());
              },
              child:  Text("Don't have an account? Sign Up", style: TextStyle(color: Colorpallete.textColor),),
            )
          ],
        ),
      ),
    );
  }
}
