import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../backend_call/backend_service.dart';

class QuizScreen extends StatefulWidget {
  final String topic;
  final int numberOfQuestions;
  final String? userId; // Optional: pass userId if needed

  const QuizScreen({
    super.key,
    required this.topic,
    required this.numberOfQuestions,
    this.userId,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late final GenerativeModel _model;
  late final ChatSession _chatSession;
  final BackendService _backendService = BackendService();

  bool _isLoading = false;
  bool _isSubmitted = false;

  List<Map<String, dynamic>> _quiz = [];
  List<String?> _selectedAnswers = [];
  Map<String, dynamic>? _userProfile;

  // New getter to check if all questions have been answered
  bool get _allAnswered => !_selectedAnswers.contains(null);

  @override
  void initState() {
    super.initState();
    const apiKey = 'AIzaSyCOEjEAsk-DEDvBBO9fz0sQnJ6DOR9DJ8M';
    _model = GenerativeModel(model: 'gemini-2.0-flash-exp', apiKey: apiKey);
    _chatSession = _model.startChat(history: []);
    if (widget.userId != null) {
      _fetchUserProfile(widget.userId!);
    }
    _generateQuiz();
  }

  Future<void> _fetchUserProfile(String userId) async {
    final result = await _backendService.getUserProfile(userId: userId);
    if (result['success'] == true) {
      setState(() {
        _userProfile = result['user'];
      });
    }
  }

  Future<void> _generateQuiz() async {
    setState(() {
      _isLoading = true;
      _quiz.clear();
      _selectedAnswers.clear();
      _isSubmitted = false;
    });

    final prompt =
        '''
Generate ${widget.numberOfQuestions} multiple-choice quiz questions on the topic "${widget.topic}".
Respond only with JSON array. No explanation or markdown.
Each object must be:
{
  "question": "Your question?",
  "options": ["A", "B", "C", "D"],
  "answer": "Correct Answer"
}
''';

    try {
      final response = await _chatSession.sendMessage(Content.text(prompt));
      final cleaned = (response.text ?? '')
          .replaceAll("```json", "")
          .replaceAll("```", "")
          .trim();

      final decoded = jsonDecode(cleaned);
      if (decoded is List) {
        setState(() {
          _quiz = List<Map<String, dynamic>>.from(decoded);
          _selectedAnswers = List<String?>.filled(_quiz.length, null);
        });
      } else {
        throw 'Invalid JSON';
      }
    } catch (e) {
      setState(() {
        _quiz = [
          {
            "question": "Failed to generate quiz.",
            "options": ["Check input or API response"],
            "answer": "-",
          },
        ];
        _selectedAnswers = [null];
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _submitQuiz() {
    setState(() => _isSubmitted = true);
  }

  int _calculateScore() {
    int score = 0;
    for (int i = 0; i < _quiz.length; i++) {
      if (_selectedAnswers[i] == _quiz[i]["answer"]) {
        score++;
      }
    }
    return score;
  }

  Widget _buildQuizCard(Map<String, dynamic> qn, int index) {
    final options = List<String>.from(qn["options"]);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Q${index + 1}. ${qn["question"]}",
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.deepPurple.shade800,
              ),
            ),
            const SizedBox(height: 12),
            ...options.map((opt) {
              bool isSelected = _selectedAnswers[index] == opt;
              bool isCorrect = qn["answer"] == opt;

              Color? tileColor;
              if (_isSubmitted && isSelected) {
                tileColor = isCorrect
                    ? Colors.green.shade100
                    : Colors.red.shade100;
              }

              return RadioListTile<String>(
                title: Text(
                  opt,
                  style: GoogleFonts.poppins(
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: _isSubmitted && isSelected
                        ? (isCorrect
                              ? Colors.green.shade700
                              : Colors.red.shade700)
                        : Colors.deepPurple.shade700,
                  ),
                ),
                value: opt,
                groupValue: _selectedAnswers[index],
                onChanged: !_isSubmitted
                    ? (value) {
                        setState(() => _selectedAnswers[index] = value);
                      }
                    : null,
                tileColor: tileColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                activeColor: Colors.deepPurple,
              );
            }),
            if (_isSubmitted)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  "✅ Correct Answer: ${qn["answer"]}",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: Colors.green.shade700,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        title: Text(
          "Quiz: ${widget.topic}",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          if (_isLoading)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(color: Colors.deepPurple),
              ),
            )
          else if (_quiz.isNotEmpty)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 90),
                itemCount: _quiz.length,
                itemBuilder: (context, index) =>
                    _buildQuizCard(_quiz[index], index),
              ),
            ),
          if (_quiz.isNotEmpty && !_isLoading)
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _allAnswered && !_isSubmitted ? _submitQuiz : null,
                  icon: const Icon(Icons.check_circle_outline, size: 26),
                  label: Text(
                    _isSubmitted ? "Submitted" : "Submit Quiz",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _allAnswered
                        ? Colors.green.shade600
                        : Colors.green.shade200,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 6,
                    shadowColor: Colors.greenAccent,
                  ),
                ),
              ),
            ),
          if (_isSubmitted)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                "🎉 Your Score: ${_calculateScore()} / ${_quiz.length}",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple.shade700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
