import 'package:flutter/material.dart';
import 'package:aiinsights/widgets/Course/course_card.dart';
import '../../backend_call/generateCourseContentServices.dart';

class MyCoursesGrid extends StatefulWidget {
  const MyCoursesGrid({super.key});

  @override
  State<MyCoursesGrid> createState() => _MyCoursesGridState();
}

class _MyCoursesGridState extends State<MyCoursesGrid> {
  List<dynamic> courses = [];
  bool loading = true;
  final String userEmail =
      'user@example.com'; // TODO: Replace with actual user email from auth

  @override
  void initState() {
    super.initState();
    fetchUserCourses();
  }

  Future<void> fetchUserCourses() async {
    setState(() => loading = true);
    // Fetch courses created by this user
    final response = await CourseContentServices().getCoursesByEmail(userEmail);
    print('Fetched courses response: ' + response.toString()); // Debug print
    courses = response['courses'] ?? [];
    print('Parsed courses: ' + courses.toString()); // Debug print
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (courses.isEmpty) {
      return const Center(child: Text('No courses found'));
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GridView.builder(
        itemCount: courses.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          final course = courses[index];
          return CourseCard(
            title: course['name'] ?? 'Course',
            color: Colors.green,
            imageUrl: course['bannerImageURL'],
          );
        },
      ),
    );
  }
}
