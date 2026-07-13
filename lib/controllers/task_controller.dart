import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:library_management/app_notification.dart';
import 'package:library_management/global_varaible.dart';
import 'package:library_management/models/task_model.dart';
import 'package:library_management/provider/task_provider.dart';
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
          final data = jsonDecode(response.body);

          final newTask = TaskModel.fromMap(
            data['task'] as Map<String, dynamic>,
          );

          ref.read(taskProvider.notifier).addTask(newTask);
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

  Future<void> getAllTasks({
    required BuildContext context,
    required WidgetRef ref,
    required String libraryId,
  }) async {
    try {
      final token = ref.read(tokenProvider);

      if (token == null || token.isEmpty) {
        showSnackBar(context, 'Authentication required');
        return;
      }

      final response = await http.get(
        Uri.parse('$uri/api/$libraryId/getalltask'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );
      //print(response.body);

      if (!context.mounted) return;

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        final List<dynamic> taskList = data['tasks'];
        //print(taskList);

        final tasks = taskList
            .map((task) => TaskModel.fromMap(task as Map<String, dynamic>))
            .toList();

        ref.read(taskProvider.notifier).setTasks(tasks);
      }

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {},
      );

      return;
    } catch (e, stackTrace) {
      debugPrint('Get All Tasks Error: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (context.mounted) {
        showSnackBar(context, 'Unable to load tasks');
      }

      return;
    }
  }

  Future<void> editTask({
    required BuildContext context,
    required WidgetRef ref,
    required String taskId,
    required String libraryId,
    required String title,
    required String description,
    required DateTime dueDate,
    required String urgency,
  }) async {
    try {
      final token = ref.read(tokenProvider);

      if (token == null || token.isEmpty) {
        showSnackBar(context, 'Authentication required');
        return;
      }

      final taskModel = TaskModel(
        id: taskId,
        libraryId: libraryId,
        title: title,
        description: description,
        dueDate: dueDate,
        urgency: urgency,
      );

      final response = await http.patch(
        Uri.parse('$uri/api/$taskId/edittask'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: taskModel.toJson(),
      );

      if (!context.mounted) return;

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          final data = jsonDecode(response.body);

          final updatedTask = TaskModel.fromMap(
            data['task'] as Map<String, dynamic>,
          );

          // Replace only the edited task in provider
          ref.read(taskProvider.notifier).updateTask(updatedTask);

          Navigator.pop(context);

          AppNotification.show(context, message: 'Task updated successfully');
        },
      );
    } catch (e, stackTrace) {
      debugPrint('Edit Task Error: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (context.mounted) {
        showSnackBar(context, 'Unable to update task');
      }
    }
  }

  Future<void> deleteTask({
    required BuildContext context,
    required WidgetRef ref,
    required String taskId,
    required String libraryId,
  }) async {
    try {
      final token = ref.read(tokenProvider);

      if (token == null || token.isEmpty) {
        showSnackBar(context, 'Authentication required');
        return;
      }

      final response = await http.delete(
        Uri.parse('$uri/api/$taskId/deletetask'),
        body: jsonEncode({'libraryId': libraryId}),
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
          ref.read(taskProvider.notifier).deleteTask(taskId);

          AppNotification.show(context, message: 'Task deleted successfully');
        },
      );
    } catch (e, stackTrace) {
      debugPrint('Delete Task Error: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (context.mounted) {
        showSnackBar(context, 'Unable to delete task');
      }
    }
  }

  Future<void> completeTask({
    required BuildContext context,
    required WidgetRef ref,
    required String taskId,
    required String libraryId,
  }) async {
    try {
      final token = ref.read(tokenProvider);

      if (token == null || token.isEmpty) {
        showSnackBar(context, 'Authentication required');
        return;
      }

      final response = await http.patch(
        Uri.parse('$uri/api/$taskId/completetask'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'libraryId': libraryId}),
      );

      if (!context.mounted) return;

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          final data = jsonDecode(response.body);

          final completedTask = TaskModel.fromMap(
            data['task'] as Map<String, dynamic>,
          );

          // Update only this task in provider
          ref.read(taskProvider.notifier).updateTask(completedTask);

          AppNotification.show(context, message: 'Task completed successfully');
        },
      );
    } catch (e, stackTrace) {
      debugPrint('Complete Task Error: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (context.mounted) {
        showSnackBar(context, 'Unable to complete task');
      }
    }
  }
}
