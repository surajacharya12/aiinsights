import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:aiinsights/widgets/CourseCntent/ChapterTopicList.dart';
import 'package:aiinsights/widgets/CourseCntent/CourseScreen .dart';

class EditCoursePage extends StatefulWidget {
  final String courseId;
  final bool viewcourse;

  const EditCoursePage({
    Key? key,
    required this.courseId,
    this.viewcourse = false,
  }) : super(key: key);

  @override
  _EditCoursePageState createState() => _EditCoursePageState();
}

class _EditCoursePageState extends State<EditCoursePage> {
  bool _loading = false;
  Map<String, dynamic> _course = {};

  String get baseUrl =>
      Platform.isAndroid ? "http://10.0.2.2:3001" : "http://localhost:3001";

  @override
  void initState() {
    super.initState();
    _fetchCourseInfo();
  }

  Future<void> _fetchCourseInfo() async {
    if (widget.courseId.isEmpty) return;
    setState(() => _loading = true);
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/course/get?courseId=${widget.courseId}'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Normalize: extract the deepest valid course object
        Map<String, dynamic> normalized = data is Map<String, dynamic>
            ? Map<String, dynamic>.from(data)
            : {};
        if (normalized['courseJson'] != null &&
            normalized['courseJson'] is Map) {
          normalized.addAll(
            Map<String, dynamic>.from(normalized['courseJson']),
          );
        }
        Map<String, dynamic> fallback = {};
        if (normalized['course'] != null && normalized['course'] is Map) {
          fallback = Map<String, dynamic>.from(normalized['course']);
        } else if (normalized['courseJson'] != null &&
            normalized['courseJson'] is Map &&
            normalized['courseJson']['course'] != null &&
            normalized['courseJson']['course'] is Map) {
          fallback = Map<String, dynamic>.from(
            normalized['courseJson']['course'],
          );
        }
        setState(() {
          _course = fallback.isNotEmpty
              ? fallback
              : (normalized.isNotEmpty ? normalized : {});
        });
        Fluttertoast.showToast(
          msg: "Course layout generated successfully!",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.green,
        );
      } else {
        // Show backend error message if available
        String errorMsg = 'Failed to load course';
        try {
          final data = json.decode(response.body);
          if (data is Map && data['error'] != null) {
            errorMsg = data['error'].toString();
          }
        } catch (_) {}
        Fluttertoast.showToast(
          msg: errorMsg,
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
        );
        setState(() => _course = {});
      }
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Network or parsing error: $error",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
      );
      setState(() => _course = {});
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.courseId.isEmpty) {
      return const Center(child: Text('No course selected.'));
    }
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _loading
            ? _buildLoadingSkeleton(context)
            : _buildCourseContentOrError(),
      ),
    );
  }

  Widget _buildLoadingSkeleton(BuildContext context) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeShimmer(
              height: 32,
              width: MediaQuery.of(context).size.width / 3,
              radius: 8,
              highlightColor: Colors.grey.shade200,
              baseColor: Colors.grey.shade300,
            ),
            const SizedBox(height: 8),
            FadeShimmer(
              height: 24,
              width: MediaQuery.of(context).size.width / 2,
              radius: 8,
              highlightColor: Colors.grey.shade200,
              baseColor: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            FadeShimmer(
              height: 160,
              width: double.infinity,
              radius: 8,
              highlightColor: Colors.grey.shade200,
              baseColor: Colors.grey.shade300,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Column(
          children: List.generate(
            3,
            (index) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeShimmer(
                  height: 24,
                  width: MediaQuery.of(context).size.width * 2 / 3,
                  radius: 8,
                  highlightColor: Colors.grey.shade200,
                  baseColor: Colors.grey.shade300,
                ),
                const SizedBox(height: 8),
                FadeShimmer(
                  height: 16,
                  width: MediaQuery.of(context).size.width / 2,
                  radius: 8,
                  highlightColor: Colors.grey.shade200,
                  baseColor: Colors.grey.shade300,
                ),
                const SizedBox(height: 8),
                FadeShimmer(
                  height: 16,
                  width: MediaQuery.of(context).size.width * 3 / 4,
                  radius: 8,
                  highlightColor: Colors.grey.shade200,
                  baseColor: Colors.grey.shade300,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCourseContentOrError() {
    // If course is empty, try to fetch again or show a user-friendly message with debug info
    if (_course.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'No course data found for this course.\nPlease check if the course exists or try again.',
                  style: TextStyle(fontSize: 16, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Debug info: Course ID: ${widget.courseId}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }
    final hasCourseData =
        _course['name'] != null ||
        _course['course'] != null ||
        _course['courseJson'] != null ||
        (_course['courseJson'] != null &&
            _course['courseJson']['course'] != null) ||
        _course['chapters'] != null;
    if (hasCourseData) {
      return SingleChildScrollView(
        child: Column(
          children: [
            CourseScreen(course: _course, viewcourse: widget.viewcourse),
            ChapterTopicList(course: _course),
          ],
        ),
      );
    }
    // If course is not empty but not recognized, show debug info
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Unrecognized course data (for debug):\n\n${_course.toString()}\n\nCourse ID: ${widget.courseId}',
            style: const TextStyle(fontSize: 14, color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class Page extends StatelessWidget {
  final String courseId;

  const Page({Key? key, required this.courseId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: EditCoursePage(courseId: courseId));
  }
}
