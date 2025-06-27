import 'package:flutter/material.dart';
import 'package:aiinsights/widgets/course_card.dart';

class MyCoursesGrid extends StatelessWidget {
  const MyCoursesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final courses = ['Web Dev', 'Cyber Security', 'UI/UX Design'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GridView.builder(
        itemCount: courses.length,
        physics: const NeverScrollableScrollPhysics(), // Let parent scroll
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          return CourseCard(title: courses[index], color: Colors.green);
        },
      ),
    );
  }
}
