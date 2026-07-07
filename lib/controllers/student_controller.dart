import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:library_management/app_notification.dart';
import 'package:library_management/global_varaible.dart';
import 'package:library_management/models/student_model.dart';
import 'package:library_management/provider/student_provider.dart';
import 'package:library_management/provider/token_provider.dart';
import 'package:library_management/services/manage_http_response.dart';

class StudentController {
  Future<void> addStudent({
    required BuildContext context,
    required WidgetRef ref,
    required String libraryId,
    required String name,
    required String phone,
    String? idProof,
    required String planId,
    required int programDays,
    required DateTime startDate,
    required DateTime expireDate,
    required double amount,
    double discount = 0,
    double paidAmount = 0,
    String? paymentMode,
    String? notes,
  }) async {
    try {
      final token = ref.read(tokenProvider);

      if (token == null || token.isEmpty) {
        showSnackBar(context, 'Authentication required');
        return;
      }

      final response = await http.post(
        Uri.parse('$uri/api/addstudent'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'libraryId': libraryId,
          'name': name,
          'phone': phone,
          'idProof': idProof,
          'planId': planId,
          'programDays': programDays,
          'startDate': startDate.toIso8601String(),
          'expireDate': expireDate.toIso8601String(),
          'amount': amount,
          'discount': discount,
          'paidAmount': paidAmount,
          'paymentMode': paymentMode,
          'notes': notes,
        }),
      );

      if (!context.mounted) return;

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          final Map<String, dynamic> responseData = jsonDecode(response.body);

          final newStudent = StudentModel.fromMap(
            responseData['data']['student'] as Map<String, dynamic>,
          );

          ref.read(studentProvider.notifier).addStudent(newStudent);

          Navigator.pop(context);

          AppNotification.show(context, message: 'Student added successfully');
        },
      );
    } catch (e, stackTrace) {
      debugPrint('Add Student Error: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (context.mounted) {
        showSnackBar(context, 'Unable to add student');
      }
    }
  }

  Future<bool> getAllStudents({
    required WidgetRef ref,
    required String libraryId,
    required int page,
    int limit = 20,
    bool append = false,
  }) async {
    try {
      final token = ref.read(tokenProvider);
      final response = await http.get(
        Uri.parse(
          '$uri/api/$libraryId/getstudents'
          '?page=$page&limit=$limit',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        //print(data);

        final studentList = (data['students'] as List<dynamic>? ?? []);

        final students = studentList
            .map((student) => StudentModel.fromMap(student))
            .toList();

        if (append) {
          ref.read(studentProvider.notifier).addStudents(students);
        } else {
          ref.read(studentProvider.notifier).setStudents(students);
        }

        return students.length == limit;
      }

      print('GET STUDENTS ERROR: ${response.body}');
      return false;
    } catch (error) {
      print('GET STUDENTS ERROR: $error');
      return false;
    }
  }
}
