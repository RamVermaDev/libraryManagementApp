import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:library_management/global_varaible.dart';
import 'package:library_management/models/seat_availability_model.dart';
import 'package:library_management/provider/seat_availability_provider.dart';
import 'package:library_management/services/manage_http_response.dart';

class SeatAvailabilityController {
  /// Fetches every physical seat for a library, tagged booked/available,
  /// for the given slot template (and date, defaults to today).
  Future<void> fetchSeatMap({
    required BuildContext context,
    required WidgetRef ref,
    required String libraryId,
    required String slotTemplateId,
    DateTime? date,
  }) async {
    try {
      final Uri url = Uri.parse('$uri/api/$libraryId/seat-map').replace(
        queryParameters: {
          'slotTemplateId': slotTemplateId,
          if (date != null) 'date': _formatDateForApi(date),
        },
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

          final List<dynamic> seatList = data['seats'] ?? [];

          final seats = seatList
              .map(
                (seat) =>
                    SeatAvailabilityModel.fromMap(seat as Map<String, dynamic>),
              )
              .toList();

          ref.read(seatAvailabilityProvider.notifier).setSeats(seats);
        },
      );
    } catch (e, stackTrace) {
      debugPrint('Fetch Seat Map Error: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (context.mounted) {
        showSnackBar(context, 'Unable to load seats');
      }
    }
  }

  static String _formatDateForApi(DateTime date) {
    return '${date.year}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }
}
