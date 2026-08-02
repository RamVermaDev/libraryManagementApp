import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:library_management/app_notification.dart';
import 'package:path_provider/path_provider.dart';
import 'package:library_management/global_varaible.dart';
import 'package:library_management/provider/current_library_provider.dart';
import 'package:library_management/provider/token_provider.dart';
import 'package:library_management/services/manage_http_response.dart';
import 'package:share_plus/share_plus.dart';

class BulkImportController {
  /// Downloads sample Excel template (.xlsx)
  Future<void> downloadSampleTemplate(
    BuildContext context,
    WidgetRef ref,
  ) async {
    try {
      final libraryId = ref.read(currentLibraryProvider);
      if (libraryId == null) {
        showSnackBar(context, 'Please select a library first');
        return;
      }

      final token = ref.read(tokenProvider);
      final url = Uri.parse('$uri/api/$libraryId/download-student-template');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          if (token != null && token.isNotEmpty) ...{
            'x-auth-token': token,
            'Authorization': 'Bearer $token',
          },
        },
      );

      if (response.statusCode == 200) {
        final bytes = Uint8List.fromList(response.bodyBytes);

        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/Library_Student_Import_Template.xlsx');
        await file.writeAsBytes(bytes);

        // Open native Android / iOS System Share & Save Drawer
        await Share.shareXFiles(
          [
            XFile(
              file.path,
              mimeType:
                  'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
              name: 'Library_Student_Import_Template.xlsx',
            ),
          ],
          text: 'Library Student Import Template (.xlsx)',
          subject: 'Library Student Import Template',
        );

        if (context.mounted) {
          AppNotification.show(
            context,
            message: 'Sample Excel template ready!',
          );
        }
      } else {
        if (context.mounted) {
          showSnackBar(context, 'Failed to download sample template');
        }
      }
    } catch (e) {
      debugPrint('Download Template Error: $e');
      if (context.mounted) {
        showSnackBar(context, 'Could not download sample template: $e');
      }
    }
  }

  /// Opens FilePicker to pick Excel file
  Future<FilePickerResult?> pickExcelFile(BuildContext context) async {
    try {
      try {
        return await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['xlsx', 'xls'],
        );
      } catch (_) {
        return await FilePicker.platform.pickFiles(type: FileType.any);
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, 'Could not open file picker');
      }
      return null;
    }
  }

  /// Uploads selected file path to backend
  Future<Map<String, dynamic>?> uploadExcelFile({
    required BuildContext context,
    required WidgetRef ref,
    required String filePath,
  }) async {
    try {
      final libraryId = ref.read(currentLibraryProvider);
      if (libraryId == null) {
        showSnackBar(context, 'Please select a library first');
        return null;
      }

      final token = ref.read(tokenProvider);
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$uri/api/$libraryId/bulk-import-students'),
      );

      if (token != null && token.isNotEmpty) {
        request.headers['x-auth-token'] = token;
        request.headers['Authorization'] = 'Bearer $token';
      }

      request.files.add(await http.MultipartFile.fromPath('file', filePath));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'body': response.body};
      } else {
        if (context.mounted) {
          showSnackBar(context, getMessageFromResponse(response));
        }
        return null;
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, 'Error processing Excel file upload');
      }
      return null;
    }
  }

  /// Clears library student records for re-import
  Future<bool> clearLibraryData({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    try {
      final libraryId = ref.read(currentLibraryProvider);
      if (libraryId == null) return false;

      final token = ref.read(tokenProvider);

      final response = await http.delete(
        Uri.parse('$uri/api/$libraryId/clear-library-data'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          if (token != null && token.isNotEmpty) ...{
            'x-auth-token': token,
            'Authorization': 'Bearer $token',
          },
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        if (context.mounted) {
          showSnackBar(context, getMessageFromResponse(response));
        }
        return false;
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, 'Failed to clear library data');
      }
      return false;
    }
  }
}
