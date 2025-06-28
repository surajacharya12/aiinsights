import 'dart:io';
import 'package:aiinsights/backend_call/backend_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aiinsights/Views/dashboard.dart';
import 'package:aiinsights/Views/explore.dart';
import 'package:aiinsights/widgets/AiTools.dart';
import 'package:aiinsights/widgets/appfooter.dart';
import 'package:aiinsights/widgets/createcourse.dart';
import 'package:aiinsights/widgets/input_form.dart';
import 'package:aiinsights/widgets/mainpage.dart';
import 'package:aiinsights/Views/login.dart';

// Import your BackendService class

class Apphome extends StatefulWidget {
  const Apphome({super.key});

  @override
  State<Apphome> createState() => _ApphomeState();
}

class _ApphomeState extends State<Apphome> {
  // User info variables fetched from backend
  String? fullName;
  String? email;
  String? photoUrl;
  bool isLoading = true;
  int? userId;

  final BackendService backendService = BackendService();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    setState(() => isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    final userIdStr = prefs.getString('userId');
    if (userIdStr == null) {
      setState(() {
        userId = null;
        fullName = "Guest User";
        email = null;
        photoUrl = null;
        isLoading = false;
      });
      return;
    }
    try {
      final result = await backendService.getUserProfile(userId: userIdStr);
      if (result['success'] == true && result['user'] != null) {
        final user = result['user'];
        String? photo = user['photo'];
        // Fix: avoid double slash in photo URL
        if (photo != null && photo.isNotEmpty && !photo.startsWith('http')) {
          if (photo.startsWith('/')) {
            photo = "${backendService.baseUrl}" + photo;
          } else {
            photo = "${backendService.baseUrl}/" + photo;
          }
        }
        setState(() {
          userId = user['id'];
          fullName = user['name'] ?? "User";
          email = user['email'];
          photoUrl = photo;
          isLoading = false;
        });
      } else {
        setState(() {
          userId = null;
          fullName = "Unknown User";
          email = null;
          photoUrl = null;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        userId = null;
        fullName = "Unknown User";
        email = null;
        photoUrl = null;
        isLoading = false;
      });
    }
  }

  // Utility to handle profile image safely
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

  // Logout logic
  Future<void> handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.deepPurpleAccent),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: getProfileImage(),
              ),
              accountName: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      fullName ?? "Guest User",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
              accountEmail: isLoading
                  ? null
                  : Text(
                      email ?? "No email",
                      style: const TextStyle(fontSize: 14),
                    ),
            ),

            ListTile(
              leading: const Icon(Icons.add, color: Colors.teal),
              title: const Text("Create Course"),
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

            ListTile(
              leading: const Icon(Icons.dashboard, color: Colors.blueAccent),
              title: const Text("Dashboard"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Dashboard()),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.explore, color: Colors.green),
              title: const Text("Explore"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Explore()),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.quiz, color: Colors.orange),
              title: const Text("Quiz"),
              onTap: () {
                if (email != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InputScreen(profile: null),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please log in again.")),
                  );
                }
              },
            ),

            ListTile(
              leading: const Icon(Icons.smart_toy, color: Colors.purple),
              title: const Text("AI Tools"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AiTools()),
                );
              },
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text(
                "Logout",
                style: TextStyle(color: Colors.redAccent),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Confirm Logout"),
                    content: const Text("Are you sure you want to logout?"),
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
                          handleLogout();
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
      appBar: AppBar(
        title: const Text('Aiinsight'),
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Color.fromARGB(255, 21, 4, 4),
            ),
            iconSize: 30,
            splashColor: Colors.white,
            tooltip: 'Settings',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Settings screen coming soon!")),
              );
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Mainpage(userName: fullName ?? "User")),
          Appfooter(
            userId: userId,
            fullName: fullName,
            email: email,
            photoUrl: photoUrl,
          ),
        ],
      ),
    );
  }
}
