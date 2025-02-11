import 'package:daily_dairies/core/colorPallete.dart';
import 'package:daily_dairies/screens/loginScreen.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  static Route route() => MaterialPageRoute(builder: (_) => SignupScreen());
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

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
             Text("Sign Up",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colorpallete.textColor )),
            const SizedBox(height: 20),
            TextField(
              controller: fullNameController,
              decoration:  InputDecoration(
                  hintStyle: TextStyle(
                    color: Colorpallete.textColor,
                  ),
                  labelStyle: TextStyle(color: Colorpallete.textColor,),
                  labelText: "Full Name", border: const OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration:  InputDecoration(
                hintStyle: TextStyle(
                    color: Colorpallete.textColor,
                  ),
                  labelStyle: TextStyle(color: Colorpallete.textColor,),
                  labelText: "Email", border: const OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration:  InputDecoration(
                hintStyle: TextStyle(
                    color: Colorpallete.textColor,
                  ),
                  labelStyle: TextStyle(color: Colorpallete.textColor,),
                  labelText: "Password", border: const OutlineInputBorder()),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: confirmPasswordController,
              decoration:  InputDecoration(
                hintStyle: TextStyle(
                    color: Colorpallete.textColor,
                  ),
                  labelStyle: TextStyle(color: Colorpallete.textColor,),
                  labelText: "Confirm Password", border: const OutlineInputBorder()),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colorpallete.textColor,
                  foregroundColor: Colorpallete.backgroundColor,
                ),
                onPressed: () {},
                child: const Text("Sign Up", style: TextStyle(fontSize: 24),),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context, LoginScreen.route());
              },
              child:  Text("Already have an account? Login", style: TextStyle(color: Colorpallete.textColor),),
            )
          ],
        ),
      ),
    );
  }
}
