import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_dairies/core/colorPallete.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:go_router/go_router.dart';
// import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ProfileSectionWidget extends StatefulWidget {
  const ProfileSectionWidget({super.key});

  @override
  _ProfileSectionWidgetState createState() => _ProfileSectionWidgetState();
}

class _ProfileSectionWidgetState extends State<ProfileSectionWidget> {
  User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData;
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _loadImageFromStorage();
  }

  Future<void> _fetchUserData() async {
    if (user == null) return;
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          userData = userDoc.data() as Map<String, dynamic>;
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  Future<void> _loadImageFromStorage() async {
    final dir = await getApplicationDocumentsDirectory();
    final imagePath = File('${dir.path}/profile_image.png');
    if (await imagePath.exists()) {
      setState(() {
        _profileImage = imagePath;
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      final directory = await getApplicationDocumentsDirectory();
      final savedImage =
          await imageFile.copy('${directory.path}/profile_image.png');

      setState(() {
        _profileImage = savedImage;
      });
    }
  }

  Future<void> _removeImage() async {
    final dir = await getApplicationDocumentsDirectory();
    final imagePath = File('${dir.path}/profile_image.png');
    if (await imagePath.exists()) {
      await imagePath.delete();
    }
    setState(() {
      _profileImage = null;
    });
  }

  Future<void> _showImageOptions() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Pick from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              if (_profileImage != null)
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('Remove Photo'),
                  onTap: () {
                    Navigator.pop(context);
                    _removeImage();
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _editDialog(String field, String currentValue) async {
    TextEditingController controller =
        TextEditingController(text: currentValue);

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit $field"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: "Enter your $field"),
            maxLines: 1,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                String newValue = controller.text.trim();
                if (newValue.isNotEmpty && user != null) {
                  try {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(user!.uid)
                        .update({field.toLowerCase(): newValue});

                    if (field == "Username") {
                      await user!.updateDisplayName(newValue);
                      await user!.reload();
                      setState(() {
                        user = FirebaseAuth.instance.currentUser;
                      });
                    }

                    setState(() {
                      userData?[field.toLowerCase()] = newValue;
                    });

                    Navigator.pop(context);
                  } catch (e) {
                    print("Error updating $field: $e");
                  }
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmSignOut() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Sign Out"),
          content: const Text("Are you sure you want to sign out?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  Navigator.pop(context);
                  context.go('/login');
                }
              },
              child: const Text("Sign Out"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProfileTile(String title, String value,
      {bool editable = false, bool isSignOut = false}) {
    return ListTile(
      title: Text(title),
      subtitle: Text(value),
      trailing: isSignOut
          ?  Icon(Icons.logout, color: Colorpallete.disabledErrorColor)
          : editable
              ? const Icon(Icons.edit, size: 18)
              : const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: isSignOut
          ? () => _confirmSignOut()
          : (editable ? () => _editDialog(title, value) : null),
    );
  }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colorpallete.bgColor,
//       appBar: AppBar(
//         title: const Text("My Profile"),
//         foregroundColor: Colorpallete.bottomNavigationColor,
//         backgroundColor: Colorpallete.backgroundColor,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             GestureDetector(
//               onTap: () => _showImageOptions(),
//               child: CircleAvatar(
//                 radius: 50,
//                 backgroundColor: Colors.grey.shade300,
//                 backgroundImage:
//                     _profileImage != null ? FileImage(_profileImage!) : null,
//                 child: _profileImage == null
//                     ? const Icon(Icons.person, size: 50, color: Colors.white)
//                     : null,
//               ),
//             ),
//             const SizedBox(height: 10),
//             TextButton(
//               onPressed: () {},
//               child: Text(user == null ? "Tap to login" : "Logged in"),
//             ),
//             const SizedBox(height: 20),
//             _buildProfileTile("Username", user?.displayName ?? "No Username",
//                 editable: true),
//             _buildProfileTile(
//                 "Bio", userData?['bio'] ?? "Each day provides its own gifts.",
//                 editable: true),
//             _buildProfileTile("Account", user?.email ?? "No Account",
//                 isSignOut: true),
//           ],
//         ),
//       ),
//     );
//   }
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorpallete.bgColor,
      appBar: AppBar(
        title: Text("my_profile".tr),
        foregroundColor: Colorpallete.appBarTextColor,
        backgroundColor: Colorpallete.backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => _showImageOptions(),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey.shade300,
                backgroundImage:
                    _profileImage != null ? FileImage(_profileImage!) : null,
                child: _profileImage == null
                    ? const Icon(Icons.person, size: 50, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {},
              child: Text(user == null ? "tap_to_login".tr : "logged_in".tr),
            ),
            const SizedBox(height: 20),
            _buildProfileTile("username".tr, user?.displayName ?? "No Username",
                editable: true),
            _buildProfileTile("bio".tr, userData?['bio'] ?? "default_bio".tr,
                editable: true),
            _buildProfileTile("account".tr, user?.email ?? "No Account",
                isSignOut: true),
          ],
        ),
      ),
    );
  }
}
