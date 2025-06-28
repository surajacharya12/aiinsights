import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class BackendService {
  final String baseUrl = Platform.isAndroid
      ? "http://10.0.2.2:3001"
      : "http://localhost:3001";

  Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'user': data['user'],
          'userId': data['user']['id'],
        };
      } else {
        return {'success': false, 'message': data['error'] ?? 'Login failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> registerUser({
    required String name,
    required String email,
    required String password,
    String? photo,
  }) async {
    try {
      final bodyMap = {
        'name': name,
        'email': email,
        'password': password,
        if (photo != null) 'photo': photo,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bodyMap),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': data['message'],
          'user': data['user'],
        };
      } else {
        return {
          'success': false,
          'message': data['error'] ?? 'Registration failed',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> uploadUserPhoto({
    required int userId,
    required File imageFile,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/user/photo-upload');
      final request = http.MultipartRequest('POST', uri);
      request.fields['id'] = userId.toString();

      final mimeType = lookupMimeType(imageFile.path)?.split('/');
      if (mimeType == null) throw Exception('Cannot determine MIME type');

      request.files.add(
        await http.MultipartFile.fromPath(
          'photo',
          imageFile.path,
          contentType: MediaType(mimeType[0], mimeType[1]),
        ),
      );

      final response = await request.send();
      final responseData = await http.Response.fromStream(response);
      final data = jsonDecode(responseData.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'],
          'user': data['user'],
        };
      } else {
        return {'success': false, 'message': data['error'] ?? 'Upload failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> getUserProfile({required String userId}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user/$userId'),
        headers: {'Content-Type': 'application/json'},
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {'success': true, 'user': data};
      } else {
        return {
          'success': false,
          'message': data['error'] ?? 'Failed to fetch user',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> updateUserProfile({
    required int userId,
    required String name,
    required String email,
    String? photo,
    String? password,
    String? currentPassword,
  }) async {
    try {
      final bodyMap = {
        'name': name,
        'email': email,
        if (photo != null) 'photo': photo,
        if (password != null && password.isNotEmpty) 'password': password,
        if (currentPassword != null && currentPassword.isNotEmpty)
          'currentPassword': currentPassword,
      };
      final response = await http.put(
        Uri.parse('$baseUrl/user/$userId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bodyMap),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {'success': true, 'user': data};
      } else {
        return {'success': false, 'message': data['error'] ?? 'Update failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }
}
