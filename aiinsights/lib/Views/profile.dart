import 'dart:io';

import '../Components/colors.dart';
import '../JSON/users.dart';
import '../widgets/EditProfile.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  final int userId;
  final String fullName;
  final String email;
  final String? photoUrl;

  const Profile({
    super.key,
    required this.userId,
    required this.fullName,
    required this.email,
    this.photoUrl,
  });

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late String fullName;
  late String email;
  String? photoUrl;

  @override
  void initState() {
    super.initState();
    fullName = widget.fullName;
    email = widget.email;
    photoUrl = widget.photoUrl;
  }

  @override
  Widget build(BuildContext context) {
    final bool hasNetworkPhoto =
        photoUrl != null &&
        photoUrl!.startsWith("http") &&
        photoUrl!.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 4,
        title: const Text(
          "My Profile",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              // Open EditProfile and update state on return
              final updatedUser = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfile(
                    user: Users(
                      id: widget.userId,
                      name: fullName,
                      email: email,
                      photo: photoUrl,
                    ),
                  ),
                ),
              );
              if (updatedUser != null && mounted) {
                final userObj = updatedUser is Users
                    ? updatedUser
                    : Users.fromJson(updatedUser as Map<String, dynamic>);
                setState(() {
                  fullName = userObj.name;
                  email = userObj.email;
                  photoUrl = userObj.photo;
                });
              }
            },
          ),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(22)),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 18,
                            offset: Offset(0, 6),
                          ),
                        ],
                        border: Border.all(color: primaryColor, width: 3),
                      ),
                      child: CircleAvatar(
                        radius: 75,
                        backgroundColor: Colors.white,
                        backgroundImage: hasNetworkPhoto
                            ? NetworkImage(photoUrl!)
                            : const AssetImage("assets/no_user.jpg")
                                  as ImageProvider,
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () {
                          // Open photo edit
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                Text(
                  fullName,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  email,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 30),

                Divider(thickness: 1.2, color: Colors.grey.shade300),
                const SizedBox(height: 20),

                // Info cards with icons and better spacing
                _buildInfoCard(
                  icon: Icons.person_outline,
                  title: "Full Name",
                  value: fullName,
                ),
                _buildInfoCard(
                  icon: Icons.email_outlined,
                  title: "Email",
                  value: email,
                ),
                _buildInfoCard(
                  icon: Icons.verified_user_outlined,
                  title: "Account Status",
                  value: "Active",
                  iconColor: Colors.green,
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
    Color? iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor ?? primaryColor, size: 30),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Text(
          value,
          style: TextStyle(
            color: Colors.grey.shade800,
            fontSize: 15.5,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: () {
          // Optional: Add navigation or popup
        },
      ),
    );
  }
}
