import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<List<Map<String, dynamic>>> fetchCourses(String searchQuery) async {
  final baseUrl = Platform.isAndroid
      ? "http://10.0.2.2:3001"
      : "http://localhost:3001";

  final queryParameters = {
    'courseId': '0',
    if (searchQuery.trim().isNotEmpty) 'search': searchQuery.trim(),
  };

  final url = Uri.parse(
    '$baseUrl/course/explore',
  ).replace(queryParameters: queryParameters);

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List data = jsonDecode(response.body);
    return data.cast<Map<String, dynamic>>();
  } else {
    throw Exception('Failed to load courses: ${response.body}');
  }
}
