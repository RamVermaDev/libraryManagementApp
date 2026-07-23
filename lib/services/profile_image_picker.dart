import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ProfileImagePicker {
  ProfileImagePicker._();

  static final ImagePicker _picker = ImagePicker();

  static Future<File?> pickFromGallery() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );

    if (image == null) return null;

    return File(image.path);
  }

  static Future<File?> pickFromCamera() async {
    final image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 100,
    );

    if (image == null) return null;

    return File(image.path);
  }
}
