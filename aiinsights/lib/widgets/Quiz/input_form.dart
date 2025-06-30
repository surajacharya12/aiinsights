import 'package:aiinsights/widgets/Quiz/Quiz.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();

  void _goToQuizScreen() {
    final topic = _topicController.text.trim();
    final numQns = int.tryParse(_numberController.text.trim());

    if (topic.isEmpty || numQns == null || numQns <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid topic and number')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            QuizScreen(topic: topic, numberOfQuestions: numQns),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        title: const Text("Quiz Generator"),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.quiz_rounded,
              size: 80,
              color: Colors.deepPurple.shade400,
            ),
            const SizedBox(height: 24),
            Text(
              "Create Your Custom Quiz",
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Enter a topic and number of questions to generate a quiz tailored just for you.",
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.deepPurple.shade300,
              ),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _topicController,
              decoration: InputDecoration(
                labelText: "Topic",
                prefixIcon: const Icon(Icons.topic),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _numberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Number of Questions",
                prefixIcon: const Icon(Icons.format_list_numbered),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _goToQuizScreen,
                icon: const Icon(
                  Icons.auto_awesome,
                  size: 28,
                  color: Colors.white,
                ),
                label: Text(
                  "Generate Quiz",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  shadowColor: Colors.deepPurpleAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
