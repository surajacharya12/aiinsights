import 'dart:io';

import '../Components/colors.dart';
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bool hasNetworkPhoto =
        photoUrl != null &&
        photoUrl!.startsWith("http") &&
        photoUrl!.isNotEmpty;

    return Scaffold(
      backgroundColor: colorScheme.background,
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
                    user: {
                      'id': widget.userId,
                      'name': fullName,
                      'email': email,
                      'photo': photoUrl,
                    },
                  ),
                ),
              );
              if (updatedUser != null && mounted) {
                final userObj = updatedUser as Map<String, dynamic>;
                setState(() {
                  fullName = userObj['name'] ?? fullName;
                  email = userObj['email'] ?? email;
                  photoUrl = userObj['photo'] ?? photoUrl;
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
                // Modern Profile Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.account_circle_rounded,
                      color: theme.colorScheme.primary,
                      size: 36,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Profile Overview",
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.brightness == Brightness.dark
                            ? Colors.white
                            : Colors.grey.shade800,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26.withOpacity(
                              theme.brightness == Brightness.dark ? 0.5 : 1,
                            ),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                        border: Border.all(
                          color: theme.colorScheme.primary,
                          width: 3,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 75,
                        backgroundColor: colorScheme.surface,
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
                            color: theme.colorScheme.primary,
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
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  email,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.brightness == Brightness.dark
                        ? Colors.grey.shade300
                        : Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 30),

                Divider(thickness: 1.2, color: theme.dividerColor),
                const SizedBox(height: 20),

                // Info cards with icons and better spacing
                _buildInfoCard(
                  context: context,
                  icon: Icons.person_outline,
                  title: "Full Name",
                  value: fullName,
                ),
                _buildInfoCard(
                  context: context,
                  icon: Icons.email_outlined,
                  title: "Email",
                  value: email,
                ),
                _buildInfoCard(
                  context: context,
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
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    Color? iconColor,
  }) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: iconColor ?? theme.colorScheme.primary,
          size: 30,
        ),
        title: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.brightness == Brightness.dark
                ? Colors.grey.shade200
                : Colors.grey.shade800,
            fontSize: 15.5,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: theme.brightness == Brightness.dark
              ? Colors.grey.shade400
              : Colors.grey,
        ),
        onTap: () {
          // Optional: Add navigation or popup
        },
      ),
    );
  }
}
