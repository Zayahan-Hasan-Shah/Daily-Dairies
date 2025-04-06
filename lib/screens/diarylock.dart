// import 'package:daily_dairies/controllers/lockServices.dart';
// import 'package:daily_dairies/core/colorPallete.dart';
// import 'package:daily_dairies/screens/SetPatternScreen.dart';
// import 'package:daily_dairies/screens/SetPinScreen.dart';
// import 'package:daily_dairies/widgets/app_drawer.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:get/get.dart';

// class DiarylockScreen extends StatefulWidget {
//   static Route route() =>
//       MaterialPageRoute(builder: (_) => const DiarylockScreen());
//   const DiarylockScreen({super.key});

//   @override
//   State<DiarylockScreen> createState() => _DiarylockScreenState();
// }

// class _DiarylockScreenState extends State<DiarylockScreen> {
//   final LockServices _lockServices = Get.find<LockServices>();
//   bool isDiaryLockEnabled = false;

//   @override
//   void initState() {
//     super.initState();
//     // Load the biometric state when screen initializes
//     _lockServices.loadBiometricState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colorpallete.bgColor,
//       appBar: AppBar(
//         title: const Text("Set Diary Lock"),
//         foregroundColor: Colorpallete.bottomNavigationColor,
//         backgroundColor: Colorpallete.backgroundColor,
//       ),
//       drawer: const AppDrawer(),
//       body: SingleChildScrollView( // Wrap with SingleChildScrollView to prevent overflow
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             mainAxisSize: MainAxisSize.min, // Add this to prevent unnecessary expansion
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildToggleSwitch(),
//               const SizedBox(height: 20),
//               if (isDiaryLockEnabled) _buildLockOptions(context)
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildToggleSwitch() {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           const Text(
//             "Diary Lock",
//             style: TextStyle(fontSize: 18, color: Colors.white),
//           ),
//           Switch(
//             value: isDiaryLockEnabled,
//             activeColor: Colors.blue,
//             activeTrackColor: Colorpallete.backgroundColor,
//             inactiveThumbColor: Colors.blue,
//             inactiveTrackColor: Colors.grey[200],
//             onChanged: (bool value) {
//               setState(() {
//                 isDiaryLockEnabled = value;
//               });

//               if (value) {
//                 _navigateToLockSetup();
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLockOptions(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min, // Add this to prevent unnecessary expansion
//       children: [
//         ListTile(
//           title: const Text(
//             "Set Pattern Lock",
//             style: TextStyle(color: Colors.white),
//           ),
//           trailing: const Icon(Icons.chevron_right, color: Colors.blue),
//           onTap: () => Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => const SetPatternScreen()),
//           ),
//         ),
//         ListTile(
//           title: const Text(
//             "Set PIN Code",
//             style: TextStyle(color: Colors.white),
//           ),
//           trailing: const Icon(Icons.chevron_right, color: Colors.blue),
//           onTap: () => Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => const SetPinScreen()),
//           ),
//         ),
//         Obx(() => ListTile(
//           title: const Text(
//             "Enable Biometric For Login",
//             style: TextStyle(color: Colors.white),
//           ),
//           trailing: Switch(
//             value: _lockServices.isBiometricSet,
//             activeColor: Colors.blue,
//             activeTrackColor: Colorpallete.backgroundColor,
//             inactiveThumbColor: Colors.blue,
//             inactiveTrackColor: Colors.grey[200],
//             onChanged: (bool value) {
//               _lockServices.setBiometricState(value);
//             },
//           ),
//         )),
//       ],
//     );
//   }

//   void _navigateToLockSetup() {
//     Future.delayed(const Duration(milliseconds: 300), () {
//       context.push('/setPattern');
//     });
//   }
// }

import 'package:daily_dairies/controllers/biometric_controller.dart';
import 'package:daily_dairies/core/colorPallete.dart';
import 'package:daily_dairies/screens/SetPatternScreen.dart';
import 'package:daily_dairies/screens/SetPinScreen.dart';
import 'package:daily_dairies/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';

class DiarylockScreen extends StatefulWidget {
  static Route route() =>
      MaterialPageRoute(builder: (_) => const DiarylockScreen());
  const DiarylockScreen({super.key});

  @override
  State<DiarylockScreen> createState() => _DiarylockScreenState();
}

class _DiarylockScreenState extends State<DiarylockScreen> {
  final BiometricServices _biometricServices = Get.find<BiometricServices>();
  bool isDiaryLockEnabled = false;

  @override
  void initState() {
    super.initState();
    // Load the biometric state when screen initializes
    _biometricServices.loadBiometricState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorpallete.bgColor,
      appBar: AppBar(
        title: const Text("Set Diary Lock"),
        foregroundColor: Colorpallete.bottomNavigationColor,
        backgroundColor: Colorpallete.backgroundColor,
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        // Wrap with SingleChildScrollView to prevent overflow
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize:
                MainAxisSize.min, // Add this to prevent unnecessary expansion
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildToggleSwitch(),
              const SizedBox(height: 20),
              if (isDiaryLockEnabled) _buildLockOptions(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleSwitch() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Diary Lock",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          Switch(
            value: isDiaryLockEnabled,
            activeColor: Colors.blue,
            activeTrackColor: Colorpallete.backgroundColor,
            inactiveThumbColor: Colors.blue,
            inactiveTrackColor: Colors.grey[200],
            onChanged: (bool value) {
              setState(() {
                isDiaryLockEnabled = value;
              });

              if (value) {
                _navigateToLockSetup();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLockOptions(BuildContext context) {
    return Column(
      mainAxisSize:
          MainAxisSize.min, // Add this to prevent unnecessary expansion
      children: [
        ListTile(
          title: const Text(
            "Set Pattern Lock",
            style: TextStyle(color: Colors.white),
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.blue),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SetPatternScreen()),
          ),
        ),
        ListTile(
          title:
              const Text("Set Pin Lock", style: TextStyle(color: Colors.white)),
          trailing: const Icon(Icons.chevron_right, color: Colors.blue),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SetPinScreen()),
          ),
        ),
        Obx(() => ListTile(
              title: const Text(
                "Enable Biometric For Login",
                style: TextStyle(color: Colors.white),
              ),
              trailing: Switch(
                value: _biometricServices.isBiometricSet,
                activeColor: Colors.blue,
                activeTrackColor: Colorpallete.backgroundColor,
                inactiveThumbColor: Colors.blue,
                inactiveTrackColor: Colors.grey[200],
                onChanged: (bool value) {
                  _biometricServices.setBiometricState(value);
                },
              ),
            )),
      ],
    );
  }

  void _navigateToLockSetup() {
    Future.delayed(const Duration(milliseconds: 300), () {
      context.push('/setPattern');
    });
  }
}
