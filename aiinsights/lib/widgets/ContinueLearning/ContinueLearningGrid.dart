import 'package:flutter/material.dart';
import '../../backend_call/enroll.dart';

class ContinueLearningGrid extends StatefulWidget {
  const ContinueLearningGrid({super.key});

  @override
  _ContinueLearningGridState createState() => _ContinueLearningGridState();
}

class _ContinueLearningGridState extends State<ContinueLearningGrid> {
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: loading
          ? const Center(child: CircularProgressIndicator())
          : courses.isEmpty
          ? const Center(child: Text("No courses found"))
          : GridView.builder(
              itemCount: courses.length,
              physics:
                  const NeverScrollableScrollPhysics(), // Let parent scroll
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                final course = courses[index];
                final courseJson = course.courseJson;
                return CourseCard(
                  title: courseJson != null
                      ? '${courseJson.name ?? 'Course'}\n${courseJson.noOfChapters ?? 0} Chapters'
                      : 'Course',
                  color: Colors.deepPurple,
                  imageUrl: course.bannerImageURL,
                );
              },
            ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final String title;
  final Color color;
  final String? imageUrl;

  const CourseCard({
    super.key,
    required this.title,
    required this.color,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageUrl != null)
            Image.network(
              imageUrl!,
              fit: BoxFit.cover,
              height: 100,
              width: double.infinity,
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
