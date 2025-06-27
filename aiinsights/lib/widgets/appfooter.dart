import 'package:aiinsights/Views/thinkbot.dart';
import 'package:aiinsights/Views/profile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../JSON/users.dart';

class Appfooter extends StatelessWidget {
  final Users? profile;

  const Appfooter({super.key, this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // <-- corrected here
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Home button (No navigation)
          IconButton(
            icon: const Icon(Icons.home, color: Colors.black),
            onPressed: () {
              // Home button (No navigation)
            },
          ),

          // Chatbot (Thinkbot)
          IconButton(
            icon: const Icon(FontAwesomeIcons.robot, color: Colors.black),
            onPressed: () {
              if (profile != null) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatbotScreen(profile: profile!),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("User profile not found.")),
                );
              }
            },
          ),

          // PDF button
          IconButton(
            icon: const Icon(FontAwesomeIcons.filePdf, color: Colors.black),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("PDF screen coming soon.")),
              );
            },
          ),

          // Profile button
          IconButton(
            icon: const Icon(Icons.person, color: Colors.black),
            onPressed: () {
              if (profile != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Profile(profile: profile!),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("User profile not found.")),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
