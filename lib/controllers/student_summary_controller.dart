import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:library_management/global_varaible.dart';
import 'package:library_management/models/student_summary_model.dart';
import 'package:library_management/provider/student_summary_provider.dart';
import 'package:library_management/provider/token_provider.dart';

class StudentSummaryController {
  Future<bool> getStudentSummary({
    required WidgetRef ref,
    required String libraryId,
  }) async {
    try {
      final token = ref.read(tokenProvider);

      final response = await http.get(
        Uri.parse('$uri/api/$libraryId/sudentsummary'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        final StudentSummaryModel summary = StudentSummaryModel.fromMap(
          responseData['data'],
        );

        ref.read(studentSummaryProvider.notifier).setSummary(summary);

        return true;
      }

      return false;
    } catch (error) {
      print('GET STUDENT SUMMARY ERROR: $error');

      return false;
    }
  }
}
