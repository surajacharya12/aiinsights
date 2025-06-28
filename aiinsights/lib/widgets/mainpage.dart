import 'dart:async';
import 'package:aiinsights/Views/dashboard.dart';
import 'package:aiinsights/Views/explore.dart';
import 'package:aiinsights/widgets/continue_learning.dart';
import 'package:aiinsights/widgets/explore_courses.dart';
import 'package:flutter/material.dart';
import 'my_courses.dart';

class Mainpage extends StatefulWidget {
  final String userName;
  const Mainpage({super.key, required this.userName});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  final List<String> imgList = [
    'assets/slide/1.png',
    'assets/slide/2.png',
    'assets/slide/3.png',
    'assets/slide/4.png',
    'assets/slide/5.png',
    'assets/slide/6.png',
  ];

  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      _currentPage = (_currentPage + 1) % imgList.length;
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Widget _buildIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: imgList.asMap().entries.map((entry) {
        final isActive = entry.key == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: isActive ? 16 : 8,
          height: 6,
          decoration: BoxDecoration(
            color: isActive ? Colors.deepPurple : Colors.grey.shade400,
            borderRadius: BorderRadius.circular(5),
          ),
        );
      }).toList(),
    );
  }

  Widget _sectionCardHeader(
    String title,
    IconData icon,
    VoidCallback onSeeMore,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.deepPurple),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: onSeeMore,
            child: const Text(
              "See More",
              style: TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.95,
        child: ListView(
          shrinkWrap: true,
          children: [
            // 👋 Welcome Text
            Padding(
              padding: const EdgeInsets.only(
                left: 25,
                right: 25,
                top: 0, // No extra top padding for flush alignment
                bottom: 15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "👋 Welcome back, ${widget.userName}",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Let's continue your learning journey",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),

            // 🌄 Image Slider
            SizedBox(
              height: 320,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      itemCount: imgList.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(imgList[index], fit: BoxFit.cover),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withOpacity(0.6),
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.4),
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                            ),
                            // Top Text
                            Positioned(
                              top: 20,
                              left: 20,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  "Welcome to AI Academy",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            // Bottom Info Card
                            Positioned(
                              left: 20,
                              bottom: 30,
                              child: Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.school_rounded,
                                      color: const Color.fromARGB(
                                        255,
                                        24,
                                        139,
                                        83,
                                      ),
                                      size: 32,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "AI Insights",
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white.withOpacity(0.95),
                                      ),
                                    ),
                                    Text(
                                      "Slide ${index + 1}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white.withOpacity(0.8),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: _buildIndicator(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            // 📚 Continue Learning
            _sectionCardHeader(
              "Continue Learning",
              Icons.menu_book_rounded,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Dashboard()),
                );
              },
            ),
            const ContinueLearning(),

            // 🎓 My Courses
            _sectionCardHeader(
              "My Courses",
              Icons.play_circle_fill_rounded,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Dashboard()),
                );
              },
            ),
            const MyCourses(),

            // 🚀 Explore Courses
            _sectionCardHeader("Explore Courses", Icons.explore_rounded, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Explore()),
              );
            }),
            const ExploreCourses(searchQuery: ''),
          ],
        ),
      ),
    );
  }
}
