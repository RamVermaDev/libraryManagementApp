import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:library_management/app_notification.dart';
import 'package:library_management/global_varaible.dart';
import 'package:library_management/models/task_model.dart';
import 'package:library_management/provider/token_provider.dart';
import 'package:library_management/services/manage_http_response.dart';

class TaskController {
  Future<void> addTask({
    required BuildContext context,
    required WidgetRef ref,
    required String libraryId,
    required String title,
    required String description,
    required DateTime dueDate,
    required String urgency,
  }) async {
    try {
      final taskModel = TaskModel(
        libraryId: libraryId,
        title: title,
        description: description,
        dueDate: dueDate,
        urgency: urgency,
      );

      final token = ref.read(tokenProvider);

      if (token == null || token.isEmpty) {
        showSnackBar(context, 'Authentication required');
        return;
      }

      final response = await http.post(
        Uri.parse('$uri/api/addtask'),
        body: taskModel.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (!context.mounted) return;

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          Navigator.pop(context);

          AppNotification.show(context, message: 'Task added successfully');
        },
      );
    } catch (e, stackTrace) {
      debugPrint('Add Task Error: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (context.mounted) {
        showSnackBar(context, 'Unable to add task');
      }
    }
  }

  Future<List<TaskModel>> getAllTasks({
    required BuildContext context,
    required WidgetRef ref,
    required String libraryId,
  }) async {
    try {
      final token = ref.read(tokenProvider);

      if (token == null || token.isEmpty) {
        showSnackBar(context, 'Authentication required');
        return [];
      }

      final response = await http.get(
        Uri.parse('$uri/api/libraries/$libraryId/tasks'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (!context.mounted) return [];

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        final List<dynamic> taskList = data['tasks'];

        return taskList
            .map((task) => TaskModel.fromMap(task as Map<String, dynamic>))
            .toList();
      }

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {},
      );

      return [];
    } catch (e, stackTrace) {
      debugPrint('Get All Tasks Error: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (context.mounted) {
        showSnackBar(context, 'Unable to load tasks');
      }

      return [];
    }
  }
}
