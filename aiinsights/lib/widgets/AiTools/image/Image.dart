import 'dart:typed_data';
import 'package:aiinsights/widgets/AiTools/image/image_input.dart';
import 'package:aiinsights/widgets/AiTools/image/image_output.dart';
import 'package:aiinsights/widgets/services/gemini_api_image.dart';
import 'package:flutter/material.dart';

class GeminiImageGenScreen extends StatefulWidget {
  const GeminiImageGenScreen({super.key});
  @override
  State<GeminiImageGenScreen> createState() => _GeminiImageGenScreenState();
}

class _GeminiImageGenScreenState extends State<GeminiImageGenScreen> {
  Uint8List? _imageBytes;
  String? _error;
  bool _loading = false;
  final GeminiAPI _api = GeminiAPI();

  Future<void> _generate(String prompt, String ratio) async {
    setState(() {
      _loading = true;
      _error = null;
      _imageBytes = null;
    });
    try {
      final result = await _api.generateImage(prompt, ratio);
      setState(() {
        _imageBytes = result['imageBytes'] as Uint8List?;
        if (_imageBytes == null) {
          _error =
              result['responseText'] as String? ?? 'No image or text returned.';
        }
      });
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ImageInput(onSubmit: _generate, loading: _loading),
            const SizedBox(height: 24),
            ImageOutput(
              imageBytes: _imageBytes,
              error: _error,
              loading: _loading,
            ),
          ],
        ),
      ),
    );
  }
}
