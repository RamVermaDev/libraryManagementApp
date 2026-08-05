import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:library_management/app_notification.dart';
import 'package:library_management/global_varaible.dart';
import 'package:library_management/local_storage.dart';
import 'package:library_management/provider/token_provider.dart';
import 'package:library_management/provider/user_provider.dart';
import 'package:library_management/services/manage_http_response.dart';

class SubscriptionController {
  Future<Map<String, dynamic>?> createOrder({
    required BuildContext context,
    required WidgetRef ref,
    required String plan, // 'monthly' or 'yearly'
  }) async {
    try {
      final token = ref.read(tokenProvider);
      if (token == null || token.isEmpty) return null;

      final response = await http.post(
        Uri.parse('$uri/api/subscription/create-order'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'plan': plan}),
      );

      if (!context.mounted) return null;

      if (response.statusCode != 200) {
        showSnackBar(context, getMessageFromResponse(response));
        return null;
      }

      final data = jsonDecode(response.body);
      return data;
    } catch (e, stackTrace) {
      debugPrint('Create Subscription Order Error: $e\n$stackTrace');
      if (context.mounted) {
        showSnackBar(context, 'Unable to initialize payment order.');
      }
      return null;
    }
  }

  Future<bool> verifyPayment({
    required BuildContext context,
    required WidgetRef ref,
    required String orderId,
    required String paymentId,
    required String signature,
  }) async {
    try {
      final token = ref.read(tokenProvider);
      if (token == null || token.isEmpty) return false;

      final response = await http.post(
        Uri.parse('$uri/api/subscription/verify-payment'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'razorpay_order_id': orderId,
          'razorpay_payment_id': paymentId,
          'razorpay_signature': signature,
          // plan is NOT sent — backend reads it from Razorpay order notes
        }),
      );

      if (!context.mounted) return false;

      if (response.statusCode != 200) {
        showSnackBar(context, getMessageFromResponse(response));
        return false;
      }

      final data = jsonDecode(response.body);
      final userMap = data['user'];
      final userJson = jsonEncode(userMap);

      // Save updated user data to local storage & Riverpod state
      await LocalStorage.saveLogin(token: token, userJson: userJson);
      ref.read(userProvider.notifier).setUser(userJson);

      AppNotification.show(
        context,
        message: 'Subscription upgraded successfully!',
      );

      return true;
    } catch (e, stackTrace) {
      debugPrint('Verify Subscription Payment Error: $e\n$stackTrace');
      if (context.mounted) {
        showSnackBar(context, 'Payment verification failed.');
      }
      return false;
    }
  }
}
