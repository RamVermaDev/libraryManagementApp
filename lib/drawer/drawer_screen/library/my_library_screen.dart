import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/controllers/library_controller.dart';
import 'package:library_management/drawer/drawerWidgets/app_bar_widget.dart';
import 'package:library_management/drawer/drawer_screen/library/library_summary_card.dart';
import 'package:library_management/provider/library_provider.dart';
import 'package:library_management/screens/library_profile_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    final libraries = ref.watch(libraryProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget(
        title: 'My Libraries',
        onActionPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LibraryProfileScreen()),
          );
        },
      ),
      body: RefreshIndicator(
        onRefresh: _fetchLibraries,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : libraries.isEmpty
            ? ListView(
                padding: const EdgeInsets.all(20),
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
                padding: const EdgeInsets.all(16),
                itemCount: libraries.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return LibrarySummaryCard(library: libraries[index]);
                },
              ),
      ),
    );
  }
}
