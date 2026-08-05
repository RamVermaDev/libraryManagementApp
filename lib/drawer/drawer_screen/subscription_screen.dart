import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/controllers/subscription_controller.dart';
import 'package:library_management/drawer/drawer_screen/subscription/widgets/active_status_banner.dart';
import 'package:library_management/drawer/drawer_screen/subscription/widgets/plan_duration_toggle.dart';
import 'package:library_management/drawer/drawer_screen/subscription/widgets/subscription_plan_card.dart';
import 'package:library_management/global_varaible.dart';
import 'package:library_management/provider/token_provider.dart';
import 'package:library_management/provider/user_provider.dart';
import 'package:library_management/services/manage_http_response.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class SubscriptionScreen extends ConsumerStatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  ConsumerState<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscriptionScreen> {
  bool _isYearly = true;
  bool _isProcessingPayment = false;
  String? _pendingPlan;

  int _monthlyPrice = 99;
  int _yearlyPrice = 999;

  late Razorpay _razorpay;
  final _subscriptionController = SubscriptionController();

  @override
  void initState() {
    super.initState();
    _initRazorpay();
    _fetchSubscriptionStatus();
  }

  void _initRazorpay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  Future<void> _fetchSubscriptionStatus() async {
    try {
      final token = ref.read(tokenProvider);
      final response = await http.get(
        Uri.parse('$uri/api/subscription/status'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (!mounted) return;
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final config = data['config'];
        setState(() {
          _monthlyPrice = (config['monthlyPrice'] as num?)?.toInt() ?? 99;
          _yearlyPrice = (config['yearlyPrice'] as num?)?.toInt() ?? 999;
        });
      }
    } catch (_) {
      // Silently fall back to defaults — UI still works
    }
  }

  Future<void> _startPaymentFlow() async {
    final plan = _isYearly ? 'yearly' : 'monthly';
    setState(() {
      _isProcessingPayment = true;
      _pendingPlan = plan;
    });

    final orderData = await _subscriptionController.createOrder(
      context: context,
      ref: ref,
      plan: plan,
    );

    if (orderData == null || !mounted) {
      setState(() => _isProcessingPayment = false);
      return;
    }

    final user = ref.read(userProvider);

    final options = {
      'key': orderData['keyId'],
      'amount': orderData['amount'],
      'name': 'Library Pro',
      'description': _isYearly ? 'Yearly Pro Subscription' : 'Monthly Pro Subscription',
      'order_id': orderData['orderId'],
      'prefill': {
        'contact': '',
        'email': user?.email ?? '',
      },
      'theme': {
        'color': '#6366F1',
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Razorpay Open Error: $e');
      if (mounted) {
        setState(() => _isProcessingPayment = false);
        showSnackBar(context, 'Unable to open Razorpay payment sheet.');
      }
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    final orderId = response.orderId;
    final paymentId = response.paymentId;
    final signature = response.signature;
    final plan = _pendingPlan ?? (_isYearly ? 'yearly' : 'monthly');

    if (orderId != null && paymentId != null && signature != null) {
      await _subscriptionController.verifyPayment(
        context: context,
        ref: ref,
        orderId: orderId,
        paymentId: paymentId,
        signature: signature,
      );
    }
    if (mounted) {
      setState(() => _isProcessingPayment = false);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    if (mounted) {
      setState(() => _isProcessingPayment = false);
      showSnackBar(
        context,
        'Payment Failed: ${response.message ?? "Cancelled"}',
      );
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    if (mounted) {
      setState(() => _isProcessingPayment = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final subscription = user?.subscription;

    final endAt = subscription?.endAt;
    final daysRemaining = subscription?.daysRemaining ?? 0;
    final isTrial = (subscription?.isTrial ?? true) && daysRemaining > 0;
    final expiryDateText = endAt != null
        ? DateFormat('MMM d, yyyy').format(endAt)
        : 'N/A';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.heading,
        title: const Text(
          'Subscription Plan',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ActiveStatusBanner(
              isTrial: isTrial,
              daysRemaining: daysRemaining,
              expiryDateText: expiryDateText,
            ),
            const SizedBox(height: 24),
            PlanDurationToggle(
              isYearly: _isYearly,
              onChanged: (val) => setState(() => _isYearly = val),
            ),
            const SizedBox(height: 24),
            Stack(
              children: [
                SubscriptionPlanCard(
                  isYearly: _isYearly,
                  monthlyPrice: _monthlyPrice,
                  yearlyPrice: _yearlyPrice,
                  onUpgradePressed: _isProcessingPayment ? () {} : _startPaymentFlow,
                ),
                if (_isProcessingPayment)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white60,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
