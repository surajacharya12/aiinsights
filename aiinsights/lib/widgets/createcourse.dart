import 'package:aiinsights/api/generate-course-layout.dart';
import 'package:flutter/material.dart';

class CreateCourse extends StatefulWidget {
  final String userEmail; // This is required and non-null

  const CreateCourse({super.key, required this.userEmail});

  @override
  State<CreateCourse> createState() => _CreateCourseState();
}

class _CreateCourseState extends State<CreateCourse> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _courseNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _chapterCountController = TextEditingController();

  bool _includeVideo = false;
  String _selectedLevel = 'Beginner';
  final List<String> _levels = ['Beginner', 'Intermediate', 'Difficult'];

  bool _isLoading = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final name = _courseNameController.text.trim();
      final desc = _descriptionController.text.trim();
      final category = _categoryController.text.trim();
      final chapterCount =
          int.tryParse(_chapterCountController.text.trim()) ?? 0;
      final level = _selectedLevel;
      final includeVideo = _includeVideo;
      final userEmail = widget.userEmail;

      if (userEmail.isEmpty) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("User email missing. Cannot create course."),
          ),
        );
        return;
      }

      bool success = await CourseGenerator.generateAndStoreCourse(
        name: name,
        description: desc,
        category: category,
        level: level,
        chapterCount: chapterCount,
        includeVideo: includeVideo,
        userEmail: userEmail,
      );

      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Course "$name" created successfully!'
                : 'Failed to create course. Please try again.',
          ),
        ),
      );

      if (success) {
        _formKey.currentState!.reset();
        _courseNameController.clear();
        _descriptionController.clear();
        _categoryController.clear();
        _chapterCountController.clear();
        setState(() {
          _includeVideo = false;
          _selectedLevel = 'Beginner';
        });
      }
    }
  }

  @override
  void dispose() {
    _courseNameController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _chapterCountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Course'),
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Enter Course Details',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _courseNameController,
                decoration: const InputDecoration(
                  labelText: 'Course Name',
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter course name' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter description' : null,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedLevel,
                decoration: const InputDecoration(
                  labelText: 'Level',
                  border: OutlineInputBorder(),
                ),
                items: _levels
                    .map(
                      (level) =>
                          DropdownMenuItem(value: level, child: Text(level)),
                    )
                    .toList(),
                onChanged: (val) => setState(() => _selectedLevel = val!),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter category' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _chapterCountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Number of Chapters',
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Enter chapter count';
                  if (int.tryParse(val) == null || int.parse(val) <= 0) {
                    return 'Enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              CheckboxListTile(
                value: _includeVideo,
                onChanged: (val) =>
                    setState(() => _includeVideo = val ?? false),
                title: const Text('Include Video Content'),
              ),
              const SizedBox(height: 20),

              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Create Course',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
