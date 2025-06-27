import 'package:flutter/material.dart';
import 'course_card.dart';

class ExploreCourses extends StatelessWidget {
  final String searchQuery;
  final bool isGrid;

  const ExploreCourses({
    super.key,
    required this.searchQuery,
    this.isGrid = false, // default is horizontal scroll
  });

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

    if (isGrid) {
      // ✅ Vertical Grid Layout for Explore Page
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredCourses.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.6,
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

    // ✅ Horizontal Scroll Layout for Mainpage
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filteredCourses.length,
        padding: const EdgeInsets.only(left: 8),
        itemBuilder: (context, index) {
          return CourseCard(
            title: filteredCourses[index],
            color: Colors.orange,
          );
        },
      ),
    );
  }
}
