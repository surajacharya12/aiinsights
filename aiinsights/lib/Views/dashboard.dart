import 'package:aiinsights/widgets/ContinueLearningGrid.dart';
import 'package:aiinsights/widgets/MyCoursesGrid%20.dart';
import 'package:flutter/material.dart';
import 'package:aiinsights/widgets/createcourse.dart';

class Dashboard extends StatefulWidget {
  final String? userEmail;

  const Dashboard({super.key, this.userEmail});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.school, color: Colors.green),
            SizedBox(width: 8),
            Text(
              'Aiinsights',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 🌟 Welcome box
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.blue, Colors.purple, Colors.pink],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(2, 4),
                ),
              ],
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Aiinsights',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.yellow,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Your Ultimate Online Learning Platform\n\nLearn, Create, and Explore your favorite courses with ease',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 📘 Continue Learning Section
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "Continue Learning Your Courses",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 16),

          const ContinueLearningGrid(),

          const SizedBox(height: 24),

          // 📗 My Courses Section
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "My Enrolled Courses",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 16),

          const MyCoursesGrid(),
        ],
      ),
    );
  }
}
