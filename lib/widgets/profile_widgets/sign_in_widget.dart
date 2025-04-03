// import 'package:daily_dairies/core/colorPallete.dart';
// import 'package:flutter/material.dart';

// class SignInWidget extends StatelessWidget {
//   const SignInWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: GestureDetector(
//         onTap: () {},
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(50), color: Colors.white),
//               child: Icon(
//                 Icons.person,
//                 size: 40,
//                 color: Colorpallete.bgColor,
//               ),
//             ),
//             const SizedBox(
//               width: 8,
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Sign In',
//                   style: TextStyle(
//                     color: Colorpallete.backgroundColor,
//                     fontSize: 20,
//                     fontFamily: 'Poppins',
//                     fontWeight: FontWeight.w900,
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 2,
//                 ),
//                 const Text(
//                   'Write diary everyday to remember ',
//                   style: TextStyle(
//                     fontSize: 14,
//                   ),
//                 )
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:daily_dairies/core/colorPallete.dart';

class SignInWidget extends StatelessWidget {
  const SignInWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser; // Get current user

    return GestureDetector(
      onTap: () {
        context.push('/profilesection'); // Navigate to Profile Screen
      },
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.white,
            ),
            child: user?.photoURL != null
                ? CircleAvatar(
                    radius: 20,
                    backgroundImage:
                        NetworkImage(user!.photoURL!), // Show profile pic
                  )
                : Icon(Icons.person, size: 40, color: Colorpallete.bgColor),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user?.displayName ?? 'Sign In', // Show full name if logged in
                style: TextStyle(
                  color: Colorpallete.backgroundColor,
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                user != null
                    ? "View and edit your profile"
                    : "Write diary everyday to remember",
                style: const TextStyle(fontSize: 14),
              ),
            ],
          )
        ],
      ),
    );
  }
}
