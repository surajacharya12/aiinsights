import 'dart:convert';
import 'package:aiinsights/widgets/CourseCntent/CourseScreen%20.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:aiinsights/backend_call/CreateCourseGet.dart';
import 'package:aiinsights/widgets/CourseCntent/ChapterTopicList.dart';

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
  String? _lastBackendResponse;

  @override
  void initState() {
    super.initState();
    _fetchCourseInfo();
  }

  Future<void> _fetchCourseInfo() async {
    if (widget.courseId.isEmpty) return;
    setState(() => _loading = true);

    try {
      final result = await CourseServiceGet().getCourseById(widget.courseId);

      if (result['success'] == true) {
        final data = result['course'] ?? {};
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
        }

        setState(() {
          _course = fallback.isNotEmpty ? fallback : normalized;
          _lastBackendResponse = jsonEncode(data);
        });

        Fluttertoast.showToast(
          msg: "Course layout loaded!",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.green,
        );
      } else {
        setState(() {
          _lastBackendResponse = result['message'] ?? 'Unknown error';
          _course = {};
        });
        Fluttertoast.showToast(
          msg: _lastBackendResponse!,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.red,
        );
      }
    } catch (error) {
      setState(() {
        _lastBackendResponse = error.toString();
        _course = {};
      });
      Fluttertoast.showToast(
        msg: "Error: $error",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  bool get _hasGeneratedContent {
    if (_course.isEmpty) return false;

    final chapters = _course['chapters'];
    if (chapters is List && chapters.isNotEmpty) {
      return true;
    }

    final courseJson = _course['courseJson'];
    if (courseJson != null && courseJson is Map<String, dynamic>) {
      final nestedChapters = courseJson['chapters'];
      if (nestedChapters is List && nestedChapters.isNotEmpty) {
        return true;
      }
    }

    final topics = _course['topics'];
    if (topics is List && topics.isNotEmpty) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.courseId.isEmpty) {
      return const Center(child: Text('No course selected.'));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _loading
            ? _buildLoadingSkeleton(context)
            : _buildCourseContent(),
      ),
    );
  }

  Widget _buildLoadingSkeleton(BuildContext context) {
    return Column(
      children: List.generate(
        5,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: FadeShimmer(
            height: 20,
            width: MediaQuery.of(context).size.width * 0.8,
            radius: 8,
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade200,
          ),
        ),
      ),
    );
  }

  Widget _buildCourseContent() {
    if (_course.isEmpty) {
      return Center(
        child: Text(
          'No course data found.\nDebug info: $_lastBackendResponse',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          // Pass _hasGeneratedContent for viewcourse flag
          CourseScreen(course: _course, viewcourse: _hasGeneratedContent),
          ChapterTopicList(course: _course),
        ],
      ),
    );
  }
}
