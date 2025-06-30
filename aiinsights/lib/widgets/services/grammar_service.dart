import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:aiinsights/api/api.dart';

class GrammarService {
  final String _apiKey = GEMINI().apiKeyValue;

  Future<String> correctGrammar(String inputText) async {
    final prompt =
        'Correct the grammar of the following text and return only the corrected version:\n\n"$inputText"';
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$_apiKey',
    );

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': prompt},
            ],
          },
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['candidates']?[0]?['content']?['parts']?[0]?['text'] ??
          "No correction found.";
    } else {
      throw Exception('API Error: ${response.statusCode}');
    }
  }
}
