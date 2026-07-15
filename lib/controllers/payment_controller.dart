import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:library_management/global_varaible.dart';
import 'package:library_management/models/payemnt_model.dart';
import 'package:library_management/provider/payment_provider.dart';
import 'package:library_management/provider/token_provider.dart';
import 'package:library_management/services/manage_http_response.dart';

class PaymentController {
  Future<void> getPayments({
    required BuildContext context,
    required WidgetRef ref,
    required String libraryId,
    required int page,
  }) async {
    try {
      final token = ref.read(tokenProvider);

      if (token == null || token.isEmpty) {
        showSnackBar(context, 'Authentication required');
        return;
      }

      final response = await http.get(
        Uri.parse('$uri/api/$libraryId/getpayments?page=$page'),
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

          final payments = (data['payments'] as List)
              .map((e) => PaymentModel.fromMap(e as Map<String, dynamic>))
              .toList();

          if (page == 1) {
            ref.read(paymentProvider.notifier).setPayments(payments);
          } else {
            ref.read(paymentProvider.notifier).addMorePayments(payments);
          }
        },
      );
    } catch (e, stackTrace) {
      debugPrint('Get Payments Error: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (context.mounted) {
        showSnackBar(context, 'Unable to fetch payments');
      }
    }
  }
}
