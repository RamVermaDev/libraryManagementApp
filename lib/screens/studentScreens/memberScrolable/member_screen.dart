import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/controllers/student_controller.dart';
import 'package:library_management/models/student_model.dart';
import 'package:library_management/provider/current_library_provider.dart';
import 'package:library_management/provider/student_provider.dart';
import 'package:library_management/provider/student_state.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/day_filter_section.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/search_field.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/members_body.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/members.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/members_screen_args.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/status_tabs.dart';

class MembersScreen extends ConsumerStatefulWidget {
  final MembersScreenArgs args;
  final String appBarTitle;

  const MembersScreen({
    super.key,
    required this.args,
    required this.appBarTitle,
  });

  @override
  ConsumerState<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends ConsumerState<MembersScreen> {
  static const int _membersLimit = 6;

  /// Controls horizontal swipe between member statuses
  late final PageController _pageController;

  /// Controls vertical member list scrolling for each page
  late final Map<MemberStatus, ScrollController> _scrollControllers;

  /// Search controller
  final TextEditingController _searchController = TextEditingController();

  /// Search debounce
  Timer? _searchDebounce;

  /// Currently selected main status tab
  late MemberStatus _selectedStatus;

  /// Currently selected day filter
  MemberDayFilter _selectedDayFilter = MemberDayFilter.oneToThree;

  /// Global search state
  List<StudentModel>? _globalSearchResults;
  bool _isGlobalSearching = false;

  /// Screen state
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMoreMembers = true;
  int _currentPage = 1;
  String? _errorMessage;

  final _studentController = StudentController();

  @override
  void initState() {
    super.initState();

    _scrollControllers = {
      for (final status in MemberStatus.values) status: ScrollController(),
    };

    for (final entry in _scrollControllers.entries) {
      entry.value.addListener(() {
        _onMemberListScrolled(entry.key);
      });
    }

    _initializeScreen();
  }

  /// =============================================================
  /// INITIALIZE SCREEN
  ///
  /// Receives the selected status/filter from dashboard.
  /// =============================================================

  void _initializeScreen() {
    _selectedStatus = widget.args.initialStatus;

    if (_selectedStatus.hasDayFilter) {
      _selectedDayFilter =
          widget.args.initialDayFilter ?? MemberDayFilter.oneToThree;
    }

    _pageController = PageController(initialPage: _selectedStatus.index);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchMembers();
    });
  }

  Future<void> _fetchMembers() async {
    final libraryId = ref.read(currentLibraryProvider);
    if (libraryId == null) return;

    _currentPage = 1;
    _hasMoreMembers = true;
    _startLoading();

    try {
      final hasMore = await _studentController.getStudents(
        ref: ref,
        libraryId: libraryId,
        status: _selectedStatus,
        page: _currentPage,
        limit: _membersLimit,
        dayFilter: _selectedDayFilter,
        // startDay: _selectedStatus.hasDayFilter
        //     ? _selectedDayFilter.startDay
        //     : null,
        // endDay: _selectedStatus.hasDayFilter ? _selectedDayFilter.endDay : null,
      );

      _hasMoreMembers = hasMore;
    } catch (error) {
      _handleError(error);
    } finally {
      _stopLoading();
    }
  }

  void _onMemberListScrolled(MemberStatus status) {
    if (status != _selectedStatus) return;

    final scrollController = _scrollControllers[status];
    if (scrollController == null || !scrollController.hasClients) return;

    final position = scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 160) {
      _fetchMoreMembers();
    }
  }

  Future<void> _fetchMoreMembers() async {
    if (_isLoading || _isLoadingMore || !_hasMoreMembers) return;

    final libraryId = ref.read(currentLibraryProvider);
    if (libraryId == null) return;

    setState(() {
      _isLoadingMore = true;
      _errorMessage = null;
    });

    try {
      final nextPage = _currentPage + 1;
      final hasMore = await _studentController.getStudents(
        ref: ref,
        libraryId: libraryId,
        status: _selectedStatus,
        page: nextPage,
        limit: _membersLimit,
        append: true,
        dayFilter: _selectedDayFilter,
      );

      _currentPage = nextPage;
      _hasMoreMembers = hasMore;
    } catch (error) {
      _handleError(error);
    } finally {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  /// MAIN STATUS TAB CHANGE

  void _onStatusChanged(MemberStatus status) {
    if (_selectedStatus == status) return;

    _pageController.animateToPage(
      status.index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _onPageChanged(int index) async {
    final status = MemberStatus.values[index];

    if (_selectedStatus == status) return;

    setState(() {
      _selectedStatus = status;

      if (status.hasDayFilter) {
        _selectedDayFilter = MemberDayFilter.oneToThree;
      }
    });

    await _fetchMembers();
  }

  /// =============================================================
  /// DAY FILTER CHANGE
  /// =============================================================

  Future<void> _onDayFilterChanged(MemberDayFilter filter) async {
    if (_selectedDayFilter == filter) return;

    setState(() {
      _selectedDayFilter = filter;
    });

    await _fetchMembers();
  }

  /// =============================================================
  /// SEARCH
  /// =============================================================

  // void _onSearchChanged(String value) {
  //   _searchDebounce?.cancel();

  //   _searchDebounce = Timer(const Duration(milliseconds: 450), () {
  //     _searchMembers(value.trim());
  //   });
  // }

  // Future<void> _searchMembers(String query) async {
  //   if (query.isEmpty) {
  //     await _fetchMembers();
  //     return;
  //   }

  //   // TODO: Call your member search API.
  //   //
  //   // Keep the current status/filter if your backend supports it.
  //   //
  //   // Example:
  //   //
  //   // search: query
  //   // status: _selectedStatus
  //   // startDay/endDay: only for Expiring and Expired

  //   debugPrint('Search member: $query');
  // }

  /// =============================================================
  /// REFRESH
  /// =============================================================

  Future<void> _onRefresh() async {
    await _fetchMembers();
  }

  /// =============================================================
  /// LOADING HELPERS
  /// =============================================================

  void _startLoading() {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
  }

  void _stopLoading() {
    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });
  }

  void _handleError(Object error) {
    if (!mounted) return;

    setState(() {
      _errorMessage = error.toString();
    });
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    for (final scrollController in _scrollControllers.values) {
      scrollController.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  List<StudentModel> getMembersByStatus(
    StudentState studentState,
    MemberStatus memberStatus,
    MemberDayFilter? dayFilter,
  ) {
    switch (memberStatus) {
      case MemberStatus.all:
        return studentState.allStudents;

      case MemberStatus.active:
        return studentState.activeStudents;

      case MemberStatus.pending:
        return studentState.pendingStudents;

      case MemberStatus.expiring:
        return switch (dayFilter) {
          MemberDayFilter.oneToThree => studentState.expiring1To3Days,
          MemberDayFilter.fourToSix => studentState.expiring4To7Days,
          MemberDayFilter.sevenToTen => studentState.expiring8To10Days,
          null => [],
        };

      case MemberStatus.expired:
        return switch (dayFilter) {
          MemberDayFilter.oneToThree => studentState.expired1To3Days,
          MemberDayFilter.fourToSix => studentState.expired4To7Days,
          MemberDayFilter.sevenToTen => studentState.expired8To10Days,
          null => [],
        };
    }
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();

    final query = value.trim();
    if (query.isEmpty) {
      if (mounted) {
        setState(() {
          _globalSearchResults = null;
          _isGlobalSearching = false;
        });
      }
      return;
    }

    _searchDebounce = Timer(const Duration(milliseconds: 300), () async {
      final libraryId = ref.read(currentLibraryProvider);
      if (libraryId == null) return;

      if (mounted) setState(() => _isGlobalSearching = true);

      final results = await _studentController.searchLibraryStudents(
        ref: ref,
        libraryId: libraryId,
        query: query,
      );

      if (mounted) {
        setState(() {
          _globalSearchResults = results;
          _isGlobalSearching = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<String?>(currentLibraryProvider, (previous, next) {
      if (previous == next || next == null) return;
      _fetchMembers();
    });

    final studentState = ref.watch(studentProvider);
    final isSearching = _searchController.text.trim().isNotEmpty;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleSpacing: 0,
          title: SearchField(
            controller: _searchController,
            hintText: 'Search name/phone',
            onChanged: _onSearchChanged,
            onClear: () {
              _searchController.clear();
              _onSearchChanged('');
            },
          ),
        ),
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              // Smooth status tabs collapse animation when searching
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, animation) => SizeTransition(
                  sizeFactor: animation,
                  axisAlignment: -1.0,
                  child: child,
                ),
                child: isSearching
                    ? const SizedBox(
                        key: ValueKey('searching-tabs-hidden'),
                        height: 14,
                      )
                    : Column(
                        key: const ValueKey('normal-tabs-visible'),
                        children: [
                          const SizedBox(height: 4),
                          StatusTabs(
                            pageController: _pageController,
                            onChanged: _onStatusChanged,
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 220),
                            switchInCurve: Curves.easeOut,
                            switchOutCurve: Curves.easeIn,
                            child: _selectedStatus.hasDayFilter
                                ? DayFilterSection(
                                    key: ValueKey(_selectedStatus),
                                    selectedFilter: _selectedDayFilter,
                                    onChanged: _onDayFilterChanged,
                                  )
                                : const SizedBox(
                                    key: ValueKey('no-filter'),
                                    height: 18,
                                  ),
                          ),
                        ],
                      ),
              ),

              Expanded(
                child: isSearching
                    ? MembersBody(
                        members: _globalSearchResults ?? [],
                        isLoading: _isGlobalSearching,
                        isLoadingMore: false,
                        errorMessage: _errorMessage,
                        selectedStatus: MemberStatus.all,
                        scrollController: ScrollController(),
                        onRefresh: () async {
                          _onSearchChanged(_searchController.text);
                        },
                        onRetry: () {
                          _onSearchChanged(_searchController.text);
                        },
                        isSearching: true,
                      )
                    : PageView.builder(
                        controller: _pageController,
                        itemCount: MemberStatus.values.length,
                        onPageChanged: _onPageChanged,
                        itemBuilder: (context, index) {
                          final pageStatus = MemberStatus.values[index];
                          final pageMembers = getMembersByStatus(
                            studentState,
                            pageStatus,
                            _selectedDayFilter,
                          );

                          return MembersBody(
                            members: pageMembers,
                            isLoading: _isLoading,
                            isLoadingMore:
                                _isLoadingMore && pageStatus == _selectedStatus,
                            errorMessage: _errorMessage,
                            selectedStatus: pageStatus,
                            scrollController: _scrollControllers[pageStatus]!,
                            onRefresh: _onRefresh,
                            onRetry: _fetchMembers,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
