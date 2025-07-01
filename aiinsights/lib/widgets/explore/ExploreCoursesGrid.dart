import 'package:flutter/material.dart';
import '../Course/course_card.dart';
import '../../backend_call/explore.dart';

class ExploreCoursesGrid extends StatefulWidget {
  final String searchQuery;

  const ExploreCoursesGrid({super.key, required this.searchQuery});

  @override
  State<ExploreCoursesGrid> createState() => _ExploreCoursesGridState();
}

class _ExploreCoursesGridState extends State<ExploreCoursesGrid> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchCourses(widget.searchQuery),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: \\${snapshot.error}'));
        }
        final courses = snapshot.data ?? [];
        if (courses.isEmpty) {
          return Center(
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
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: GridView.builder(
            itemCount: courses.length,
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              final course = courses[index];
              return CourseCard(
                title: course['name'] != null && course['noOfChapters'] != null
                    ? '${course['name']}\n${course['noOfChapters']} Chapters'
                    : (course['name'] ?? 'No Name'),
                color: Colors.deepPurpleAccent,
                imageUrl: course['bannerImageURL'],
              );
            },
          ),
        );
      },
    );
  }
}
