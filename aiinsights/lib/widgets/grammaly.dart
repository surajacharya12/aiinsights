import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class Grammaly extends StatefulWidget {
  const Grammaly({super.key});

  @override
  State<Grammaly> createState() => _GrammalyState();
}

class _GrammalyState extends State<Grammaly> {
  final TextEditingController _controller = TextEditingController();
  String correctedText = '';
  bool loading = false;

  final String apiKey = 'AIzaSyCOEjEAsk-DEDvBBO9fz0sQnJ6DOR9DJ8M';

  int countWords(String text) {
    if (text.trim().isEmpty) return 0;
    return text.trim().split(RegExp(r'\s+')).length;
  }

  Future<void> checkGrammar() async {
    setState(() {
      loading = true;
      correctedText = '';
    });

    try {
      final prompt =
          'Correct the grammar of the following text and return only the corrected version:\n\n"${_controller.text}"';

      final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey',
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
        final responseData = jsonDecode(response.body);
        final result =
            responseData['candidates']?[0]?['content']?['parts']?[0]?['text'];
        setState(() {
          correctedText = result ?? "No correction available.";
        });
      } else {
        throw Exception('Failed: ${response.statusCode}');
      }
    } catch (error) {
      setState(() {
        correctedText = 'Error occurred while checking: $error';
      });
    } finally {
      setState(() => loading = false);
    }
  }

  void copyToClipboard() async {
    if (correctedText.isNotEmpty) {
      await Clipboard.setData(ClipboardData(text: correctedText));
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Corrected text copied!')));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1000),
          width: MediaQuery.of(context).size.width * 0.9,
          margin: const EdgeInsets.symmetric(vertical: 40),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              colors: [Color(0xFFE0E7FF), Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 24,
                spreadRadius: 2,
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '📝 AI Grammar Checker',
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E3A8A),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Fix grammar, spelling, and tone instantly using Gemini AI.',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _controller,
                  onChanged: (_) => setState(() {}),
                  maxLines: 8,
                  style: GoogleFonts.poppins(fontSize: 16),
                  decoration: InputDecoration(
                    hintText: 'Type or paste your text here (max 2000 words)',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${countWords(_controller.text)} / 2000 words',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: loading || _controller.text.trim().isEmpty
                        ? null
                        : checkGrammar,
                    icon: const Icon(Icons.auto_fix_high, color: Colors.white),
                    label: loading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Check Grammar',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      textStyle: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                if (correctedText.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '✅ Corrected Text:',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.green[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green.shade100),
                        ),
                        child: Text(
                          correctedText,
                          style: GoogleFonts.poppins(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: copyToClipboard,
                          icon: const Icon(Icons.copy),
                          label: const Text('Copy'),
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF10B981),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
