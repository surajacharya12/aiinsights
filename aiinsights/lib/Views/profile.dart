import 'dart:io';

import '../Components/colors.dart';
import 'package:flutter/material.dart';

import '../JSON/users.dart';
import '../SQLite/database_helper.dart';
import '../widgets/EditProfile.dart'; // Import the edit screen

class Profile extends StatefulWidget {
  final Users? profile;
  const Profile({super.key, this.profile});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Users? user;
  File? _imageFile;
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    user = widget.profile;
    if (user?.photo != null && user!.photo!.isNotEmpty) {
      _imageFile = File(user!.photo!);
    }
  }

  Future<void> _navigateToEditProfile() async {
    if (user == null) return;

    final updatedUser = await Navigator.push<Users>(
      context,
      MaterialPageRoute(builder: (_) => EditProfile(user: user!)),
    );

    if (updatedUser != null) {
      setState(() {
        user = updatedUser;
        if (user?.photo != null && user!.photo!.isNotEmpty) {
          _imageFile = File(user!.photo!);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasPhoto = _imageFile != null && _imageFile!.existsSync();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 2,
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 1.1),
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _navigateToEditProfile,
            tooltip: 'Edit Profile',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile photo with elegant glow
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                    border: Border.all(color: primaryColor, width: 4),
                  ),
                  child: CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.white,
                    backgroundImage: hasPhoto
                        ? FileImage(_imageFile!)
                        : const AssetImage("assets/no_user.jpg")
                              as ImageProvider,
                  ),
                ),
                const SizedBox(height: 24),

                // Name
                Text(
                  user?.fullName ?? "No Name",
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),

                // Email
                Text(
                  user?.email ?? "No Email",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 30),

                // Divider
                Divider(color: Colors.grey.shade300, thickness: 1.2),
                const SizedBox(height: 30),

                // Full Name card
                _buildInfoCard(
                  icon: Icons.person,
                  title: "Full Name",
                  value: user?.fullName ?? "",
                ),

                // Email card
                _buildInfoCard(
                  icon: Icons.email,
                  title: "Email",
                  value: user?.email ?? "",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      elevation: 4,
      shadowColor: Colors.grey.shade300,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: ListTile(
        leading: Icon(icon, color: primaryColor, size: 32),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          value,
          style: TextStyle(color: Colors.grey.shade800, fontSize: 16),
        ),
      ),
    );
  }
}
