import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'image_download.dart';

class ImageOutput extends StatelessWidget {
  final Uint8List? imageBytes;
  final String? error;
  final bool loading;

  const ImageOutput({
    required this.imageBytes,
    required this.error,
    required this.loading,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
          if (loading) ...[
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
          ] else if (error != null) ...[
            Text(
              error!,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ] else if (imageBytes != null) ...[
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 350),
              child: Image.memory(imageBytes!, fit: BoxFit.contain),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () =>
                  ImageDownloader.downloadImage(imageBytes!, context),
              icon: const Icon(Icons.download, size: 20),
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
          ] else ...[
            const Text(
              'Your generated image will appear here.',
              style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
            ),
          ],
        ],
      ),
    );
  }
}
