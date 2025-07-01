import 'package:flutter/material.dart';
import '../../backend_call/explore.dart';
import '../Course/course_card.dart';

class ExploreCoursesGrid extends StatelessWidget {
  final String searchQuery;

  const ExploreCoursesGrid({Key? key, required this.searchQuery})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchCourses(searchQuery),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final courses = snapshot.data ?? [];

        if (courses.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  "No courses found.",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          itemCount: courses.length,
          padding: const EdgeInsets.all(12),
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.9,
          ),
          itemBuilder: (context, index) {
            final course = courses[index];
            return CourseCard(
              title:
                  "${course['name']}\n${course['noOfChapters'] ?? '0'} Chapters",
              imageUrl: course['bannerImageURL'] ?? '',
              color: Colors.deepPurpleAccent,
            );
          },
        );
      },
    );
  }
}
