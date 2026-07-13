import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:library_management/global_varaible.dart';
import 'package:library_management/models/revenue_dashboard_model.dart';
import 'package:library_management/provider/revenue_provider.dart';
import 'package:library_management/provider/token_provider.dart';
import 'package:library_management/services/manage_http_response.dart';

class RevenueSummaryController {
  Future<void> getRevenueSummary({
    required BuildContext context,
    required WidgetRef ref,
    required String libraryId,
  }) async {
    try {
      final token = ref.read(tokenProvider);

      if (token == null || token.isEmpty) {
        showSnackBar(context, 'Authentication required');
      }

      final response = await http.get(
        Uri.parse('$uri/api/$libraryId/dashboard'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final revenue = RevenueDashboardModel.fromMap(data['revenue']);

        ref.read(revenueProvider.notifier).setDashboard(revenue);

        // final a = data['revenue'];
        // final List<dynamic> paymentList = a['recentPayments'];
        // final payments = paymentList
        //     .map((pay) => PaymentModel.fromMap(pay as Map<String, dynamic>))
        //     .toList();
        //print(payments.length);
        //print(ref.watch(revenueProvider).summary);
      }

      if (!context.mounted) return;

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {},
      );
    } catch (e, stackTrace) {
      debugPrint('Get All Tasks Error: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (context.mounted) {
        showSnackBar(context, 'Unable to load tasks');
      }
    }
  }
}
