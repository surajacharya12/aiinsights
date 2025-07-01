import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<List<Map<String, dynamic>>> fetchCourses(String searchQuery) async {
  final String baseUrl = Platform.isAndroid
      ? "http://10.0.2.2:3001"
      : "http://localhost:3001";

  final search = searchQuery.trim();
  final url = Uri.parse(
    '$baseUrl/course/explore?courseId=0' +
        (search.isNotEmpty ? '&search=${Uri.encodeComponent(search)}' : ''),
  );

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List data = jsonDecode(response.body);
    return data.cast<Map<String, dynamic>>();
  } else {
    throw Exception('Failed to load courses: ${response.body}');
  }
}
