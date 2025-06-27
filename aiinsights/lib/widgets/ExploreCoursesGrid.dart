import 'package:flutter/material.dart';
import 'course_card.dart';

class ExploreCoursesGrid extends StatelessWidget {
  final String searchQuery;

  const ExploreCoursesGrid({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    final allCourses = [
      'Prompt Engineering',
      'React Native',
      'Python Beginner',
      'AI for Everyone',
      'Flutter Advanced',
      'Data Science Basics',
    ];

    final filteredCourses = allCourses
        .where(
          (course) => course.toLowerCase().contains(searchQuery.toLowerCase()),
        )
        .toList();

    if (filteredCourses.isEmpty) {
      return const Center(child: Text("No courses found."));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GridView.builder(
        itemCount: filteredCourses.length,
        physics: const BouncingScrollPhysics(), // allows vertical scroll
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 per row
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          return CourseCard(
            title: filteredCourses[index],
            color: Colors.deepPurpleAccent,
          );
        },
      ),
    );
  }
}
