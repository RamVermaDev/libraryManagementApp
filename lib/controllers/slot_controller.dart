import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:library_management/app_notification.dart';
import 'package:library_management/global_varaible.dart';
import 'package:library_management/models/slot_model.dart';
import 'package:library_management/provider/slot_provider.dart';
import 'package:library_management/provider/token_provider.dart';
import 'package:library_management/services/manage_http_response.dart';

class SlotController {
  Future<void> createSlot({
    required BuildContext context,
    required WidgetRef ref,
    required String libraryId,
    required String name,
    required double monthlyPrice,
    required int startMinute,
    required int endMinute,
  }) async {
    try {
      final slotModel = SlotModel(
        name: name,
        monthlyPrice: monthlyPrice,
        startMinute: startMinute,
        endMinute: endMinute,
      );

      final token = ref.read(tokenProvider);

      if (token == null || token.isEmpty) {
        showSnackBar(context, 'Authentication required');
        return;
      }

      print('hap');

      final response = await http.post(
        Uri.parse('$uri/api/$libraryId/slot'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: slotModel.toJson(),
      );

      if (!context.mounted) return;

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          final data = jsonDecode(response.body);

          final slot = SlotModel.fromMap(data['slot'] as Map<String, dynamic>);

          ref.read(slotProvider.notifier).addSlot(slot);

          Navigator.pop(context);

          AppNotification.show(context, message: 'Slot created successfully');
        },
      );
    } catch (e, stackTrace) {
      debugPrint('Create Slot Error: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (context.mounted) {
        showSnackBar(context, 'Unable to create slot');
      }
    }
  }

  Future<void> getAllSlots({
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
        Uri.parse('$uri/api/$libraryId/slots'),

        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (!context.mounted) return;

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(response.body) as Map<String, dynamic>;

        final List<dynamic> slotList = data['slots'];

        final slots = slotList
            .map((slot) => SlotModel.fromMap(slot as Map<String, dynamic>))
            .toList();

        ref.read(slotProvider.notifier).setSlots(slots);
      }

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {},
      );
    } catch (e, stackTrace) {
      debugPrint('Get All Slots Error: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (context.mounted) {
        showSnackBar(context, 'Unable to load slots');
      }
    }
  }

  Future<void> editSlot({
    required BuildContext context,
    required WidgetRef ref,
    required String slotId,
    required String libraryId,
    required String name,
    required double monthlyPrice,
    required int startMinute,
    required int endMinute,
  }) async {
    try {
      final token = ref.read(tokenProvider);

      if (token == null || token.isEmpty) {
        showSnackBar(context, 'Authentication required');
        return;
      }

      final slotModel = SlotModel(
        id: slotId,
        libraryId: libraryId,
        name: name,
        monthlyPrice: monthlyPrice,
        startMinute: startMinute,
        endMinute: endMinute,
      );

      final response = await http.patch(
        Uri.parse('$uri/api/$slotId/editslot'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: slotModel.toJson(),
      );

      if (!context.mounted) return;

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          final data = jsonDecode(response.body);

          final updatedSlot = SlotModel.fromMap(
            data['slot'] as Map<String, dynamic>,
          );

          ref.read(slotProvider.notifier).updateSlot(updatedSlot);

          Navigator.pop(context);

          AppNotification.show(context, message: 'Slot updated successfully');
        },
      );
    } catch (e, stackTrace) {
      debugPrint('Edit Slot Error: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (context.mounted) {
        showSnackBar(context, 'Unable to update slot');
      }
    }
  }

  Future<void> changeSlotStatus({
    required BuildContext context,
    required WidgetRef ref,
    required String slotId,
    required String libraryId,
  }) async {
    try {
      final token = ref.read(tokenProvider);

      if (token == null || token.isEmpty) {
        showSnackBar(context, 'Authentication required');
        return;
      }

      final response = await http.patch(
        Uri.parse('$uri/api/$slotId/status'),
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

          final updatedSlot = SlotModel.fromMap(
            data['slot'] as Map<String, dynamic>,
          );

          ref.read(slotProvider.notifier).updateSlot(updatedSlot);

          AppNotification.show(
            context,
            message: updatedSlot.isActive
                ? 'Slot activated'
                : 'Slot deactivated',
          );
        },
      );
    } catch (e, stackTrace) {
      debugPrint('Change Slot Status Error: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (context.mounted) {
        showSnackBar(context, 'Unable to change slot status');
      }
    }
  }

  Future<void> deleteSlot({
    required BuildContext context,
    required WidgetRef ref,
    required String slotId,
    required String libraryId,
  }) async {
    try {
      final token = ref.read(tokenProvider);

      if (token == null || token.isEmpty) {
        showSnackBar(context, 'Authentication required');
        return;
      }

      final response = await http.delete(
        Uri.parse('$uri/api/$slotId/deleteslot'),
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
          ref.read(slotProvider.notifier).deleteSlot(slotId);

          AppNotification.show(context, message: 'Slot deleted');
        },
      );
    } catch (e, stackTrace) {
      debugPrint('Delete Slot Error: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (context.mounted) {
        showSnackBar(context, 'Unable to delete slot');
      }
    }
  }
}
