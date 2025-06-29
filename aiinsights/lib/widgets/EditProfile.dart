import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../Components/colors.dart';
import '../backend_call/backend_service.dart';

class EditProfile extends StatefulWidget {
  final Map<String, dynamic> user;
  const EditProfile({super.key, required this.user});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  String _newPassword = '';
  String _currentPassword = '';
  bool _obscurePassword = true;
  bool _obscureCurrentPassword = true;

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  final BackendService backendService = BackendService();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user['name'] ?? '');
    _emailController = TextEditingController(text: widget.user['email'] ?? '');
    if (widget.user['photo'] != null &&
        (widget.user['photo'] as String).isNotEmpty) {
      _imageFile = File(widget.user['photo']);
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final Directory appDir = await getApplicationDocumentsDirectory();
        final String fileName = p.basename(pickedFile.path);

        final File localImage = await File(
          pickedFile.path,
        ).copy('${appDir.path}/$fileName');

        setState(() {
          _imageFile = localImage;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to pick image: $e')));
    }
  }

  Future<void> _saveProfile() async {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String newPassword = _newPassword.trim();
    String currentPassword = _currentPassword.trim();

    if (name.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }
    if (newPassword.isNotEmpty && currentPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter your current password to change password.'),
        ),
      );
      return;
    }

    try {
      // If image changed, upload it first
      Map<String, dynamic>? photoResult;
      String? newPhoto = widget.user['photo'];
      if (_imageFile != null &&
          _imageFile!.path != (widget.user['photo'] ?? '')) {
        photoResult = await backendService.uploadUserPhoto(
          userId: widget.user['id'],
          imageFile: _imageFile!,
        );
        if (photoResult['success'] != true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(photoResult['message'] ?? 'Photo upload failed'),
            ),
          );
          return;
        }
        newPhoto = photoResult['user']?['photo'] ?? newPhoto;
      }

      // Update user profile in backend
      final updateResult = await backendService.updateUserProfile(
        userId: widget.user['id'],
        name: name,
        email: email,
        photo: newPhoto,
        password: newPassword.isNotEmpty ? newPassword : null,
        currentPassword: newPassword.isNotEmpty ? currentPassword : null,
      );

      if (updateResult['success'] == true) {
        Navigator.of(context).pop(updateResult['user']);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(updateResult['message'] ?? 'Failed to save profile'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to save profile: $e')));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool hasPhoto = _imageFile != null && _imageFile!.existsSync();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: const Text("Edit Profile"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 25),
        child: Column(
          children: [
            // Modern header
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.edit, color: primaryColor, size: 32),
                const SizedBox(width: 10),
                Text(
                  "Edit Your Profile",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                    letterSpacing: 1.1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                    border: Border.all(color: primaryColor, width: 3),
                  ),
                  child: CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.white,
                    backgroundImage: hasPhoto
                        ? FileImage(_imageFile!)
                        : const AssetImage("assets/no_user.jpg")
                              as ImageProvider,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 4,
                  child: InkWell(
                    onTap: _pickImage,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            // Full Name
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person, color: primaryColor),
              ),
            ),
            const SizedBox(height: 20),
            // Email
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email, color: primaryColor),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            // Current Password
            TextField(
              obscureText: _obscureCurrentPassword,
              decoration: InputDecoration(
                labelText: 'Current Password',
                prefixIcon: const Icon(Icons.lock_outline, color: primaryColor),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureCurrentPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: primaryColor,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureCurrentPassword = !_obscureCurrentPassword;
                    });
                  },
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _currentPassword = value;
                });
              },
            ),
            const SizedBox(height: 20),
            // New Password
            TextField(
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'New Password',
                prefixIcon: const Icon(Icons.lock, color: primaryColor),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: primaryColor,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _newPassword = value;
                });
              },
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'SAVE',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
