import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../JSON/users.dart';
import '../SQLite/database_helper.dart';

class CourseGenerator {
  static const String geminiApiKey = 'AIzaSyCOEjEAsk-DEDvBBO9fz0sQnJ6DOR9DJ8M';

  static final _model = GenerativeModel(
    model: 'gemini-2.0-flash-exp',
    apiKey: geminiApiKey,
    generationConfig: GenerationConfig(
      temperature: 1,
      topK: 40,
      topP: 0.95,
      maxOutputTokens: 2048,
    ),
  );

  static final _chatSession = _model.startChat(history: []);

  static const String _prompt = '''
Generate a learning course based on the following input. Return the result in pure JSON format (no explanation). Include:

- course.name
- course.description
- course.category
- course.level
- course.duration
- course.includeVideo
- course.noOfChapters
- course.bannerImagePrompt (a creative illustration prompt)
- course.chapters: chapterName, duration, topics[]

Format:
{
  "course": {
    "name": "string",
    "description": "string",
    "category": "string",
    "level": "string",
    "duration": "string",
    "includeVideo": "boolean",
    "noOfChapters": number,
    "bannerImagePrompt": "string",
    "chapters": [
      {
        "chapterName": "string",
        "duration": "string",
        "topics": ["string"]
      }
    ]
  }
}
''';

  static Future<String?> _generateCourseJson(Map<String, dynamic> input) async {
    try {
      final response = await _chatSession.sendMessage(
        Content.text("$_prompt\n${jsonEncode(input)}"),
      );

      final text = response.text;
      if (text == null || text.isEmpty) return null;

      final first = text.indexOf("{");
      final last = text.lastIndexOf("}");

      return (first != -1 && last != -1)
          ? text.substring(first, last + 1)
          : null;
    } catch (e) {
      print("Gemini generation failed: $e");
      return null;
    }
  }

  static Future<bool> generateAndStoreCourse({
    required String name,
    required String description,
    required String category,
    required String level,
    required int chapterCount,
    required bool includeVideo,
    required String userEmail,
  }) async {
    final cid = const Uuid().v4();

    final formData = {
      "name": name,
      "description": description,
      "category": category,
      "level": level,
      "noOfChapters": chapterCount,
      "includeVideo": includeVideo,
      "duration": "${chapterCount * 5}h",
    };

    final jsonResponse = await _generateCourseJson(formData);
    if (jsonResponse == null) return false;

    final parsed = jsonDecode(jsonResponse);
    final imagePrompt = parsed['course']['bannerImagePrompt'] as String? ?? "";

    // Storing the prompt as bannerImageURL for now
    final imageUrl = imagePrompt;

    final course = Course(
      cid: cid,
      name: name,
      description: description,
      noOfChapters: chapterCount,
      includeVideo: includeVideo,
      level: level,
      category: category,
      userEmail: userEmail,
      courseJson: jsonResponse,
      bannerImageURL: imageUrl,
    );

    await DatabaseHelper().insertCourse(course);
    return true;
  }
}
