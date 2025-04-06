// import 'package:flutter/material.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:daily_dairies/core/colorPallete.dart';

// class SetPinScreen extends StatefulWidget {
//   const SetPinScreen({super.key});

//   @override
//   State<SetPinScreen> createState() => _SetPinScreenState();
// }

// class _SetPinScreenState extends State<SetPinScreen> {
//   String _pin = '';

//   void _savePin(String pin) async {
//     print(pin);
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('diary_pin', pin); // Save PIN
//     Navigator.pop(context); // Go back after setting PIN
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colorpallete.bgColor,
//       appBar: AppBar(
//         title: const Text("Set PIN Code"),
//         foregroundColor: Colorpallete.bottomNavigationColor,
//         backgroundColor: Colorpallete.backgroundColor,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 24.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               "Enter a 4-digit PIN",
//               style: TextStyle(
//                 color: Colorpallete.textColor,
//                 fontSize: 18,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const SizedBox(height: 20),
//             PinCodeTextField(
//               appContext: context,
//               length: 4,
//               keyboardType: TextInputType.number,
//               cursorColor: Colorpallete.bottomNavigationColor,
//               obscureText: false, // Show the numbers instead of dots
//               textStyle: TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//                 color: Colorpallete.bottomNavigationColor,
//               ),
//               pinTheme: PinTheme(
//                 shape: PinCodeFieldShape.box,
//                 borderRadius: BorderRadius.circular(12), // Rounded corners
//                 fieldHeight: 55,
//                 fieldWidth: 55,
//                 activeColor: Colorpallete.bottomNavigationColor,
//                 inactiveColor: Colorpallete.drawericonColor,
//                 selectedColor: Colorpallete.textColor,
//                 activeFillColor: Colorpallete.backgroundColor,
//                 inactiveFillColor: Colorpallete.bgColor,
//                 selectedFillColor:
//                     Colorpallete.bottomNavigationColor.withOpacity(0.2),
//                 borderWidth: 2,
//               ),
//               animationType: AnimationType.scale,
//               animationDuration: const Duration(milliseconds: 250),
//               onChanged: (value) {
//                 _pin = value;
//               },
//               onCompleted: (value) {
//                 _savePin(value);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:daily_dairies/core/colorPallete.dart';

class SetPinScreen extends StatefulWidget {
  const SetPinScreen({super.key});

  @override
  State<SetPinScreen> createState() => _SetPinScreenState();
}

class _SetPinScreenState extends State<SetPinScreen> {
  String _pin = '';

  void _savePin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('diary_pin', pin); // Save PIN
    Navigator.pop(context); // Go back
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorpallete.bgColor,
      appBar: AppBar(
        title: const Text("Set PIN Code"),
        backgroundColor: Colorpallete.backgroundColor,
        foregroundColor: Colorpallete.bottomNavigationColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Enter a 4-digit PIN",
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
              cursorColor: Colorpallete.bottomNavigationColor,
              obscureText: false,
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
              onChanged: (value) => _pin = value,
              onCompleted: _savePin,
            ),
          ],
        ),
      ),
    );
  }
}
