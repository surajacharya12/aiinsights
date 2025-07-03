import 'dart:convert';
import 'dart:typed_data';
import 'package:aiinsights/Views/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../backend_call/generateCourseContentServices.dart';

class CourseScreen extends StatefulWidget {
  final Map<String, dynamic> course;
  final bool viewcourse;

  const CourseScreen({Key? key, required this.course, this.viewcourse = false})
    : super(key: key);

  @override
  _CourseScreenState createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  bool _isGenerating = false;

  Map<String, dynamic> get courseLayout {
    if (widget.course['courseJson'] != null &&
        widget.course['courseJson']['course'] != null) {
      return Map<String, dynamic>.from(widget.course['courseJson']['course']);
    } else {
      return Map<String, dynamic>.from(widget.course);
    }
  }

  Widget _buildBannerImage() {
    final base64Image = courseLayout['bannerImageBase64'];
    final urlImage = widget.course['bannerImageURL'];

    if (base64Image != null &&
        base64Image is String &&
        base64Image.isNotEmpty) {
      try {
        String base64Str = base64Image.trim();

        if (base64Str.startsWith('data:image')) {
          final commaIndex = base64Str.indexOf(',');
          if (commaIndex != -1) {
            base64Str = base64Str.substring(commaIndex + 1);
          }
        }

        Uint8List bytes = base64Decode(base64Str);
        if (bytes.isEmpty) throw Exception('Decoded bytes are empty');

        return Image.memory(
          bytes,
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
          gaplessPlayback: true,
        );
      } catch (_) {
        return const Icon(Icons.broken_image, size: 200);
      }
    } else if (urlImage != null &&
        urlImage is String &&
        urlImage.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: urlImage,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (_, __) => const LinearProgressIndicator(),
        errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
      );
    } else {
      return Container(
        height: 200,
        width: double.infinity,
        color: Colors.grey.shade200,
        child: const Icon(Icons.image, size: 100, color: Colors.grey),
      );
    }
  }

  Future<void> _onGenerateContent() async {
    setState(() => _isGenerating = true);
    try {
      final result = await CourseContentServices.generateCourseContent(
        name: courseLayout['name'] ?? 'Course',
        description: courseLayout['description'] ?? '',
        category: courseLayout['category'] ?? 'General',
        level: courseLayout['level'] ?? 'Beginner',
        duration: courseLayout['duration']?.toString() ?? '1h',
        includeVideo: true,
        email: 'test@example.com',
      );

      if (result['success'] == true) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Dashboard()),
        );
      } else {
        _showDialog('Error', result['message'] ?? 'Unknown error occurred.');
      }
    } catch (e) {
      _showDialog('Error', 'Failed to generate content: $e');
    } finally {
      setState(() => _isGenerating = false);
    }
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        title: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        content: Text(
          content,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'OK',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final iconColor = isDark ? theme.colorScheme.onSurface : Colors.black87;

    final courseName = courseLayout['name'] ?? 'No Course Name';
    final courseDesc = courseLayout['description'] ?? 'No Description';
    final duration = courseLayout['duration']?.toString() ?? 'No Duration';
    final chapters =
        courseLayout['noOfChapters']?.toString() ??
        widget.course['noOfChapters']?.toString() ??
        'No Chapters';
    final difficulty = courseLayout['level'] ?? 'No Difficulty';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
        color: theme.cardColor,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: _buildBannerImage(),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.book, color: iconColor, size: 28),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      courseName,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.headlineSmall?.color,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                courseDesc,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium?.color,
                ),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Icon(Icons.access_time, color: iconColor, size: 20),
                    const SizedBox(width: 6),
                    Text(duration, style: TextStyle(color: iconColor)),
                    const SizedBox(width: 20),
                    Icon(Icons.list_alt, color: iconColor, size: 20),
                    const SizedBox(width: 6),
                    Text(
                      '$chapters Chapters',
                      style: TextStyle(color: iconColor),
                    ),
                    const SizedBox(width: 20),
                    Icon(Icons.signal_cellular_alt, color: iconColor, size: 20),
                    const SizedBox(width: 6),
                    Text(difficulty, style: TextStyle(color: iconColor)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? Colors.green[600] : Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 24,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: _isGenerating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.auto_mode),
                label: Text(
                  _isGenerating ? 'Generating Content...' : 'Generate Content',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: _isGenerating ? null : _onGenerateContent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
