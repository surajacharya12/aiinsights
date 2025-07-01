import 'package:aiinsights/widgets/explore/ExploreCoursesGrid.dart';
import 'package:flutter/material.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurpleAccent, Colors.indigo],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          'Explore Courses',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 💡 Welcome Text
            Text(
              'Find Your Next Learning Adventure',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Browse curated courses across tech, design, AI and more!',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.brightness == Brightness.dark
                    ? Colors.grey.shade400
                    : Colors.grey.shade700,
              ),
            ),

            const SizedBox(height: 20),

            // 🔍 Search Bar
            Material(
              elevation: 6,
              borderRadius: BorderRadius.circular(12),
              shadowColor: Colors.black12,
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface,
                ),
                decoration: InputDecoration(
                  hintText: 'Search courses...',
                  hintStyle: TextStyle(
                    color: theme.brightness == Brightness.dark
                        ? Colors.grey.shade400
                        : Colors.grey.shade700,
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: colorScheme.surface,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // 🌟 Section Title
            Row(
              children: [
                const Icon(Icons.star_rounded, color: Colors.amber, size: 28),
                const SizedBox(width: 8),
                Text(
                  "Featured Courses",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              "Carefully selected courses to boost your skills.",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 16),

            // 📚 Course Grid
            SizedBox(
              height: 500,
              child: ExploreCoursesGrid(searchQuery: _searchQuery),
            ),
          ],
        ),
      ),
    );
  }
}
