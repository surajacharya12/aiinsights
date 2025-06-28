import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class GeminiImageGenScreen extends StatefulWidget {
  const GeminiImageGenScreen({super.key});

  @override
  State<GeminiImageGenScreen> createState() => _GeminiImageGenScreenState();
}

class _GeminiImageGenScreenState extends State<GeminiImageGenScreen> {
  Uint8List? _imageBytes;
  String? _responseText;
  bool _loading = false;
  String? _error;

  final String _apiKey = 'AIzaSyCOEjEAsk-DEDvBBO9fz0sQnJ6DOR9DJ8M';

  Future<void> generateImage(String prompt, String aspectRatio) async {
    setState(() {
      _loading = true;
      _error = null;
      _imageBytes = null;
      _responseText = null;
    });

    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-preview-image-generation:generateContent?key=$_apiKey',
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

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final parts = json['candidates']?[0]?['content']?['parts'];

        if (parts != null) {
          for (final part in parts) {
            if (part.containsKey('inlineData')) {
              final base64Data = part['inlineData']?['data'];
              if (base64Data != null) {
                final bytes = base64Decode(base64Data);
                setState(() {
                  _imageBytes = bytes;
                });
              }
            } else if (part.containsKey('text')) {
              setState(() {
                _responseText = part['text'];
              });
            }
          }

          if (_imageBytes == null && _responseText == null) {
            setState(() {
              _error = "No usable data found in response.";
            });
          }
        } else {
          setState(() {
            _error = "Unexpected response structure.";
          });
        }
      } else {
        setState(() {
          _error = "Error ${response.statusCode}:\n${response.body}";
        });
      }
    } catch (e) {
      setState(() {
        _error = "Exception: $e";
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _downloadImage() async {
    if (_imageBytes == null) return;
    // Request storage permission (Android)
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        setState(() {
          _error = 'Storage permission denied.';
        });
        return;
      }
    }
    try {
      final directory = Platform.isAndroid
          ? await getExternalStorageDirectory()
          : await getApplicationDocumentsDirectory();
      final path = directory!.path;
      final file = File(
        '$path/aiinsights_image_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(_imageBytes!);
      setState(() {
        _error = null;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Image saved to $path')));
    } catch (e) {
      setState(() {
        _error = 'Failed to save image: $e';
      });
    }
  }

  Widget buildImageResult() {
    return Container(
      constraints: const BoxConstraints(minHeight: 500),
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image, size: 48, color: Colors.blue.shade600),
          const SizedBox(height: 16),
          if (!_loading && _error == null && _imageBytes != null) ...[
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 350),
              child: Image.memory(_imageBytes!, fit: BoxFit.contain),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _downloadImage,
              icon: const Icon(Icons.download, color: Colors.white, size: 20),
              label: const Text('Download'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
            ),
          ],
          if (_loading) ...[
            const SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                color: Colors.blue,
                strokeWidth: 4,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Generating image...',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ],
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(
              _error!,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (_imageBytes == null && !_loading && _error == null) ...[
            const Text(
              'Your generated image will appear here.',
              style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ImageTab(
              loading: _loading,
              onSubmit: (prompt, aspectRatio) =>
                  generateImage(prompt, aspectRatio),
            ),
            const SizedBox(height: 24),
            buildImageResult(),
          ],
        ),
      ),
    );
  }
}

class ImageTab extends StatefulWidget {
  final Function(String, String) onSubmit;
  final bool loading;

  const ImageTab({required this.onSubmit, required this.loading, super.key});

  @override
  State<ImageTab> createState() => _ImageTabState();
}

class _ImageTabState extends State<ImageTab> {
  String _prompt = '';
  String _aspectRatio = '1:1';

  void _handleSubmit() {
    if (_prompt.trim().isNotEmpty) {
      widget.onSubmit(_prompt.trim(), _aspectRatio);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 500),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Generate Amazing Images',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue[600],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Transforming Ideas into Visual Reality',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 24),
          Text(
            'This section represents the visual tools powered by AI that bring creativity to life.',
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
          const SizedBox(height: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter your prompt',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              AbsorbPointer(
                absorbing: widget.loading,
                child: TextFormField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Describe the image you want to generate...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.blue[400]!),
                    ),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                  onChanged: (value) => _prompt = value,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Aspect Ratio',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              AbsorbPointer(
                absorbing: widget.loading,
                child: DropdownButtonFormField<String>(
                  value: _aspectRatio,
                  items: const [
                    DropdownMenuItem(value: '1:1', child: Text('1:1 (Square)')),
                    DropdownMenuItem(
                      value: '16:9',
                      child: Text('16:9 (Widescreen)'),
                    ),
                    DropdownMenuItem(
                      value: '9:16',
                      child: Text('9:16 (Portrait)'),
                    ),
                    DropdownMenuItem(value: '4:3', child: Text('4:3')),
                    DropdownMenuItem(value: '3:2', child: Text('3:2')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _aspectRatio = value;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.blue[400]!),
                    ),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: widget.loading ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.loading
                      ? Colors.blue[400]
                      : Colors.blue[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 24,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.loading)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    else
                      const Icon(Icons.auto_awesome, size: 20),
                    const SizedBox(width: 8),
                    Text(widget.loading ? 'Generating...' : 'Generate Image'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
