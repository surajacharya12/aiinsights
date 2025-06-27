import 'dart:io';
import 'package:aiinsights/Views/dashboard.dart';
import 'package:aiinsights/Views/explore.dart';
import 'package:aiinsights/widgets/AiTools.dart';

import 'package:aiinsights/widgets/appfooter.dart';
import 'package:aiinsights/widgets/createcourse.dart';
import 'package:aiinsights/widgets/input_form.dart';
import 'package:aiinsights/widgets/mainpage.dart';
import 'package:flutter/material.dart';
import 'package:aiinsights/Views/profile.dart';
import 'package:aiinsights/Views/login.dart';
import 'package:aiinsights/JSON/users.dart';

class Apphome extends StatefulWidget {
  final Users? profile;

  const Apphome({super.key, this.profile});

  @override
  State<Apphome> createState() => _ApphomeState();
}

class _ApphomeState extends State<Apphome> {
  @override
  Widget build(BuildContext context) {
    final String? photoPath = widget.profile?.photo;
    final bool hasPhoto = photoPath != null && photoPath.isNotEmpty;

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.deepPurpleAccent),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: hasPhoto
                    ? FileImage(File(photoPath!))
                    : const AssetImage("assets/no_user.jpg") as ImageProvider,
              ),
              accountName: Text(
                widget.profile?.fullName ?? "Guest User",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              accountEmail: Text(
                widget.profile?.email ?? "No email",
                style: const TextStyle(fontSize: 14),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add, color: Colors.teal),
              title: const Text("Create Course"),
              onTap: () {
                final userEmail = widget.profile?.email;
                if (userEmail != null && userEmail.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CreateCourse(userEmail: userEmail.trim()),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InputScreen(
                      profile: widget.profile!,
                    ), // <-- pass profile here
                  ),
                );
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
                          Navigator.of(context).pop(); // close dialog
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                            (route) => false,
                          );
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
            color: Colors.white,
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Column(children: const [Mainpage()]),
            ),
          ),
          Appfooter(profile: widget.profile),
        ],
      ),
    );
  }
}
