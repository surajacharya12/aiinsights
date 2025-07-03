import 'package:flutter/material.dart';
import 'dart:convert';
import '../../backend_call/generateCourseContentServices.dart';

class ChapterTopicList extends StatefulWidget {
  final dynamic course;
  final VoidCallback? onContentGenerated;

  const ChapterTopicList({
    Key? key,
    required this.course,
    this.onContentGenerated,
  }) : super(key: key);

  @override
  _ChapterTopicListState createState() => _ChapterTopicListState();
}

class _ChapterTopicListState extends State<ChapterTopicList> {
  dynamic courseLayout;
  bool isLoading = false;
  String? message;

  @override
  void initState() {
    super.initState();
    setCourseLayout();
  }

  @override
  void didUpdateWidget(covariant ChapterTopicList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.course != widget.course) {
      setCourseLayout();
    }
  }

  void setCourseLayout() {
    dynamic layout;

    try {
      if (widget.course == null) return;

      if (widget.course['courseJson'] is String) {
        final parsed = jsonDecode(widget.course['courseJson']);
        layout = parsed['course'] ?? parsed;
      } else if (widget.course['courseJson'] is Map) {
        layout =
            widget.course['courseJson']['course'] ??
            widget.course['courseJson'];
      } else if (widget.course['course'] != null) {
        layout = widget.course['course'];
      } else {
        layout = widget.course;
      }
    } catch (_) {
      layout = widget.course;
    }

    setState(() {
      courseLayout = layout;
    });
  }

  Future<void> handleGenerateContent() async {
    setState(() {
      isLoading = true;
      message = null;
    });

    try {
      final result = await CourseContentServices.generateCourseContent(
        name: widget.course['name'] ?? 'Course Name',
        description: widget.course['description'] ?? 'Description',
        category: widget.course['category'] ?? 'Category',
        level: widget.course['level'] ?? 'Beginner',
        duration: widget.course['duration']?.toString() ?? '1h',
        includeVideo: widget.course['includeVideo'] ?? false,
        email: widget.course['email'] ?? 'test@example.com',
      );

      setState(() {
        isLoading = false;
        message = result['success'] == true
            ? 'Content generated! Course ID: ${result['courseId']}'
            : (result['message'] ?? 'Failed to generate content');
      });

      if (result['success'] == true) {
        widget.onContentGenerated?.call();
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        message = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    final chapters =
        (courseLayout != null &&
            courseLayout['chapters'] != null &&
            courseLayout['chapters'] is List)
        ? courseLayout['chapters']
        : [];

    if (chapters.isEmpty) {
      return Center(
        child: Text(
          'No chapters found.',
          style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      child: Column(
        children: [
          if (message != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: message!.contains('generated')
                    ? (isDark ? Colors.green[900] : Colors.green[100])
                    : (isDark ? Colors.red[900] : Colors.red[100]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                message!,
                style: TextStyle(
                  color: message!.contains('generated')
                      ? (isDark ? Colors.green[300] : Colors.green[800])
                      : (isDark ? Colors.red[300] : Colors.red[800]),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
          const SizedBox(height: 24),
          Text(
            'Chapters & Topics',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ...chapters.asMap().entries.map((entry) {
            final chapter = entry.value;
            final index = entry.key;

            final chapterName =
                (chapter is Map && chapter['chapterName'] != null)
                ? chapter['chapterName']
                : 'Chapter ${index + 1}';

            final topics = (chapter is Map && chapter['topics'] is List)
                ? chapter['topics']
                : [];

            final duration = (chapter is Map && chapter['duration'] != null)
                ? chapter['duration'].toString()
                : 'N/A';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.indigo[700] : Colors.indigo[600],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chapter ${index + 1}: $chapterName',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Duration: $duration | Topics: ${topics.length}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                ...topics.asMap().entries.map((topicEntry) {
                  final topicIndex = topicEntry.key;
                  final topic = topicEntry.value;

                  final topicName = topic is String
                      ? topic
                      : (topic['name'] ?? topic.toString());

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(width: 16),
                        CircleAvatar(
                          backgroundColor: isDark
                              ? Colors.indigo[200]
                              : Colors.indigo[100],
                          child: Text(
                            '${topicIndex + 1}',
                            style: TextStyle(
                              color: isDark ? Colors.black87 : Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            topicName,
                            style: TextStyle(
                              fontSize: 16,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                const SizedBox(height: 24),
              ],
            );
          }).toList(),
          const SizedBox(height: 40),
          GestureDetector(
            onTap: () {
              // Add navigation or completion logic here if needed
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? Colors.green[700] : Colors.green[600],
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withOpacity(0.5)
                        : Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.check_circle, color: Colors.white, size: 32),
                  SizedBox(width: 12),
                  Text(
                    'Finish',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
