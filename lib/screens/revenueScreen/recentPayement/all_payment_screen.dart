import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/controllers/payment_controller.dart';
import 'package:library_management/provider/payment_provider.dart';
import 'package:library_management/screens/revenueScreen/recentPayement/payement_tile.dart';

class AllPaymentScreen extends ConsumerStatefulWidget {
  const AllPaymentScreen({super.key, this.scale = 1});

  final double scale;

  @override
  ConsumerState<AllPaymentScreen> createState() => _AllPaymentScreenState();
}

class _AllPaymentScreenState extends ConsumerState<AllPaymentScreen> {
  final PaymentController _paymentController = PaymentController();
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  int _page = 1;

  @override
  void initState() {
    super.initState();

    _getPayments();

    _scrollController.addListener(_scrollListener);
  }

  Future<void> _getPayments() async {
    setState(() => _isLoading = true);

    await _paymentController.getPayments(
      context: context,
      ref: ref,
      libraryId: '6a422593f2ed24f734e41864',
      page: 1,
    );

    if (!mounted) return;

    setState(() {
      _page = 1;
      _isLoading = false;
    });
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    final beforeLength = ref.read(paymentProvider).length;

    await _paymentController.getPayments(
      context: context,
      ref: ref,
      libraryId: '6a422593f2ed24f734e41864',
      page: _page + 1,
    );

    if (!mounted) return;

    final afterLength = ref.read(paymentProvider).length;

    setState(() {
      _isLoadingMore = false;

      if (afterLength == beforeLength) {
        _hasMore = false;
      } else {
        _page++;
      }
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final payments = ref.watch(paymentProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.heading,
        title: const Text(
          'All Transactions',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _getPayments,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : payments.isEmpty
            ? const _EmptyState()
            : ListView.separated(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                itemCount: payments.length + (_isLoadingMore ? 1 : 0),
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, index) {
                  if (index == payments.length) {
                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  return PaymentTile(
                    payment: payments[index],
                    scale: widget.scale,
                  );
                },
              ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 180),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                Icon(
                  Icons.receipt_long_rounded,
                  size: 72,
                  color: AppColors.caption,
                ),
                const SizedBox(height: 20),
                Text(
                  'No Transactions Found',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.heading,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'All payment transactions will appear here.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.caption,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
