import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:library_management/global_varaible.dart';
import 'package:library_management/models/slot_availability_model.dart';
import 'package:library_management/provider/slot_availability_provider.dart';
import 'package:library_management/services/manage_http_response.dart';

class SlotAvailabilityController {
  /// Fetches every slot template for a library along with its LIVE
  /// availability for the given date (defaults to today on the backend
  /// if omitted). This hits the occupancy-timeline engine, not a stored
  /// counter - so the numbers are always current.
  Future<void> fetchSlotAvailability({
    required BuildContext context,
    required WidgetRef ref,
    required String libraryId,
    DateTime? date,
  }) async {
    try {
      final Uri url = Uri.parse('$uri/api/$libraryId/slots/availability')
          .replace(
            queryParameters: date != null
                ? {'date': _formatDateForApi(date)}
                : null,
          );

      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (!context.mounted) return;

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          final data = jsonDecode(response.body);

          final List<dynamic> slotList = data['slots'] ?? [];

          final slots = slotList
              .map(
                (slot) =>
                    SlotAvailabilityModel.fromMap(slot as Map<String, dynamic>),
              )
              .toList();

          ref.read(slotAvailabilityProvider.notifier).setSlots(slots);
        },
      );
    } catch (e, stackTrace) {
      debugPrint('Fetch Slot Availability Error: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (context.mounted) {
        showSnackBar(context, 'Unable to load slots');
      }
    }
  }

  static String _formatDateForApi(DateTime date) {
    return '${date.year}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }
}
