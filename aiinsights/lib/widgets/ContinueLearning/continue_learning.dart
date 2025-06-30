import 'package:flutter/material.dart';
import 'package:aiinsights/widgets/Course/course_card.dart';

class ContinueLearning extends StatelessWidget {
  const ContinueLearning({super.key});

  @override
  Widget build(BuildContext context) {
    final courses = ['Intro to Flutter', 'AI Tools Basics', 'Machine Learning'];

    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 20),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          return CourseCard(title: courses[index], color: Colors.deepPurple);
        },
      ),
    );
  }
}
