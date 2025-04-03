import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:daily_dairies/core/colorPallete.dart';

class ProfileSectionWidget extends StatelessWidget {
  const ProfileSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorpallete.bgColor,
      appBar: AppBar(
        title: const Text("My Profile"),
        foregroundColor: Colorpallete.bottomNavigationColor,
        backgroundColor: Colorpallete.backgroundColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.pushReplacement('/settings'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture
            GestureDetector(
              onTap: () {},
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey.shade300,
                child: const Icon(Icons.person, size: 50, color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(onPressed: () {}, child: const Text("Tap to login")),

            const SizedBox(height: 20),

            // Username
            _buildProfileTile("Username", "No Username"),
            _buildProfileTile("Bio", "No Bio"),
            _buildProfileTile("Account", "No Account"),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTile(String title, String value) {
    return ListTile(
      title: Text(title),
      subtitle: Text(value),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {},
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class ProfileController extends GetxController {
//   var isLoggedIn = false.obs;
//   var username = "".obs;
//   var bio = "".obs;
//   var email = "".obs;
//   var profileImage = "".obs;

//   void login() {
//     // Mock login logic
//     isLoggedIn.value = true;
//     username.value = "Hassam Arshad";
//     bio.value = "Each day provides its own gifts.";
//     email.value = "animeboi2174@gmail.com";
//     profileImage.value =
//         "https://your-image-url.com/profile.jpg"; // Replace with actual image URL
//   }

//   void logout() {
//     isLoggedIn.value = false;
//     username.value = "";
//     bio.value = "";
//     email.value = "";
//     profileImage.value = "";
//   }

//   void updateBio(String newBio) {
//     bio.value = newBio;
//   }

//   void updateUsername(String newUsername) {
//     username.value = newUsername;
//   }
// }

// class ProfileScreen extends StatelessWidget {
//   final ProfileController controller = Get.put(ProfileController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("My Profile")),
//       body: Obx(() {
//         return Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               GestureDetector(
//                 onTap: () =>
//                     controller.isLoggedIn.value ? null : controller.login(),
//                 child: CircleAvatar(
//                   radius: 50,
//                   backgroundImage: controller.isLoggedIn.value &&
//                           controller.profileImage.isNotEmpty
//                       ? NetworkImage(controller.profileImage.value)
//                       : null,
//                   child: controller.isLoggedIn.value
//                       ? null
//                       : Icon(Icons.add, size: 40),
//                 ),
//               ),
//               SizedBox(height: 10),
//               TextButton(
//                 onPressed: () {},
//                 child: Text(controller.isLoggedIn.value
//                     ? "Edit photo"
//                     : "Tap to login"),
//               ),
//               SizedBox(height: 20),
//               _buildEditableField("Username", controller.username, (newValue) {
//                 controller.updateUsername(newValue);
//               }),
//               _buildEditableField("Bio", controller.bio, (newValue) {
//                 controller.updateBio(newValue);
//               }),
//               _buildAccountSection(),
//             ],
//           ),
//         );
//       }),
//     );
//   }

//   Widget _buildEditableField(
//       String label, RxString value, Function(String) onUpdate) {
//     return ListTile(
//       title: Text(label),
//       subtitle: Obx(() => Text(value.isNotEmpty ? value.value : "No $label")),
//       trailing: Icon(Icons.arrow_forward_ios, size: 16),
//       onTap: () {
//         Get.defaultDialog(
//           title: label,
//           content: TextField(
//             controller: TextEditingController(text: value.value),
//             onSubmitted: (newValue) {
//               onUpdate(newValue);
//               Get.back();
//             },
//           ),
//           confirm: TextButton(
//             onPressed: () {
//               Get.back();
//             },
//             child: Text("Save"),
//           ),
//           cancel: TextButton(
//             onPressed: () {
//               Get.back();
//             },
//             child: Text("Cancel"),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildAccountSection() {
//     return ListTile(
//       title: Text("Account"),
//       subtitle: Obx(() => Text(
//           controller.isLoggedIn.value ? controller.email.value : "No Account")),
//       trailing: controller.isLoggedIn.value
//           ? PopupMenuButton<String>(
//               onSelected: (value) {
//                 if (value == "sign_out") controller.logout();
//               },
//               itemBuilder: (context) => [
//                 PopupMenuItem(value: "sign_out", child: Text("Sign out")),
//               ],
//             )
//           : null,
//     );
//   }
// }
