import 'package:flutter/material.dart';
import '../Components/colors.dart';
import '../backend_call/backend_service.dart';

class PasswordChangePage extends StatefulWidget {
  final int userId;
  const PasswordChangePage({super.key, required this.userId});

  @override
  State<PasswordChangePage> createState() => _PasswordChangePageState();
}

class _PasswordChangePageState extends State<PasswordChangePage> {
  String _currentPassword = '';
  String _newPassword = '';
  String _confirmPassword = '';
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  final BackendService backendService = BackendService();

  Future<void> _changePassword() async {
    if (_newPassword.isEmpty ||
        _currentPassword.isEmpty ||
        _confirmPassword.isEmpty) {
      _showSnackbar('Please fill all fields');
      return;
    }

    if (_newPassword != _confirmPassword) {
      _showSnackbar('New passwords do not match');
      return;
    }

    if (_newPassword.length < 6) {
      _showSnackbar('Password must be at least 6 characters');
      return;
    }

    try {
      final result = await backendService.updateUserProfile(
        userId: widget.userId,
        name: '',
        email: '',
        password: _newPassword,
        currentPassword: _currentPassword,
      );
      if (result['success'] == true) {
        _showSnackbar('Password changed successfully');
        Navigator.pop(context);
      } else {
        _showSnackbar(result['message'] ?? 'Failed to change password');
      }
    } catch (e) {
      _showSnackbar('Failed to change password: $e');
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildPasswordField({
    required String label,
    required bool obscureText,
    required ValueChanged<String> onChanged,
    required VoidCallback toggleVisibility,
    IconData icon = Icons.lock_outline,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: TextField(
        obscureText: obscureText,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontWeight: FontWeight.w500),
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
          prefixIcon: Icon(icon, color: primaryColor),
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              color: primaryColor,
            ),
            onPressed: toggleVisibility,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(Icons.lock_reset, size: 70, color: primaryColor),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                "Update Your Password",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
            ),
            const SizedBox(height: 30),

            _buildPasswordField(
              label: "Current Password",
              obscureText: _obscureCurrent,
              onChanged: (val) => setState(() => _currentPassword = val),
              toggleVisibility: () =>
                  setState(() => _obscureCurrent = !_obscureCurrent),
            ),

            _buildPasswordField(
              label: "New Password",
              obscureText: _obscureNew,
              onChanged: (val) => setState(() => _newPassword = val),
              toggleVisibility: () =>
                  setState(() => _obscureNew = !_obscureNew),
            ),

            _buildPasswordField(
              label: "Confirm New Password",
              obscureText: _obscureConfirm,
              onChanged: (val) => setState(() => _confirmPassword = val),
              toggleVisibility: () =>
                  setState(() => _obscureConfirm = !_obscureConfirm),
            ),

            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check_circle_outline),
                label: const Text(
                  "CHANGE PASSWORD",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
                onPressed: _changePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
