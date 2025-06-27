import 'dart:async';

import 'package:aiinsights/Views/dashboard.dart';
import 'package:aiinsights/Views/explore.dart';
import 'package:aiinsights/widgets/explore_courses.dart';
import 'package:flutter/material.dart';
import 'my_courses.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

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
          height: 5,
          decoration: BoxDecoration(
            color: isActive ? Colors.deepPurpleAccent : Colors.grey.shade400,
            borderRadius: BorderRadius.circular(5),
          ),
        );
      }).toList(),
    );
  }

  Widget _sectionHeader(String title, VoidCallback onSeeMorePressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: onSeeMorePressed,
            child: const Text("See More"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: ListView(
          shrinkWrap: true,
          children: [
            SizedBox(
              height: 230,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
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
                                    Colors.black.withOpacity(0.3),
                                    Colors.transparent,
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    Positioned(
                      bottom: 5,
                      left: 0,
                      right: 0,
                      child: _buildIndicator(),
                    ),
                  ],
                ),
              ),
            ),

            // My Courses Section
            _sectionHeader("My Courses", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Dashboard()),
              );
            }),
            const MyCourses(),

            // Explore Courses Section
            _sectionHeader("Explore Courses", () {
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
