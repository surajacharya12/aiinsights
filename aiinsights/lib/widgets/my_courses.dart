import 'package:flutter/material.dart';
import 'course_card.dart';

class MyCourses extends StatelessWidget {
  const MyCourses({super.key});

  @override
  Widget build(BuildContext context) {
    final courses = ['Web Dev', 'Cyber Security', 'UI/UX Design'];

    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: courses.length,
        padding: const EdgeInsets.only(left: 8),
        itemBuilder: (context, index) {
          return CourseCard(title: courses[index], color: Colors.green);
        },
      ),
    );
  }
}
