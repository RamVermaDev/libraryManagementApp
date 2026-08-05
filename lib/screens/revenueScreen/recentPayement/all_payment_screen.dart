import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/controllers/payment_controller.dart';
import 'package:library_management/provider/current_library_provider.dart';
import 'package:library_management/provider/payment_provider.dart';
import 'package:library_management/screens/revenueScreen/monthlyPerformance/month_selector.dart';
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

  DateTime _selectedMonth = DateTime.now();
  String _paymentFilter = 'ALL';

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
    final libraryId = ref.read(currentLibraryProvider);
    if (libraryId == null) {
      setState(() => _isLoading = false);
      return;
    }

    setState(() => _isLoading = true);

    await _paymentController.getPayments(
      context: context,
      ref: ref,
      libraryId: libraryId,
      page: 1,
      month: _selectedMonth.month,
      year: _selectedMonth.year,
    );

    if (!mounted) return;

    setState(() {
      _page = 1;
      _isLoading = false;
    });
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore) return;

    final libraryId = ref.read(currentLibraryProvider);
    if (libraryId == null) return;

    setState(() {
      _isLoadingMore = true;
    });

    final beforeLength = ref.read(paymentProvider).length;

    await _paymentController.getPayments(
      context: context,
      ref: ref,
      libraryId: libraryId,
      page: _page + 1,
      month: _selectedMonth.month,
      year: _selectedMonth.year,
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

  void _changeMonth(int delta) {
    final newMonth =
        DateTime(_selectedMonth.year, _selectedMonth.month + delta, 1);
    final now = DateTime.now();
    if (newMonth.isAfter(DateTime(now.year, now.month, 1))) return;
    setState(() {
      _selectedMonth = newMonth;
      _hasMore = true;
    });
    _getPayments();
  }

  bool get _canGoNext {
    final now = DateTime.now();
    return _selectedMonth.year < now.year ||
        (_selectedMonth.year == now.year && _selectedMonth.month < now.month);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<String?>(currentLibraryProvider, (previous, next) {
      if (previous == next || next == null) return;
      _getPayments();
    });

    final allPayments = ref.watch(paymentProvider);

    final filteredPayments = allPayments.where((p) {
      final mode = p.paymentMode.toLowerCase().trim();
      if (_paymentFilter == 'ONLINE') {
        return mode == 'online' || mode == 'upi';
      } else if (_paymentFilter == 'CASH') {
        return mode == 'cash';
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.heading,
        title: const Text(
          'Payment History',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _getPayments,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PopupMenuButton<String>(
                    onSelected: (val) {
                      setState(() {
                        _paymentFilter = val;
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: 'ALL', child: Text('ALL')),
                      PopupMenuItem(value: 'ONLINE', child: Text('ONLINE')),
                      PopupMenuItem(value: 'CASH', child: Text('CASH')),
                    ],
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _paymentFilter,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.arrow_drop_down_rounded,
                            size: 20,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                  MonthSelector(
                    selectedMonth: _selectedMonth,
                    canGoPrevious: true,
                    canGoNext: _canGoNext,
                    onPrevious: () => _changeMonth(-1),
                    onNext: () => _changeMonth(1),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredPayments.isEmpty
                  ? const _EmptyState()
                  : ListView.separated(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount:
                          filteredPayments.length + (_isLoadingMore ? 1 : 0),
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, index) {
                        if (index == filteredPayments.length) {
                          return const Padding(
                            padding: EdgeInsets.all(20),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        return PaymentTile(
                          payment: filteredPayments[index],
                          scale: widget.scale,
                        );
                      },
                    ),
            ),
          ],
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
