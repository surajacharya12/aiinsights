import 'package:aiinsights/Views/login.dart';
import 'package:flutter/material.dart';
import 'package:aiinsights/widgets/setting/privacy_policy.dart';
import 'package:aiinsights/widgets/setting/support_help.dart';
import 'package:appearance/appearance.dart';
import '../Components/colors.dart';
import '../backend_call/backend_service.dart';
import '../widgets/PasswordChangePage.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;

  void _confirmDeleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Account"),
        content: const Text(
          "Are you sure you want to permanently delete your account? This action cannot be undone.",
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.delete_forever, size: 18),
            label: const Text("Delete"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.of(context).pop(); // Close dialog
              final backend = BackendService();
              // TODO: Replace with your actual userId retrieval logic
              final userId = await _getCurrentUserId();
              final result = await backend.deleteUserAccount(userId: userId);
              if (result['success']) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Account deleted successfully."),
                    ),
                  );
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil('/login', (route) => false);
                }
              } else {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(result['message'] ?? "Delete failed"),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Future<int> _getCurrentUserId() async {
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    final appearance = Appearance.of(context);
    final isDark = appearance?.mode == ThemeMode.dark;
    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : const Color(0xFFF2F3F7),
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.deepPurpleAccent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(22)),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: [
          Text(
            "Account",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black54,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 10),
          _buildSettingsTile(
            icon: Icons.lock_outline,
            title: "Change Password",
            onTap: () async {
              // TODO: Replace with actual userId retrieval logic
              final userId = await _getCurrentUserId();
              if (!mounted) return;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PasswordChangePage(userId: userId),
                ),
              );
            },
          ),
          _buildSettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: "Privacy",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrivacyPolicyPage(),
                ),
              );
            },
          ),
          _buildSettingsTile(
            icon: Icons.notifications_outlined,
            title: "Notifications",
            trailing: Switch(
              value: notificationsEnabled,
              onChanged: (val) {
                setState(() {
                  notificationsEnabled = val;
                });
              },
              activeColor: primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "General",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black54,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 10),
          _buildSettingsTile(
            icon: Icons.brightness_6_outlined,
            title: "Dark Mode",
            trailing: Switch(
              value: isDark,
              onChanged: (val) {
                appearance?.setMode(val ? ThemeMode.dark : ThemeMode.light);
                setState(() {});
              },
              activeColor: primaryColor,
            ),
          ),
          _buildSettingsTile(
            icon: Icons.help_outline,
            title: "Help & Support",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SupportHelpPage(),
                ),
              );
            },
          ),
          const SizedBox(height: 30),
          Center(
            child: ElevatedButton.icon(
              onPressed: () => _confirmDeleteAccount(context),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.delete_forever),
              label: const Text("Delete Account"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: Icon(icon, color: primaryColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
