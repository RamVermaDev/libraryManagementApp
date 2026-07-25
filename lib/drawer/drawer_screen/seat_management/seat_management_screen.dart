import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/controllers/seat_config_controller.dart';
import 'package:library_management/drawer/drawerWidgets/app_bar_widget.dart';
import 'package:library_management/drawer/drawer_screen/seat_management/decrease_seat_dialog.dart';
import 'package:library_management/drawer/drawer_screen/seat_management/seat_grid_preview.dart';
import 'package:library_management/drawer/drawer_screen/seat_management/seat_layout_controls.dart';
import 'package:library_management/drawer/drawer_screen/seat_management/seat_stats_overview.dart';
import 'package:library_management/provider/current_library_provider.dart';
import 'package:library_management/provider/seat_config_provider.dart';

class SeatManagementScreen extends ConsumerStatefulWidget {
  const SeatManagementScreen({super.key});

  @override
  ConsumerState<SeatManagementScreen> createState() =>
      _SeatManagementScreenState();
}

class _SeatManagementScreenState extends ConsumerState<SeatManagementScreen> {
  final _controller = SeatConfigController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadData());
  }

  Future<void> _loadData() async {
    final libraryId = ref.read(currentLibraryProvider);
    if (libraryId == null || libraryId.isEmpty) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    setState(() => _isLoading = true);
    await _controller.fetchSeatConfig(
      context: context,
      ref: ref,
      libraryId: libraryId,
    );

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleSaveConfig({
    required int totalSeats,
    required int rows,
    required int columns,
    String? prefix,
  }) async {
    final libraryId = ref.read(currentLibraryProvider);
    if (libraryId == null || libraryId.isEmpty) return;

    final currentConfig = ref.read(seatConfigProvider);
    final currentTotal = currentConfig?.totalSeats ?? 0;

    // Warning confirmation if decreasing seats
    if (currentTotal > 0 && totalSeats < currentTotal) {
      final confirmed = await DecreaseSeatDialog.showConfirmation(
        context: context,
        currentTotal: currentTotal,
        newTotal: totalSeats,
      );

      if (!mounted || confirmed != true) return;
    }

    final result = await _controller.updateSeatConfig(
      context: context,
      ref: ref,
      libraryId: libraryId,
      totalSeats: totalSeats,
      rows: rows,
      columns: columns,
      prefix: prefix,
    );

    if (!mounted) return;

    if (result.conflict) {
      DecreaseSeatDialog.showConflictAlert(
        context: context,
        message: result.message,
        affectedBookings: result.affectedBookings,
      );
    } else {
      // Dismiss bottom sheet if open
      Navigator.of(context).maybePop();
    }
  }

  void _openManageSeatsModal() {
    final config = ref.read(seatConfigProvider);
    if (config == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SeatLayoutControls(
                  initialConfig: config,
                  onSave: _handleSaveConfig,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(seatConfigProvider);

    return Scaffold(
      appBar: const AppBarWidget(title: 'Seat Management'),
      backgroundColor: AppColors.background,
      body: _isLoading
          ? const Center(
              child: SpinKitThreeBounce(color: AppColors.primary, size: 24),
            )
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (config != null) ...[
                      // Total Seats Overview Hero Card
                      SeatStatsOverview(config: config),
                      const SizedBox(height: 16),

                      // Action bar: Manage Seats Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Seat Grid',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: AppColors.heading,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: _openManageSeatsModal,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.primary,
                              elevation: 0,
                              side: BorderSide(
                                color: AppColors.primary.withValues(alpha: 0.3),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.tune_rounded, size: 18),
                            label: const Text(
                              'Manage Seats',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Seat Grid View (Primary display)
                      SeatGridPreview(config: config),
                    ] else ...[
                      const SizedBox(
                        height: 200,
                        child: Center(
                          child: Text('Unable to load seat configuration'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
    );
  }
}
