import 'package:flutter/material.dart';
import '../Components/colors.dart';
import 'login.dart';
import 'signup.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Container(
              padding: const EdgeInsets.all(24),
              width: media.width * 0.85,
              constraints: const BoxConstraints(maxWidth: 400),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(
                      128,
                      128,
                      128,
                      0.15,
                    ), // grey with 15% opacity
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "AIInsights Academy",
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 24, // reduced from 30
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 8), // reduced from 10
                    Text(
                      "Create and launch your own courses with the power of AI.\nSign in to get started!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 13.5, // reduced from 15
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20), // reduced from 30

                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                        16,
                      ), // reduced from 20
                      child: Image.asset(
                        "assets/startup.jpg",
                        width: double.infinity,
                        height: media.height * 0.20, // reduced from 0.28
                        fit: BoxFit.cover,
                      ),
                    ),

                    const SizedBox(height: 24), // reduced from 36

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(
                            vertical: 13,
                          ), // reduced from 16
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              18,
                            ), // reduced from 24
                          ),
                          elevation: 8,
                          shadowColor: primaryColor.withOpacity(0.7),
                        ),
                        child: const Text(
                          "LOG IN",
                          style: TextStyle(
                            fontSize: 15, // reduced from 18
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14), // reduced from 20

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignupScreen(),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 13,
                          ), // reduced from 16
                          side: BorderSide(color: primaryColor, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              18,
                            ), // reduced from 24
                          ),
                        ),
                        child: Text(
                          "GET STARTED",
                          style: TextStyle(
                            fontSize: 15, // reduced from 18
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18), // reduced from 30
                    // ➕ Powered by Eagle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/eagle.jpg',
                          height: 24, // reduced from 30
                          width: 24, // reduced from 30
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Powered by Eagle",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                            fontSize: 12.5, // reduced from 14
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
