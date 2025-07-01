import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../backend_call/generateCourseContentServices.dart';

class CourseScreen extends StatefulWidget {
  final Map<String, dynamic> course;
  final bool viewcourse;

  const CourseScreen({
    Key? key,
    this.course = const {},
    this.viewcourse = false,
  }) : super(key: key);

  @override
  _CourseScreenState createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  Map<String, dynamic>? get courseLayout {
    if (widget.course['courseJson'] != null &&
        widget.course['courseJson']['course'] != null) {
      return widget.course['courseJson']['course'];
    } else if (widget.course['course'] != null) {
      return widget.course['course'];
    } else if (widget.course['chapters'] != null) {
      return widget.course;
    } else {
      return widget.course;
    }
  }

  String? get bannerSrcRaw {
    return courseLayout?['bannerImageBase64'] ??
        widget.course['bannerImageBase64'] ??
        widget.course['bannerImageURL'] ??
        null;
  }

  String? get bannerSrc {
    if (bannerSrcRaw == null || bannerSrcRaw is! String) return null;

    if (bannerSrcRaw!.startsWith('http') ||
        bannerSrcRaw!.startsWith('data:image')) {
      return bannerSrcRaw;
    }

    return 'data:image/png;base64,$bannerSrcRaw';
  }

  bool _isGenerating = false;

  Future<void> _onGenerateContent() async {
    setState(() {
      _isGenerating = true;
    });
    try {
      // You may want to extract these from the course or prompt user for them
      final result = await CourseContentServices.generateCourseContent(
        name: courseLayout?['name'] ?? 'Sample Course',
        description: courseLayout?['description'] ?? 'Sample Description',
        category: courseLayout?['category'] ?? 'General',
        level: courseLayout?['level'] ?? 'Beginner',
        duration: courseLayout?['duration']?.toString() ?? '1h',
        includeVideo: true,
        email: 'test@example.com', // Replace with actual user email if available
      );
      if (mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(result['success'] == true ? 'Success' : 'Error'),
            content: Text(result['success'] == true
                ? 'Content generated! Course ID: ${result['courseId'] ?? ''}'
                : (result['message'] ?? 'Failed to generate content')),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to generate content: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Debug: Always show the raw course map at the top for troubleshooting
    final debugInfo = widget.course.toString();
    final courseName =
        courseLayout?['name'] ??
        widget.course['name'] ??
        widget.course['courseJson']?['course']?['name'] ??
        'No Course Name';
    final courseDescription =
        courseLayout?['description'] ??
        widget.course['description'] ??
        widget.course['courseJson']?['course']?['description'] ??
        'No Description';
    final duration =
        courseLayout?['duration'] ??
        widget.course['duration'] ??
        widget.course['courseJson']?['course']?['duration'] ??
        'No Duration';
    final chapters =
        courseLayout?['noOfChapters'] ??
        widget.course['noOfChapters'] ??
        (courseLayout?['chapters']?.length ??
            widget.course['chapters']?.length ??
            widget.course['courseJson']?['course']?['chapters']?.length ??
            'No Chapters');
    final difficulty =
        courseLayout?['level'] ??
        widget.course['level'] ??
        widget.course['courseJson']?['course']?['level'] ??
        'No Difficulty';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
          child: Column(
            children: [
              // Debug info always at the top
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(8),
                color: Colors.yellow[100],
                child: Text(
                  'DEBUG DATA: $debugInfo',
                  style: const TextStyle(fontSize: 12, color: Colors.brown),
                ),
              ),
              if (bannerSrc != null)
                CachedNetworkImage(
                  imageUrl: bannerSrc!,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  width: double.infinity,
                  height: 280,
                  fit: BoxFit.cover,
                )
              else
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'No Banner Image',
                    style: TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),

              const SizedBox(height: 24),

              Container(
                decoration: BoxDecoration(
                  color: Colors.amber[100],
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Description
                    Text(
                      courseName,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      courseDescription,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),

                    const SizedBox(height: 24),

                    // Info Cards
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      childAspectRatio: 2,
                      children: [
                        _buildInfoCard(
                          icon: Icons.access_time,
                          iconColor: Colors.indigo,
                          title: 'Duration',
                          value: duration.toString(),
                          backgroundColor: Colors.indigo[50]!,
                        ),
                        _buildInfoCard(
                          icon: Icons.book,
                          iconColor: Colors.green,
                          title: 'Chapters',
                          value: chapters.toString(),
                          backgroundColor: Colors.green[50]!,
                        ),
                        _buildInfoCard(
                          icon: Icons.bar_chart,
                          iconColor: Colors.red,
                          title: 'Difficulty',
                          value: difficulty.toString(),
                          backgroundColor: Colors.red[50]!,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Action Button (removed generate content logic)
                    Center(
                      child: widget.viewcourse
                          ? ElevatedButton.icon(
                              onPressed: () {
                                // Navigate to course page if needed
                                // Navigator.pushNamed(context, '/course/${widget.course['cid']}');
                              },
                              icon: const Icon(Icons.play_circle),
                              label: const Text('Continue Learning'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[600],
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            )
                          : Column(
                              children: [
                                ElevatedButton.icon(
                                  onPressed: _isGenerating ? null : _onGenerateContent,
                                  icon: const Icon(Icons.auto_fix_high),
                                  label: _isGenerating
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(strokeWidth: 2),
                                        )
                                      : const Text('Generate Content'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurple[400],
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required Color backgroundColor,
  }) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 32),
          const SizedBox(width: 12),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: iconColor.withOpacity(0.8),
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
