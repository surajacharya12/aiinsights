import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:aiinsights/api/api.dart';

class GeminiAPI {
  final apiKeyValue = GEMINI().apiKeyValue;

  Future<Map<String, dynamic>> generateImage(
    String prompt,
    String aspectRatio,
  ) async {
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-preview-image-generation:generateContent?key=$apiKeyValue',
    );

    final headers = {'Content-Type': 'application/json'};

    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {"text": "$prompt\n\nAspect Ratio: $aspectRatio"},
          ],
        },
      ],
      "generationConfig": {
        "responseModalities": ["TEXT", "IMAGE"],
      },
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode != 200) {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }

    final json = jsonDecode(response.body);
    final parts = json['candidates']?[0]?['content']?['parts'];

    Uint8List? imageBytes;
    String? responseText;

    if (parts != null) {
      for (final part in parts) {
        if (part.containsKey('inlineData')) {
          final base64Data = part['inlineData']?['data'];
          if (base64Data != null) {
            imageBytes = base64Decode(base64Data);
          }
        } else if (part.containsKey('text')) {
          responseText = part['text'];
        }
      }
    }

    return {'imageBytes': imageBytes, 'responseText': responseText};
  }
}
