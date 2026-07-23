import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:library_management/app_notification.dart';
import 'package:library_management/global_varaible.dart';
import 'package:library_management/models/payemnt_model.dart';
import 'package:library_management/models/student_model.dart';
import 'package:library_management/provider/revenue_provider.dart';
import 'package:library_management/provider/student_provider.dart';
import 'package:library_management/provider/student_summary_provider.dart';
import 'package:library_management/provider/token_provider.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/members.dart';
import 'package:library_management/services/manage_http_response.dart';

class StudentController {
  Future<void> addStudent({
    required BuildContext context,
    required WidgetRef ref,
    required String libraryId,
    required String slotTemplateId,
    String? seatId,
    required String name,
    required String phone,
    String? idProof,
    required int currentPlanDays,
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
          'slotTemplateId': slotTemplateId,
          'seatId': seatId,
          'name': name,
          'phone': phone,
          'idProof': idProof,
          'currentPlanDays': currentPlanDays,
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
          final data = responseData['data'] as Map<String, dynamic>;
          final newStudent = StudentModel.fromMap(
            data['student'] as Map<String, dynamic>,
          );

          ref.read(studentProvider.notifier).addStudent(newStudent);
          ref.read(studentProvider.notifier).addActiveStudent(newStudent);
          ref.read(studentSummaryProvider.notifier).addActiveStudent();

          final paymentData = data['payment'];
          if (paymentData != null) {
            final payment = PaymentModel.fromMap(
              paymentData as Map<String, dynamic>,
            );
            ref.read(revenueProvider.notifier).addPayment(payment);
          }

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

  Future<bool> getStudents({
    required WidgetRef ref,
    required String libraryId,
    required MemberStatus status,
    required int page,
    int limit = 20,
    bool append = false,
    MemberDayFilter? dayFilter,
  }) async {
    try {
      final token = ref.read(tokenProvider);

      final endpoint = _getEndpoint(libraryId: libraryId, status: status);
      final http.Response response;

      if (dayFilter != null) {
        final startDay = dayFilter.startDay;
        final endDay = dayFilter.endDay;
        response = await http.get(
          Uri.parse(
            '$uri$endpoint?page=$page&limit=$limit&startDay=$startDay&endDay=$endDay',
          ),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      } else {
        response = await http.get(
          Uri.parse('$uri$endpoint?page=$page&limit=$limit'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      }

      if (response.statusCode != 200) {
        debugPrint('GET STUDENTS ERROR: ${response.body}');
        return false;
      }

      final data = jsonDecode(response.body)['data'];

      final studentList = data['students'] as List<dynamic>? ?? [];

      final students = studentList
          .map((student) => StudentModel.fromMap(student))
          .toList();

      _saveStudentsToProvider(
        ref: ref,
        status: status,
        students: students,
        append: append,
        dayFilter: dayFilter,
      );

      return students.length == limit;
    } catch (error) {
      debugPrint('GET STUDENTS ERROR: $error');
      return false;
    }
  }

  Future<StudentModel?> updateStudentProfile({
    required BuildContext context,
    required WidgetRef ref,
    required String libraryId,
    required String studentId,
    required String name,
    required String phone,
    String? idProof,
  }) async {
    try {
      final token = ref.read(tokenProvider);

      if (token == null || token.isEmpty) {
        showSnackBar(context, 'Authentication required');
        return null;
      }

      final response = await http.patch(
        Uri.parse('$uri/api/$libraryId/students/$studentId/profile'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'name': name, 'phone': phone, 'idProof': idProof}),
      );

      if (!context.mounted) return null;

      if (response.statusCode != 200) {
        showSnackBar(context, getMessageFromResponse(response));
        return null;
      }

      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      final data = responseData['data'] as Map<String, dynamic>;
      final updatedStudent = StudentModel.fromMap(
        data['student'] as Map<String, dynamic>,
      );

      ref.read(studentProvider.notifier).updateStudent(updatedStudent);
      AppNotification.show(context, message: 'Student updated successfully');

      return updatedStudent;
    } catch (e, stackTrace) {
      debugPrint('Update Student Error: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (context.mounted) {
        showSnackBar(context, 'Unable to update student');
      }

      return null;
    }
  }

  String _getEndpoint({
    required String libraryId,
    required MemberStatus status,
  }) {
    switch (status) {
      case MemberStatus.all:
        return '/api/$libraryId/getstudents';

      case MemberStatus.active:
        return '/api/$libraryId/getactivestudents';

      case MemberStatus.expiring:
        return '/api/$libraryId/getexpiringstudents';

      case MemberStatus.expired:
        return '/api/$libraryId/getexpiredstudents';

      case MemberStatus.pending:
        return '/api/$libraryId/getrecentpending';
    }
  }

  void _saveStudentsToProvider({
    required WidgetRef ref,
    required MemberStatus status,
    MemberDayFilter? dayFilter,
    required List<StudentModel> students,
    required bool append,
  }) {
    final notifier = ref.read(studentProvider.notifier);

    switch (status) {
      case MemberStatus.all:
        append
            ? notifier.addMoreAllStudents(students)
            : notifier.setAllStudents(students);
        break;

      case MemberStatus.active:
        append
            ? notifier.addMoreActiveStudents(students)
            : notifier.setActiveStudents(students);
        break;

      case MemberStatus.pending:
        append
            ? notifier.addMorePendingStudents(students)
            : notifier.setPendingStudents(students);
        break;

      case MemberStatus.expiring:
        switch (dayFilter) {
          case MemberDayFilter.oneToThree:
            append
                ? notifier.addMoreExpiring1To3Days(students)
                : notifier.setExpiring1To3Days(students);
            break;

          case MemberDayFilter.fourToSix:
            append
                ? notifier.addMoreExpiring4To7Days(students)
                : notifier.setExpiring4To7Days(students);
            break;

          case MemberDayFilter.sevenToTen:
            append
                ? notifier.addMoreExpiring8To10Days(students)
                : notifier.setExpiring8To10Days(students);
            break;
          case null:
            // TODO: Handle this case.
            throw UnimplementedError();
        }
        break;

      case MemberStatus.expired:
        switch (dayFilter) {
          case MemberDayFilter.oneToThree:
            append
                ? notifier.addMoreExpired1To3Days(students)
                : notifier.setExpired1To3Days(students);
            break;

          case MemberDayFilter.fourToSix:
            append
                ? notifier.addMoreExpired4To7Days(students)
                : notifier.setExpired4To7Days(students);
            break;

          case MemberDayFilter.sevenToTen:
            append
                ? notifier.addMoreExpired8To10Days(students)
                : notifier.setExpired8To10Days(students);
            break;
          case null:
            // TODO: Handle this case.
            throw UnimplementedError();
        }
        break;
    }
  }
}
