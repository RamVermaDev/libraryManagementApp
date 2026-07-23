import 'dart:io';

import 'package:image_cropper/image_cropper.dart';

class ImageCropService {
  ImageCropService._();

  /// Crops an image into a square profile picture.
  /// Returns null if the user cancels.
  static Future<File?> crop(File image) async {
    final cropped = await ImageCropper().cropImage(
      sourcePath: image.path,

      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),

      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,

      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Profile Photo',

          lockAspectRatio: true,
          hideBottomControls: true,

          initAspectRatio: CropAspectRatioPreset.square,
        ),

        IOSUiSettings(
          title: 'Crop Profile Photo',
          aspectRatioLockEnabled: true,
        ),
      ],
    );

    if (cropped == null) return null;

    return File(cropped.path);
  }
}
