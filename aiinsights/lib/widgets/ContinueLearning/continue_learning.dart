import 'package:flutter/material.dart';
import '../../backend_call/enroll.dart';
import 'package:aiinsights/widgets/Course/course_card.dart';

class ContinueLearning extends StatefulWidget {
  const ContinueLearning({super.key});

  @override
  State<ContinueLearning> createState() => _ContinueLearningState();
}

class _ContinueLearningState extends State<ContinueLearning> {
  List<Course> courses = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  Future<void> fetchCourses() async {
    setState(() => loading = true);
    courses = await fetchEnrolledCourses();
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const SizedBox(
        height: 160,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (courses.isEmpty) {
      return const SizedBox(
        height: 160,
        child: Center(child: Text("No courses found")),
      );
    }

    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 20),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index].courseJson;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CourseCard(
              title: course != null
                  ? '${course.name ?? 'Course'}\n${course.noOfChapters ?? 0} Chapters'
                  : 'Course',
              color: Colors.deepPurple,
              imageUrl: courses[index].bannerImageURL,
            ),
          );
        },
      ),
    );
  }
}
