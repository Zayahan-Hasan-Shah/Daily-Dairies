import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_dairies/screens/loginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:daily_dairies/core/colorPallete.dart';
import 'package:go_router/go_router.dart';

class ProfileSectionWidget extends StatefulWidget {
  const ProfileSectionWidget({super.key});

  @override
  _ProfileSectionWidgetState createState() => _ProfileSectionWidgetState();
}

class _ProfileSectionWidgetState extends State<ProfileSectionWidget> {
  User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
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
                    // Update Firestore
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(user!.uid)
                        .update({field.toLowerCase(): newValue});

                    // Update FirebaseAuth only if updating the username
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorpallete.bgColor,
      appBar: AppBar(
        title: const Text("My Profile"),
        foregroundColor: Colorpallete.bottomNavigationColor,
        backgroundColor: Colorpallete.backgroundColor,
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

            TextButton(
              onPressed: () {},
              child: Text(user == null ? "Tap to login" : "Logged in"),
            ),

            const SizedBox(height: 20),

            // Editable Username & Bio
            _buildProfileTile("Username", user?.displayName ?? "No Username",
                editable: true),
            _buildProfileTile(
                "Bio", userData?['bio'] ?? "Each day provides its own gifts.",
                editable: true),
            _buildProfileTile("Account", user?.email ?? "No Account",
                isSignOut: true),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTile(String title, String value,
      {bool editable = false, bool isSignOut = false}) {
    return ListTile(
      title: Text(title),
      subtitle: Text(value),
      trailing: isSignOut
          ? const Icon(Icons.logout,
              color: Colors.red) // Show logout icon for email
          : editable
              ? const Icon(Icons.edit,
                  size: 18) // Show edit icon for username & bio
              : const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: isSignOut
          ? _confirmSignOut
          : (editable ? () => _editDialog(title, value) : null),
    );
  }
}
