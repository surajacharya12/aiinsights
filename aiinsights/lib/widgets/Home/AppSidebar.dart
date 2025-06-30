import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aiinsights/Views/dashboard.dart';
import 'package:aiinsights/Views/explore.dart';
import 'package:aiinsights/Views/login.dart';
import 'package:aiinsights/widgets/CreateNewCourse/AddCourse.dart';
import 'package:aiinsights/widgets/Quiz/input_form.dart';
import 'package:aiinsights/widgets/AiTools/AiTools.dart';
import 'package:aiinsights/backend_call/backend_service.dart';

class AppDrawer extends StatelessWidget {
  final String? fullName;
  final String? email;
  final String? photoUrl;
  final int? userId;
  final BackendService backendService;
  final Future<void> Function() onLogout;

  const AppDrawer({
    Key? key,
    required this.fullName,
    required this.email,
    required this.photoUrl,
    required this.userId,
    required this.backendService,
    required this.onLogout,
  }) : super(key: key);

  ImageProvider getProfileImage() {
    if (photoUrl != null && photoUrl!.isNotEmpty) {
      if (photoUrl!.startsWith("http")) {
        return NetworkImage(photoUrl!);
      } else {
        try {
          final file = File(photoUrl!);
          if (file.existsSync()) return FileImage(file);
        } catch (_) {}
      }
    }
    return const AssetImage("assets/no_user.jpg");
  }

  Widget buildListTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? subtitle,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(8),
        child: Icon(icon, color: iconColor, size: 28),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4,
          color: Colors.deepPurpleAccent,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                fontSize: 13,
                color: Colors.deepPurpleAccent.withOpacity(0.7),
              ),
            )
          : null,
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 18,
        color: Colors.deepPurpleAccent.withOpacity(0.7),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
      hoverColor: Colors.deepPurpleAccent.withOpacity(0.1),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Drawer(
      elevation: 20,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              top: statusBarHeight + 16,
              left: 20,
              right: 20,
              bottom: 25,
            ),
            decoration: BoxDecoration(
              color: Colors.deepPurpleAccent,
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurpleAccent.withOpacity(0.6),
                  offset: const Offset(0, 3),
                  blurRadius: 8,
                ),
              ],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 38,
                  backgroundColor: Colors.white,
                  backgroundImage: getProfileImage(),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fullName ?? "Guest User",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.7,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        email ?? "No email available",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.85),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              color: Colors.white,
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 12),
                children: [
                  buildListTile(
                    context: context,
                    icon: Icons.add,
                    iconColor: Colors.teal,
                    title: "Create Course",
                    subtitle: "Start a new learning journey",
                    onTap: () {
                      if (email != null && email!.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CreateCourse(userEmail: email!.trim()),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'User email not found, please login again.',
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  buildListTile(
                    context: context,
                    icon: Icons.dashboard,
                    iconColor: Colors.blueAccent,
                    title: "Dashboard",
                    subtitle: "Your course overview & stats",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Dashboard(),
                        ),
                      );
                    },
                  ),
                  buildListTile(
                    context: context,
                    icon: Icons.explore,
                    iconColor: Colors.green,
                    title: "Explore",
                    subtitle: "Discover new courses & content",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Explore(),
                        ),
                      );
                    },
                  ),
                  buildListTile(
                    context: context,
                    icon: Icons.quiz,
                    iconColor: Colors.orange,
                    title: "Quiz",
                    subtitle: "Test your knowledge",
                    onTap: () {
                      if (email != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InputScreen(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please log in again.")),
                        );
                      }
                    },
                  ),
                  buildListTile(
                    context: context,
                    icon: Icons.smart_toy,
                    iconColor: Colors.purple,
                    title: "AI Tools",
                    subtitle: "Explore AI-powered tools",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AiTools(),
                        ),
                      );
                    },
                  ),
                  const Divider(thickness: 1, indent: 40, endIndent: 40),
                  buildListTile(
                    context: context,
                    icon: Icons.logout,
                    iconColor: Colors.redAccent,
                    title: "Logout",
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Confirm Logout"),
                          content: const Text(
                            "Are you sure you want to logout?",
                          ),
                          actions: [
                            TextButton(
                              child: const Text("Cancel"),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.logout, size: 18),
                              label: const Text("Logout"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                onLogout();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
