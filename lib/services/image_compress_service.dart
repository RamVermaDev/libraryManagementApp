import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class ImageCompressService {
  ImageCompressService._();

  /// Compresses a profile image before uploading.
  ///
  /// Returns the original image if compression fails.
  static Future<File> compress(
    File image, {
    int quality = 80,
    int minWidth = 700,
    int minHeight = 700,
  }) async {
    if (kIsWeb) {
      return image;
    }

    final tempDir = await getTemporaryDirectory();

    final targetPath =
        "${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";

    final compressed = await FlutterImageCompress.compressAndGetFile(
      image.absolute.path,
      targetPath,

      quality: quality,

      minWidth: minWidth,
      minHeight: minHeight,

      format: CompressFormat.jpeg,

      keepExif: false,

      autoCorrectionAngle: true,
    );

    if (compressed == null) {
      return image;
    }

    return File(compressed.path);
  }

  /// Deletes temporary compressed image.
  static Future<void> deleteTemp(File? image) async {
    if (image == null) return;

    try {
      if (await image.exists()) {
        await image.delete();
      }
    } catch (_) {}
  }
}
