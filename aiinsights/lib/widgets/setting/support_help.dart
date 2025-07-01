import 'package:flutter/material.dart';

class SupportHelpPage extends StatelessWidget {
  const SupportHelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support & Help'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: const [
            Text(
              "How can we help you?",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              "For any support or help, please contact us at:",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            SelectableText(
              "support@aiinsights.com",
              style: TextStyle(fontSize: 16, color: Colors.deepPurple),
            ),
            SizedBox(height: 24),
            Text(
              "Frequently Asked Questions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              "Q: How do I reset my password?\nA: Go to settings > account > reset password.",
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height: 8),
            Text(
              "Q: How do I contact support?\nA: Email us at support@aiinsights.com.",
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height: 8),
            Text(
              "Q: The app is not loading or is slow.\nA: Please check your internet connection and try restarting the app. If the issue persists, contact support.",
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height: 8),
            Text(
              "Q: How do I enroll in a new course?\nA: Go to the Courses section, browse available courses, and tap 'Enroll'.",
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height: 8),
            Text(
              "Q: Where can I find my completed courses?\nA: Navigate to your Profile and select 'My Courses' to view completed and ongoing courses.",
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height: 8),
            Text(
              "Q: How do I report a bug or suggest a feature?\nA: Please email us at support@aiinsights.com with details about the bug or your suggestion.",
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height: 24),
            Text(
              "Need more help?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              "- Visit our website for documentation and updates.\n- Join our community forum to connect with other users.\n- For urgent issues, contact us directly at support@aiinsights.com.",
              style: TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
