import 'dart:io';
import 'package:flutter/material.dart';
import '../../backend_call/chatpdf_service.dart';
import 'chat_message_bubble.dart';

class Chatpdf extends StatefulWidget {
  @override
  _ChatpdfState createState() => _ChatpdfState();
}

class _ChatpdfState extends State<Chatpdf> {
  final List<Map<String, String>> messages = [];
  final TextEditingController inputController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  File? selectedFile;
  bool isLoading = false;
  bool isUploading = false;
  bool canSend = false;

  @override
  void initState() {
    super.initState();
    inputController.addListener(_onInputChanged);
  }

  void _onInputChanged() {
    setState(() {
      canSend = inputController.text.trim().isNotEmpty;
    });
  }

  @override
  void dispose() {
    inputController.removeListener(_onInputChanged);
    inputController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  Future<void> sendMessage() async {
    String input = inputController.text.trim();
    if (input.isEmpty) return;

    setState(() {
      messages.add({'role': 'user', 'content': input});
      inputController.clear();
      isLoading = true;
    });

    try {
      final answer = await ChatPdfService.sendMessage(input);
      setState(() {
        messages.add({
          'role': 'assistant',
          'content':
              answer ?? '❌ Sorry, something went wrong. Please try again.',
        });
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        messages.add({
          'role': 'assistant',
          'content': '❌ Sorry, something went wrong. Please try again.',
        });
        isLoading = false;
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> handlePdfUpload() async {
    if (selectedFile == null) return;

    setState(() => isUploading = true);
    final result = await ChatPdfService.uploadPdf(selectedFile!);
    setState(() {
      messages.add({'role': 'assistant', 'content': result});
      isUploading = false;
      selectedFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark
          ? colorScheme.background
          : const Color(0xFFF6F8FA),
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black,
            size: 28,
          ),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          "Smart Document Chat",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.file_upload, color: Colors.white, size: 28),
          ),
        ],
        elevation: 3,
        shadowColor: Colors.deepPurple.withOpacity(0.1),
      ),
      body: Column(
        children: [
          if (selectedFile != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              margin: const EdgeInsets.only(top: 10, left: 16, right: 16),
              decoration: BoxDecoration(
                color: isDark ? colorScheme.surface : Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.insert_drive_file,
                    size: 20,
                    color: Colors.deepPurple,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      selectedFile!.path.split('/').last,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: isDark ? colorScheme.onSurface : null,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18, color: Colors.red),
                    onPressed: () => setState(() => selectedFile = null),
                  ),
                ],
              ),
            ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? colorScheme.surface : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withOpacity(0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    itemCount: messages.length + (isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < messages.length) {
                        return ChatMessageBubble(msg: messages[index]);
                      } else {
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: SizedBox(
                              width: 60,
                              height: 20,
                              child: LinearProgressIndicator(
                                color: Colors.deepPurple,
                                backgroundColor: isDark
                                    ? colorScheme.surface
                                    : Colors.deepPurple.shade50,
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                if (messages.isEmpty)
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.picture_as_pdf,
                          size: 64,
                          color: Colors.deepPurple,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Upload a PDF and start chatting!',
                          style: TextStyle(
                            fontSize: 18,
                            color: isDark
                                ? colorScheme.primary
                                : Colors.deepPurple,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),
          Container(
            color: isDark ? colorScheme.surface : Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.upload_file,
                    color: Colors.deepPurple,
                    size: 28,
                  ),
                  onPressed: isLoading || isUploading
                      ? null
                      : () async {
                          final file = await ChatPdfService.pickPdfFile();
                          if (file != null) {
                            setState(() => selectedFile = file);
                          }
                        },
                ),
                if (selectedFile != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        textStyle: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      onPressed: isUploading ? null : handlePdfUpload,
                      icon: isUploading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.cloud_upload),
                      label: Text(isUploading ? "Uploading..." : "Upload PDF"),
                    ),
                  ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: isDark
                          ? colorScheme.background
                          : Colors.deepPurple.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: inputController,
                      enabled: !isLoading && !isUploading,
                      decoration: InputDecoration(
                        hintText: "Ask a question...",
                        hintStyle: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[700],
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                      style: TextStyle(
                        color: isDark ? colorScheme.onSurface : Colors.black,
                      ),
                      onSubmitted: (_) => sendMessage(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.send,
                    color: (canSend && !isLoading && !isUploading)
                        ? Colors.deepPurple
                        : Colors.grey,
                    size: 28,
                  ),
                  onPressed: (canSend && !isLoading && !isUploading)
                      ? sendMessage
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
