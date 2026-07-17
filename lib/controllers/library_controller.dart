import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:library_management/app_notification.dart';
import 'package:library_management/global_varaible.dart';
import 'package:library_management/local_storage.dart';
import 'package:library_management/models/library_model.dart';
import 'package:library_management/provider/current_library_provider.dart';
import 'package:library_management/provider/library_provider.dart';
import 'package:library_management/provider/token_provider.dart';
import 'package:library_management/services/manage_http_response.dart';

class LibraryController {
  Future<bool> createLibrary({
    required BuildContext context,
    required WidgetRef ref,
    required String libraryName,
    String tagLine = '',
    required String whatsappNumber,
    required String city,
    String state = '',
    String pinCode = '',
    required int totalSeats,
  }) async {
    try {
      LibraryModel libraryModel = LibraryModel(
        libraryName: libraryName,
        tagLine: tagLine,
        whatsappNumber: whatsappNumber,
        city: city,
        state: state,
        pinCode: pinCode,
        totalStudents: 0,
        totalSeats: totalSeats,
      );

      final token = ref.read(tokenProvider);
      if (token == null || token.isEmpty) {
        showSnackBar(context, "Authentication required");
        return false;
      }

      http.Response response = await http.post(
        Uri.parse('$uri/api/createlibrary'),
        body: libraryModel.toJson(),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
          "Authorization": "Bearer $token",
        },
      );

      if (!context.mounted) return false;

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          final createdLibrary = LibraryModel.fromMap(
            data['library'] as Map<String, dynamic>,
          );

          ref.read(libraryProvider.notifier).addLibrary(createdLibrary);
          ref
              .read(currentLibraryProvider.notifier)
              .setLibrary(createdLibrary.id);
          if (createdLibrary.id != null) {
            unawaited(
              LocalStorage.saveCurrentLibrary(libraryId: createdLibrary.id!),
            );
          }
          Navigator.pop(context, true);

          AppNotification.show(context, message: 'Library Created');
        },
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e, stackTrace) {
      debugPrint("Signup Error: $e");
      debugPrintStack(stackTrace: stackTrace);

      if (context.mounted) {
        showSnackBar(context, "Unable to create library");
      }

      return false;
    }
  }

  Future<bool> updateLibrary({
    required BuildContext context,
    required WidgetRef ref,
    required String libraryId,
    required String libraryName,
    String tagLine = '',
    required String whatsappNumber,
    required String city,
    String state = '',
    String pinCode = '',
    required int totalSeats,
  }) async {
    try {
      final token = ref.read(tokenProvider);
      if (token == null || token.isEmpty) {
        showSnackBar(context, "Authentication required");
        return false;
      }

      final libraryModel = LibraryModel(
        id: libraryId,
        libraryName: libraryName,
        tagLine: tagLine,
        whatsappNumber: whatsappNumber,
        city: city,
        state: state,
        pinCode: pinCode,
        totalSeats: totalSeats,
      );

      final response = await http.patch(
        Uri.parse('$uri/api/$libraryId/updatelibrary'),
        body: libraryModel.toJson(),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
          "Authorization": "Bearer $token",
        },
      );

      if (!context.mounted) return false;

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          final updatedLibrary = LibraryModel.fromMap(
            data['library'] as Map<String, dynamic>,
          );

          ref.read(libraryProvider.notifier).updateLibrary(updatedLibrary);
          Navigator.pop(context, true);

          AppNotification.show(context, message: 'Library Updated');
        },
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e, stackTrace) {
      debugPrint("Update Library Error: $e");
      debugPrintStack(stackTrace: stackTrace);

      if (context.mounted) {
        showSnackBar(context, "Unable to update library");
      }

      return false;
    }
  }

  Future<void> fetchOwnerLibraries({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    try {
      final token = ref.read(tokenProvider);
      if (token == null || token.isEmpty) {
        showSnackBar(context, "Authentication required");
        return;
      }

      final response = await http.get(
        Uri.parse('$uri/api/my-libraries'),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
          "Authorization": "Bearer $token",
        },
      );

      if (!context.mounted) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final libraries = (data['libraries'] as List<dynamic>? ?? [])
            .map((library) => LibraryModel.fromMap(library))
            .toList();

        ref.read(libraryProvider.notifier).setLibraries(libraries);
        return;
      }

      showSnackBar(context, getMessageFromResponse(response));
    } catch (e, stackTrace) {
      debugPrint("Fetch Libraries Error: $e");
      debugPrintStack(stackTrace: stackTrace);
      if (context.mounted) {
        showSnackBar(context, "Unable to fetch libraries");
      }
    }
  }
}
