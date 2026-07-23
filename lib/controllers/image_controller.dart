import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:library_management/app_notification.dart';
import 'package:library_management/global_varaible.dart';
import 'package:library_management/provider/student_provider.dart';
import 'package:library_management/provider/token_provider.dart';
import 'package:library_management/services/manage_http_response.dart';

class ImageController {
  MediaType _getMediaType(String filePath) {
    final ext = filePath.toLowerCase();
    if (ext.endsWith('.png')) return MediaType('image', 'png');
    if (ext.endsWith('.webp')) return MediaType('image', 'webp');
    if (ext.endsWith('.gif')) return MediaType('image', 'gif');
    if (ext.endsWith('.heic')) return MediaType('image', 'heic');
    return MediaType('image', 'jpeg');
  }

  Future<String?> uploadImage({
    required BuildContext context,
    required WidgetRef ref,
    required File image,
  }) async {
    try {
      final token = ref.read(tokenProvider);

      if (token == null || token.isEmpty) {
        return null;
      }

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$uri/api/upload/image'),
      );

      request.headers.addAll({'Authorization': 'Bearer $token'});

      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          image.path,
          contentType: _getMediaType(image.path),
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      String? publicId;

      if (!context.mounted) return null;

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          publicId = data['publicId'] as String?;
        },
      );

      return publicId;
    } catch (e, stackTrace) {
      debugPrint('UPLOAD IMAGE ERROR: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (context.mounted) {
        showSnackBar(context, 'Unable to upload image');
      }

      return null;
    }
  }

  Future<String?> uploadStudentImage({
    required BuildContext context,
    required WidgetRef ref,
    required String studentId,
    required File image,
  }) async {
    try {
      print('Uploading student image for studentId: $studentId');
      final token = ref.read(tokenProvider);

      if (token == null || token.isEmpty) {
        showSnackBar(context, 'Authentication required');
        return null;
      }

      final request = http.MultipartRequest(
        'PUT',
        Uri.parse('$uri/api/upload/student/$studentId/image'),
      );

      request.headers.addAll({'Authorization': 'Bearer $token'});

      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          image.path,
          contentType: _getMediaType(image.path),
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (!context.mounted) return null;

      String? uploadedImageUrl;

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          final responseData =
              jsonDecode(response.body) as Map<String, dynamic>;

          final profileImage = responseData['photoUrl'] as String?;

          if (profileImage == null || profileImage.isEmpty) {
            showSnackBar(context, 'Image upload failed');
            return;
          }

          uploadedImageUrl = profileImage;

          ref
              .read(studentProvider.notifier)
              .updateStudentPhoto(
                studentId: studentId,
                profileImage: profileImage,
              );

          AppNotification.show(context, message: 'Image uploaded successfully');
        },
      );

      return uploadedImageUrl;
    } catch (e, stackTrace) {
      debugPrint('UPLOAD STUDENT IMAGE ERROR: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (context.mounted) {
        showSnackBar(context, 'Unable to upload image');
      }

      return null;
    }
  }
}
