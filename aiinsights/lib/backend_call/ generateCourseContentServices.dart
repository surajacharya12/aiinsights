import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class CourseContentServices {
  final String baseUrl = Platform.isAndroid
      ? "http://10.0.2.2:3001"
      : "http://localhost:3001";

  static Future<Map<String, dynamic>> generateCourseContent({
    required String name,
    required String description,
    required String category,
    required String level,
    required String duration,
    required bool includeVideo,
    required String email,
  }) async {
    try {
      final bodyMap = {
        'name': name,
        'description': description,
        'category': category,
        'level': level,
        'duration': duration,
        'includeVideo': includeVideo,
        'email': email,
      };

      final response = await http.post(
        Uri.parse('${CourseContentServices().baseUrl}/course/add'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bodyMap),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'courseId': data['courseId']};
      } else {
        return {
          'success': false,
          'message': data['error'] ?? 'Failed to add course',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> getCourseById(String courseId) async {
    try {
      final url = '$baseUrl/course/get?courseId=$courseId';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        } else {
          return {'error': 'Unexpected response format'};
        }
      } else {
        return {
          'error': 'Failed to load course with status ${response.statusCode}',
        };
      }
    } catch (e) {
      return {'error': 'Error: $e'};
    }
  }
}
