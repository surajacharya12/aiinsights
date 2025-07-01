import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  Text _buildHeader(String text, {required bool isDark}) => Text(
    text,
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: isDark ? Colors.white : Colors.black87,
    ),
  );

  Text _buildBody(String text, {required bool isDark}) => Text(
    text,
    style: TextStyle(
      fontSize: 16,
      height: 1.5,
      color: isDark ? Colors.white : Colors.black87,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Text(
              "Privacy Policy",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            _buildBody(
              'AIInsights Academy ("we", "us", or "our") is committed to protecting your privacy. '
              'This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our application and services.',
              isDark: isDark,
            ),
            const SizedBox(height: 20),

            _buildHeader("1. Information We Collect", isDark: isDark),
            const SizedBox(height: 8),
            _buildBody(
              "• Personal Information: We may collect your name, email address, profile photo, and other information you provide.",
              isDark: isDark,
            ),
            _buildBody(
              "• Usage Data: We collect information about your interactions with the app, such as courses viewed, quizzes taken, and chat messages.",
              isDark: isDark,
            ),
            _buildBody(
              "• Files and Media: If you upload files (such as PDFs or images), we store and process them to provide services.",
              isDark: isDark,
            ),
            _buildBody(
              "• Device Information: Includes device type, operating system, and unique device identifiers.",
              isDark: isDark,
            ),

            const SizedBox(height: 20),
            _buildHeader("2. How We Use Your Information", isDark: isDark),
            const SizedBox(height: 8),
            _buildBody(
              "• Provide, operate, and maintain our services.",
              isDark: isDark,
            ),
            _buildBody(
              "• Personalize your experience and improve our platform.",
              isDark: isDark,
            ),
            _buildBody(
              "• Communicate updates, support, and important notices.",
              isDark: isDark,
            ),
            _buildBody(
              "• Analyze usage to enhance features and security.",
              isDark: isDark,
            ),

            const SizedBox(height: 20),
            _buildHeader("3. How We Share Your Information", isDark: isDark),
            const SizedBox(height: 8),
            _buildBody(
              "• We do not sell your personal information.",
              isDark: isDark,
            ),
            _buildBody(
              "• We may share with service providers who help operate our platform (e.g., hosting, analytics).",
              isDark: isDark,
            ),
            _buildBody(
              "• When required by law or to protect our rights and users.",
              isDark: isDark,
            ),
            _buildBody("• With your consent or direction.", isDark: isDark),

            const SizedBox(height: 20),
            _buildHeader("4. Data Security", isDark: isDark),
            const SizedBox(height: 8),
            _buildBody(
              "We implement reasonable security measures to protect your data. "
              "However, no method of transmission or storage is 100% secure, and we cannot guarantee absolute security.",
              isDark: isDark,
            ),

            const SizedBox(height: 20),
            _buildHeader("5. Your Choices", isDark: isDark),
            const SizedBox(height: 8),
            _buildBody(
              "• You can update your profile information at any time.",
              isDark: isDark,
            ),
            _buildBody(
              "• You may delete your account to remove your personal data from our systems.",
              isDark: isDark,
            ),
            _buildBody(
              "• You can contact us for any privacy-related questions or requests.",
              isDark: isDark,
            ),

            const SizedBox(height: 20),
            _buildHeader("6. Children's Privacy", isDark: isDark),
            const SizedBox(height: 8),
            _buildBody(
              "Our services are not intended for children under 13. "
              "We do not knowingly collect data from children under 13.",
              isDark: isDark,
            ),

            const SizedBox(height: 20),
            _buildHeader("7. Changes to This Policy", isDark: isDark),
            const SizedBox(height: 8),
            _buildBody(
              "We may update this Privacy Policy from time to time. "
              "Changes will be notified by updating the effective date and, if significant, by providing a notice in the app.",
              isDark: isDark,
            ),

            const SizedBox(height: 20),
            _buildHeader("8. Contact Us", isDark: isDark),
            const SizedBox(height: 8),
            _buildBody(
              "If you have any questions or concerns, contact us at:",
              isDark: isDark,
            ),
            const SizedBox(height: 4),
            Text(
              "Email: support@aiinsights.academy",
              style: TextStyle(
                fontSize: 16,
                color: Colors.deepPurple,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
