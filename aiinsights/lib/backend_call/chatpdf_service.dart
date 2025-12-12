import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

class ChatPdfService {
  static final String baseUrl = Platform.isAndroid
      ? "http://10.0.2.2:3001"
      : "http://localhost:3001";

  static String get uploadUrl => '$baseUrl/chatpdf/upload';
  static String get chatUrl => '$baseUrl/chatpdf/chat';

  static String? _sessionId;

  /// Pick a PDF file using file picker
  static Future<File?> pickPdfFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result != null && result.files.single.path != null) {
        return File(result.files.single.path!);
      }
    } catch (e) {
      print("Error picking file: $e");
    }
    return null;
  }

  /// Upload PDF to backend
  static Future<String> uploadPdf(File file) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(uploadUrl));
      request.files.add(await http.MultipartFile.fromPath('pdf', file.path));

      final streamedResponse = await request.send();
      final responseBody = await streamedResponse.stream.bytesToString();

      if (streamedResponse.statusCode == 200) {
        final decoded = jsonDecode(responseBody);
        _sessionId = decoded['sessionId'];
        return '✅ Uploaded successfully.\n\nPreview:\n${decoded['preview']}';
      } else {
        return '❌ Upload failed. Server response: $responseBody';
      }
    } catch (e) {
      return '❌ Error uploading PDF: $e';
    }
  }

  /// Send chat message
  static Future<String> sendMessage(String message) async {
    if (_sessionId == null) {
      return '❗ Please upload a PDF first.';
    }

    try {
      final response = await http.post(
        Uri.parse(chatUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'sessionId': _sessionId, 'message': message}),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return decoded['response'] ?? 'No response received.';
      } else {
        return '❌ Server error: ${response.statusCode}\n${response.body}';
      }
    } catch (e) {
      return '❌ Failed to send message: $e';
    }
  }

  /// Reset session (clear sessionId)
  static void resetSession() {
    _sessionId = null;
  }

  /// Get current sessionId (for UI/debugging)
  static String? get sessionId => _sessionId;
}
