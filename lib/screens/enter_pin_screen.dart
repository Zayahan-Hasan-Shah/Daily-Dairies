import 'package:daily_dairies/screens/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:daily_dairies/core/colorPallete.dart';
import 'package:get/get.dart';

class EnterPinScreen extends StatefulWidget {
  const EnterPinScreen({super.key});

  @override
  State<EnterPinScreen> createState() => _EnterPinScreenState();
}

class _EnterPinScreenState extends State<EnterPinScreen> {
  String _storedPin = '';
  String _enteredPin = '';
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _loadStoredPin();
  }

  void _loadStoredPin() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _storedPin = prefs.getString('diary_pin') ?? '';
    });
  }

  Future<void> _verifyPin(String pin) async {
    if (_isVerifying) return;

    setState(() {
      _isVerifying = true;
    });

    try {
      if (pin == _storedPin) {
        // PIN is correct, navigate to login screen using GetX
        Get.offAll(() => LoginScreen());
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Incorrect PIN!")),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isVerifying = false;
          _enteredPin = ''; // Clear the entered PIN
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Prevent back button
      child: Scaffold(
        backgroundColor: Colorpallete.bgColor,
        appBar: AppBar(
          title: const Text("Enter PIN"),
          backgroundColor: Colorpallete.backgroundColor,
          foregroundColor: Colorpallete.bottomNavigationColor,
          automaticallyImplyLeading: false, // Remove back button
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Enter your 4-digit PIN to unlock",
                style: TextStyle(
                  color: Colorpallete.textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              PinCodeTextField(
                appContext: context,
                length: 4,
                keyboardType: TextInputType.number,
                obscureText: true, // Hide PIN for security
                enabled: !_isVerifying,
                cursorColor: Colorpallete.bottomNavigationColor,
                textStyle: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colorpallete.bottomNavigationColor,
                ),
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(12),
                  fieldHeight: 55,
                  fieldWidth: 55,
                  activeColor: Colorpallete.bottomNavigationColor,
                  inactiveColor: Colorpallete.drawericonColor,
                  selectedColor: Colorpallete.textColor,
                  activeFillColor: Colorpallete.backgroundColor,
                  inactiveFillColor: Colorpallete.bgColor,
                  selectedFillColor:
                      Colorpallete.bottomNavigationColor.withOpacity(0.2),
                  borderWidth: 2,
                ),
                animationType: AnimationType.scale,
                animationDuration: const Duration(milliseconds: 250),
                onChanged: (value) => _enteredPin = value,
                onCompleted: _verifyPin,
              ),
              if (_isVerifying)
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
