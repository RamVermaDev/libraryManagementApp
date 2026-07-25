import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:library_management/app_notification.dart';
import 'package:library_management/global_varaible.dart';
import 'package:library_management/models/seat_config_model.dart';
import 'package:library_management/provider/seat_config_provider.dart';
import 'package:library_management/provider/token_provider.dart';
import 'package:library_management/services/manage_http_response.dart';

class SeatConfigUpdateResult {
  final bool success;
  final bool conflict;
  final String message;
  final List<dynamic> affectedBookings;
  final SeatConfigModel? config;

  SeatConfigUpdateResult({
    required this.success,
    this.conflict = false,
    required this.message,
    this.affectedBookings = const [],
    this.config,
  });
}

class SeatConfigController {
  Future<SeatConfigModel?> fetchSeatConfig({
    required BuildContext context,
    required WidgetRef ref,
    required String libraryId,
  }) async {
    try {
      final token = ref.read(tokenProvider);

      if (token == null || token.isEmpty) {
        showSnackBar(context, 'Authentication required');
        return null;
      }

      final response = await http.get(
        Uri.parse('$uri/api/$libraryId/seats/config'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        debugPrint('GET SEAT CONFIG ERROR: ${response.body}');
        return null;
      }

      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      final data = responseData['data'] as Map<String, dynamic>;

      final config = SeatConfigModel.fromMap(data);
      ref.read(seatConfigProvider.notifier).setConfig(config);

      return config;
    } catch (e, stackTrace) {
      debugPrint('Fetch Seat Config Error: $e');
      debugPrintStack(stackTrace: stackTrace);
      return null;
    }
  }

  Future<SeatConfigUpdateResult> updateSeatConfig({
    required BuildContext context,
    required WidgetRef ref,
    required String libraryId,
    required int totalSeats,
    required int rows,
    required int columns,
    String? prefix,
  }) async {
    try {
      final token = ref.read(tokenProvider);

      if (token == null || token.isEmpty) {
        showSnackBar(context, 'Authentication required');
        return SeatConfigUpdateResult(
          success: false,
          message: 'Authentication required',
        );
      }

      final response = await http.patch(
        Uri.parse('$uri/api/$libraryId/seats/config'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'totalSeats': totalSeats,
          'rows': rows,
          'columns': columns,
          if (prefix != null && prefix.trim().isNotEmpty) 'prefix': prefix.trim(),
          if (prefix != null && prefix.trim().isNotEmpty) 'seatPrefix': prefix.trim(),
        }),
      );

      final responseData = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        final isConflict = responseData['conflict'] == true;
        final affected = responseData['affectedBookings'] as List<dynamic>? ?? [];
        final msg = responseData['message']?.toString() ?? 'Failed to update seat layout';

        if (!isConflict && context.mounted) {
          showSnackBar(context, msg);
        }

        return SeatConfigUpdateResult(
          success: false,
          conflict: isConflict,
          message: msg,
          affectedBookings: affected,
        );
      }

      final data = responseData['data'] as Map<String, dynamic>;
      final config = SeatConfigModel.fromMap(data);

      ref.read(seatConfigProvider.notifier).setConfig(config);

      if (context.mounted) {
        AppNotification.show(
          context,
          message: responseData['message']?.toString() ??
              'Seat configuration updated successfully',
        );
      }

      return SeatConfigUpdateResult(
        success: true,
        message: 'Updated successfully',
        config: config,
      );
    } catch (e, stackTrace) {
      debugPrint('Update Seat Config Error: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (context.mounted) {
        showSnackBar(context, 'Unable to update seat configuration');
      }

      return SeatConfigUpdateResult(
        success: false,
        message: 'Unable to update seat configuration',
      );
    }
  }
}
