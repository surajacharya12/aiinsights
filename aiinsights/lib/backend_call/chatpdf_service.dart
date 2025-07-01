import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

class ChatPdfService {
  static const String chatUrl = 'http://localhost:3001/chat';
  static const String uploadUrl = 'http://localhost:3001/upload/pdf';

  static Future<String?> sendMessage(String input) async {
    try {
      final response = await http.post(
        Uri.parse(chatUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': input}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['answer'] ?? '';
      } else {
        return null;
      }
    } catch (_) {
      return null;
    }
  }

  static Future<String> uploadPdf(File file) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(uploadUrl));
      request.files.add(await http.MultipartFile.fromPath('pdf', file.path));
      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        return '✅ PDF uploaded and processed successfully! You can now ask questions about it.\n\nServer response: $respStr';
      } else {
        return '❌ Failed to process PDF. Server response: $respStr';
      }
    } catch (e) {
      return '❌ Failed to process PDF. Error: $e';
    }
  }

  static Future<File?> pickPdfFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      return File(result.files.single.path!);
    }
    return null;
  }
}
