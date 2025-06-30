// lib/services/gemini_service.dart
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:aiinsights/api/api.dart';

class GeminiService {
  late final GenerativeModel _model;
  late final ChatSession _chatSession;

  GeminiService() {
    final apiKey = GEMINI().apiKeyValue;

    _model = GenerativeModel(
      model: 'gemini-2.0-flash-exp',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 1,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 512,
      ),
    );

    _chatSession = _model.startChat(history: []);
  }

  Future<String> sendMessage(String input) async {
    final content = Content.text(input);
    final response = await _chatSession.sendMessage(content);
    return response.text ?? 'No response received.';
  }
}
