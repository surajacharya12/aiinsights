import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class CourseServiceGet {
  final String baseUrl = Platform.isAndroid
      ? "http://10.0.2.2:3001"
      : "http://localhost:3001";

  /// Fetch a course by its ID
  Future<Map<String, dynamic>> getCourseById(String courseId) async {
    try {
      final url = '$baseUrl/course/get?courseId=$courseId';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return {'success': true, 'course': decoded};
      } else {
        final decoded = jsonDecode(response.body);
        return {
          'success': false,
          'message': decoded['error'] ?? 'Failed to fetch course',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }
}
