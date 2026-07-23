import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:library_management/services/image_compress_service.dart';
import 'package:library_management/services/image_crop_service.dart';
import 'package:library_management/services/profile_image_picker.dart';

class ProfilePhotoService {
  ProfilePhotoService._();

  /// Opens Camera/Gallery picker,
  /// crops the image into a square,
  /// compresses it,
  /// and returns the final image ready for upload.
  static Future<File?> pick({
    required BuildContext context,
    required ImageSource source,
  }) async {
    File? image;

    switch (source) {
      case ImageSource.camera:
        image = await ProfileImagePicker.pickFromCamera();
        break;

      case ImageSource.gallery:
        image = await ProfileImagePicker.pickFromGallery();
        break;
    }

    if (image == null) {
      return null;
    }

    final cropped = await ImageCropService.crop(image);

    if (cropped == null) {
      return null;
    }

    final compressed = await ImageCompressService.compress(cropped);

    return compressed;
  }
}
