import 'package:aiinsights/Views/thinkbot.dart';
import 'package:aiinsights/Views/profile.dart';
import 'package:aiinsights/widgets/Chat/chatpdf.dart';
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bool isDark = theme.brightness == Brightness.dark;
    final iconColor = isDark ? colorScheme.onSurface : Colors.black;
    final disabledIconColor = isDark ? Colors.grey.shade600 : Colors.grey;
    return Container(
      color: colorScheme.surface,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Home button (No navigation)
          IconButton(
            icon: Icon(Icons.home, color: iconColor),
            onPressed: () {},
          ),

          // Chatbot (Thinkbot)
          IconButton(
            icon: Icon(FontAwesomeIcons.robot, color: iconColor),
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
            icon: Icon(FontAwesomeIcons.filePdf, color: iconColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Chatpdf()),
              );
            },
          ),

          // Profile button
          userId != null && email != null && email!.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.person, color: iconColor),
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
                  icon: Icon(Icons.person, color: disabledIconColor),
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
