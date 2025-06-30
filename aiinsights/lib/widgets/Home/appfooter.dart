import 'package:aiinsights/Views/thinkbot.dart';
import 'package:aiinsights/Views/profile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Appfooter extends StatelessWidget {
  final int? userId;
  final String? fullName;
  final String? email;
  final String? photoUrl;

  const Appfooter({
    super.key,
    this.userId,
    this.fullName,
    this.email,
    this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Home button (No navigation)
          IconButton(
            icon: const Icon(Icons.home, color: Colors.black),
            onPressed: () {},
          ),

          // Chatbot (Thinkbot)
          IconButton(
            icon: const Icon(FontAwesomeIcons.robot, color: Colors.black),
            onPressed: () {
              if (email != null && email!.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatbotScreen()),
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
          userId != null && email != null && email!.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.person, color: Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Profile(
                          userId: userId!,
                          fullName: fullName ?? "User",
                          email: email!,
                          photoUrl: photoUrl,
                        ),
                      ),
                    );
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.person, color: Colors.grey),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("User profile not found. Please log in."),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
