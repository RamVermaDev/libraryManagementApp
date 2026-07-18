import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/context_extension.dart';
import 'package:library_management/controllers/library_controller.dart';
import 'package:library_management/drawer/drawerWidgets/app_bar_widget.dart';
import 'package:library_management/drawer/drawer_screen/library/library_setup_screen.dart';
import 'package:library_management/drawer/drawer_screen/library/library_summary_card.dart';
import 'package:library_management/local_storage.dart';
import 'package:library_management/provider/current_library_provider.dart';
import 'package:library_management/provider/expense_provider.dart';
import 'package:library_management/provider/library_provider.dart';
import 'package:library_management/provider/payment_provider.dart';
import 'package:library_management/provider/revenue_provider.dart';
import 'package:library_management/provider/student_provider.dart';
import 'package:library_management/provider/student_summary_provider.dart';
import 'package:library_management/provider/task_provider.dart';

class MyLibraryScreen extends ConsumerStatefulWidget {
  const MyLibraryScreen({super.key});

  @override
  ConsumerState<MyLibraryScreen> createState() => _MyLibraryScreenState();
}

class _MyLibraryScreenState extends ConsumerState<MyLibraryScreen> {
  final LibraryController _libraryController = LibraryController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _fetchLibraries();
    });
  }

  Future<void> _fetchLibraries() async {
    setState(() {
      _isLoading = true;
    });

    await _libraryController.fetchOwnerLibraries(context: context, ref: ref);

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });
  }

  void _clearLibraryScopedProviders() {
    ref.read(studentProvider.notifier).clearStudents();
    ref.read(studentSummaryProvider.notifier).clearSummary();
    ref.read(taskProvider.notifier).clearTasks();
    ref.read(revenueProvider.notifier).clear();
    ref.read(paymentProvider.notifier).clearPayments();
    ref.read(expenseProvider.notifier).clearExpenses();
  }

  @override
  Widget build(BuildContext context) {
    final libraries = ref.watch(libraryProvider);
    final currentLibrary = ref.watch(currentLibraryProvider);
    final double scale = context.scale;
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet<bool>(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            backgroundColor: Colors.transparent,
            builder: (_) => const LibrarySetupScreen(),
          ).then((saved) {
            if (saved == true) {
              _fetchLibraries();
            }
          });
        },
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 6,
        // shape: const CircleBorder(),
        // child: const Icon(Icons.add_rounded, size: 30),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        icon: const Icon(Icons.add_rounded, size: 18),
        label: const Text(
          'Library',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ),
      backgroundColor: AppColors.background,
      appBar: AppBarWidget(title: 'My Libraries'),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _fetchLibraries,
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : libraries.isEmpty
              ? ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                  children: const [
                    SizedBox(height: 180),
                    Icon(
                      Icons.local_library_outlined,
                      size: 56,
                      color: AppColors.caption,
                    ),
                    SizedBox(height: 12),
                    Center(
                      child: Text(
                        'No libraries found',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.heading,
                        ),
                      ),
                    ),
                  ],
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  itemCount: libraries.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 2),
                  itemBuilder: (context, index) {
                    final library = libraries[index];
                    return LibrarySummaryCard(
                      scale: scale,
                      library: library,
                      isCurrent: currentLibrary == library.id ? true : false,
                      onActiveChanged: (value) async {
                        if (!value || currentLibrary == library.id) return;

                        // Save locally
                        await LocalStorage.saveCurrentLibrary(
                          libraryId: library.id!,
                        );

                        _clearLibraryScopedProviders();

                        // Update Riverpod state after clearing cached data so
                        // active screens can fetch for the new library.
                        ref
                            .read(currentLibraryProvider.notifier)
                            .setLibrary(library.id);
                      },
                      onEdit: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                LibrarySetupScreen(library: library),
                          ),
                        ).then((_) => _fetchLibraries());
                      },
                    );
                  },
                ),
        ),
      ),
    );
  }
}
