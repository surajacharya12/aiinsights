import 'dart:io';
import 'package:aiinsights/Views/settings_page.dart';
import 'package:aiinsights/widgets/Home/AppSidebar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aiinsights/backend_call/backend_service.dart';
import 'package:aiinsights/widgets/Home/appfooter.dart';
import 'package:aiinsights/widgets/Home/mainpage.dart';
import 'package:aiinsights/Views/login.dart';

class Apphome extends StatefulWidget {
  const Apphome({super.key});

  @override
  State<Apphome> createState() => _ApphomeState();
}

class _ApphomeState extends State<Apphome> {
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
      drawer: AppDrawer(
        fullName: fullName,
        email: email,
        photoUrl: photoUrl,
        userId: userId,
        backendService: backendService,
        onLogout: handleLogout,
      ),
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.school, color: Colors.green),
            SizedBox(width: 8),
            const Text('Aiinsight'),
          ],
        ),
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
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
