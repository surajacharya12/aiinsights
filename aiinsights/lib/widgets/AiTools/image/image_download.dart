import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class ImageDownloader {
  static Future<void> downloadImage(
    Uint8List imageBytes,
    BuildContext context,
  ) async {
    String fileName =
        'aiinsights_image_${DateTime.now().millisecondsSinceEpoch}.png';

    try {
      if (Platform.isAndroid || Platform.isIOS) {
        PermissionStatus status = await Permission.storage.request();
        if (!status.isGranted) throw Exception('Storage permission denied.');
      }

      Directory directory = Platform.isAndroid
          ? Directory('/storage/emulated/0/Download')
          : await getApplicationDocumentsDirectory();

      if (!await directory.exists()) await directory.create(recursive: true);

      File file = File('${directory.path}/$fileName');
      await file.writeAsBytes(imageBytes);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Image saved to ${file.path}')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Download failed: $e')));
    }
  }
}
