import 'package:aiinsights/widgets/ContinueLearning/ContinueLearningGrid.dart';
import 'package:aiinsights/widgets/MyCourses/MyCoursesGrid%20.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  final String? userEmail;

  const Dashboard({super.key, this.userEmail});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 0,
        title: Row(
          children: [
            Icon(Icons.school, color: Colors.green.shade400),
            const SizedBox(width: 8),
            Text(
              'Aiinsights',
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onPrimary,
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
              gradient: LinearGradient(
                colors: theme.brightness == Brightness.dark
                    ? [
                        Colors.deepPurple.shade700,
                        Colors.purple.shade700,
                        Colors.pink.shade700,
                      ]
                    : [Colors.blue, Colors.purple, Colors.pink],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.12),
                  blurRadius: 8,
                  offset: const Offset(2, 4),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.emoji_objects,
                  color: Colors.yellow.shade600,
                  size: 48,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome to',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontSize: 22,
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Aiinsights',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontSize: 28,
                          color: Colors.yellow.shade600,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Your Ultimate Online Learning Platform\n\nLearn, Create, and Explore your favorite courses with ease',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onPrimary,
                          fontSize: 16,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 📘 Continue Learning Section
          Row(
            children: [
              Icon(
                Icons.menu_book_rounded,
                color: theme.colorScheme.primary,
                size: 28,
              ),
              const SizedBox(width: 8),
              Text(
                "Continue Learning Your Courses",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          const ContinueLearningGrid(),

          const SizedBox(height: 24),

          // 📗 My Courses Section
          Row(
            children: [
              Icon(
                Icons.play_circle_fill_rounded,
                color: Colors.pink.shade400,
                size: 28,
              ),
              const SizedBox(width: 8),
              Text(
                "My Courses",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          const MyCoursesGrid(),
        ],
      ),
    );
  }
}
