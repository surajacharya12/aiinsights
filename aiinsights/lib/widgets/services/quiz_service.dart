import 'dart:convert';
import 'package:aiinsights/api/api.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class QuizApiService {
  final GenerativeModel _model;
  final ChatSession _chatSession;

  QuizApiService()
    : _model = GenerativeModel(
        model: 'gemini-2.0-flash-exp',
        apiKey: GEMINI().apiKeyValue,
      ),
      _chatSession = GenerativeModel(
        model: 'gemini-2.0-flash-exp',
        apiKey: GEMINI().apiKeyValue,
      ).startChat(history: []);

  Future<List<Map<String, dynamic>>> generateQuiz({
    required String topic,
    required int numberOfQuestions,
  }) async {
    final prompt =
        '''
Generate $numberOfQuestions multiple-choice quiz questions on the topic "$topic".
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
        return List<Map<String, dynamic>>.from(decoded);
      } else {
        throw Exception("Invalid JSON format from AI");
      }
    } catch (e) {
      rethrow;
    }
  }
}
