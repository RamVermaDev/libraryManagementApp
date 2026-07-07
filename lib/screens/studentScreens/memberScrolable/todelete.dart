import 'dart:async';

import 'package:flutter/material.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/empty_state.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/error_state.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/loading_state.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/member_card_style.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/member_color.dart';

/// ===============================================================
/// MEMBER STATUS
/// ===============================================================

enum MemberStatus {
  all,
  active,
  expiring,
  expired,
}

/// ===============================================================
/// MEMBER DAY FILTER
/// ===============================================================

enum MemberDayFilter {
  oneToThree,
  fourToSix,
  sevenToTen,
}

/// ===============================================================
/// EXTENSIONS
/// ===============================================================

extension MemberStatusX on MemberStatus {
  String get label {
    switch (this) {
      case MemberStatus.all:
        return 'All';

      case MemberStatus.active:
        return 'Active';

      case MemberStatus.expiring:
        return 'Expiring';

      case MemberStatus.expired:
        return 'Expired';
    }
  }

  bool get hasDayFilter {
    return this == MemberStatus.expiring ||
        this == MemberStatus.expired;
  }
}

extension MemberDayFilterX on MemberDayFilter {
  String get label {
    switch (this) {
      case MemberDayFilter.oneToThree:
        return '1–3 Days';

      case MemberDayFilter.fourToSix:
        return '4–6 Days';

      case MemberDayFilter.sevenToTen:
        return '7–10 Days';
    }
  }

  int get startDay {
    switch (this) {
      case MemberDayFilter.oneToThree:
        return 1;

      case MemberDayFilter.fourToSix:
        return 4;

      case MemberDayFilter.sevenToTen:
        return 7;
    }
  }

  int get endDay {
    switch (this) {
      case MemberDayFilter.oneToThree:
        return 3;

      case MemberDayFilter.fourToSix:
        return 6;

      case MemberDayFilter.sevenToTen:
        return 10;
    }
  }
}

/// ===============================================================
/// MEMBERS SCREEN ARGUMENTS
///
/// Every dashboard button sends one of these objects.
/// ===============================================================

class MembersScreenArgs {
  final MemberStatus initialStatus;
  final MemberDayFilter? initialDayFilter;

  const MembersScreenArgs({
    required this.initialStatus,
    this.initialDayFilter,
  });

  const MembersScreenArgs.all()
      : initialStatus = MemberStatus.all,
        initialDayFilter = null;

  const MembersScreenArgs.active()
      : initialStatus = MemberStatus.active,
        initialDayFilter = null;

  const MembersScreenArgs.expiring({
    MemberDayFilter filter = MemberDayFilter.oneToThree,
  })  : initialStatus = MemberStatus.expiring,
        initialDayFilter = filter;

  const MembersScreenArgs.expired({
    MemberDayFilter filter = MemberDayFilter.oneToThree,
  })  : initialStatus = MemberStatus.expired,
        initialDayFilter = filter;
}

/// ===============================================================
/// DEMO MEMBER MODEL
///
/// Replace this later with your existing StudentModel.
/// ===============================================================

class MemberListItem {
  final String id;
  final String name;
  final String memberId;
  final String plan;
  final DateTime expiryDate;
  final String? imageUrl;

  const MemberListItem({
    required this.id,
    required this.name,
    required this.memberId,
    required this.plan,
    required this.expiryDate,
    this.imageUrl,
  });
}

/// ===============================================================
/// APP COLORS
/// ===============================================================



/// ===============================================================
/// DASHBOARD EXAMPLE
///
/// This demonstrates your exact 8-button requirement.
///
/// You can copy only the navigation methods into your existing
/// main screen if you already have one.
/// ===============================================================

class MemberDashboardExample extends StatelessWidget {
  const MemberDashboardExample({super.key});

  void _openMembers(
    BuildContext context,
    MembersScreenArgs args,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MembersScreen(
          args: args,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MembersColors.background,
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          /// BUTTON 1
          ElevatedButton(
            onPressed: () {
              _openMembers(
                context,
                const MembersScreenArgs.all(),
              );
            },
            child: const Text('All Members'),
          ),

          const SizedBox(height: 12),

          /// BUTTON 2
          ElevatedButton(
            onPressed: () {
              _openMembers(
                context,
                const MembersScreenArgs.active(),
              );
            },
            child: const Text('Active Members'),
          ),

          const SizedBox(height: 24),

          /// BUTTON 3
          ElevatedButton(
            onPressed: () {
              _openMembers(
                context,
                const MembersScreenArgs.expiring(
                  filter: MemberDayFilter.oneToThree,
                ),
              );
            },
            child: const Text('Expiring 1–3 Days'),
          ),

          const SizedBox(height: 12),

          /// BUTTON 4
          ElevatedButton(
            onPressed: () {
              _openMembers(
                context,
                const MembersScreenArgs.expiring(
                  filter: MemberDayFilter.fourToSix,
                ),
              );
            },
            child: const Text('Expiring 4–6 Days'),
          ),

          const SizedBox(height: 12),

          /// BUTTON 5
          ElevatedButton(
            onPressed: () {
              _openMembers(
                context,
                const MembersScreenArgs.expiring(
                  filter: MemberDayFilter.sevenToTen,
                ),
              );
            },
            child: const Text('Expiring 7–10 Days'),
          ),

          const SizedBox(height: 24),

          /// BUTTON 6
          ElevatedButton(
            onPressed: () {
              _openMembers(
                context,
                const MembersScreenArgs.expired(
                  filter: MemberDayFilter.oneToThree,
                ),
              );
            },
            child: const Text('Expired 1–3 Days'),
          ),

          const SizedBox(height: 12),

          /// BUTTON 7
          ElevatedButton(
            onPressed: () {
              _openMembers(
                context,
                const MembersScreenArgs.expired(
                  filter: MemberDayFilter.fourToSix,
                ),
              );
            },
            child: const Text('Expired 4–6 Days'),
          ),

          const SizedBox(height: 12),

          /// BUTTON 8
          ElevatedButton(
            onPressed: () {
              _openMembers(
                context,
                const MembersScreenArgs.expired(
                  filter: MemberDayFilter.sevenToTen,
                ),
              );
            },
            child: const Text('Expired 7–10 Days'),
          ),
        ],
      ),
    );
  }
}

/// ===============================================================
/// MEMBERS SCREEN
/// ===============================================================

class MembersScreen extends StatefulWidget {
  final MembersScreenArgs args;

  const MembersScreen({
    super.key,
    required this.args,
  });

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  /// Search controller
  final TextEditingController _searchController =
      TextEditingController();

  /// Search debounce
  Timer? _searchDebounce;

  /// Currently selected main status tab
  late MemberStatus _selectedStatus;

  /// Currently selected day filter
  MemberDayFilter _selectedDayFilter =
      MemberDayFilter.oneToThree;

  /// Screen state
  bool _isLoading = false;
  String? _errorMessage;

  /// Replace this with List<StudentModel>
  final List<MemberListItem> _members = [];

  @override
  void initState() {
    super.initState();

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
          widget.args.initialDayFilter ??
          MemberDayFilter.oneToThree;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchMembers();
    });
  }

  /// =============================================================
  /// MAIN FETCH DECISION FUNCTION
  ///
  /// This decides which API function should run.
  ///
  /// You will add your actual API calls inside the TODO methods.
  /// =============================================================

  Future<void> _fetchMembers() async {
    switch (_selectedStatus) {
      case MemberStatus.all:
        await _fetchAllMembers();
        break;

      case MemberStatus.active:
        await _fetchActiveMembers();
        break;

      case MemberStatus.expiring:
        await _fetchExpiringMembers(
          filter: _selectedDayFilter,
        );
        break;

      case MemberStatus.expired:
        await _fetchExpiredMembers(
          filter: _selectedDayFilter,
        );
        break;
    }
  }

  /// =============================================================
  /// FETCH ALL MEMBERS
  /// =============================================================

  Future<void> _fetchAllMembers() async {
    _startLoading();

    try {
      // TODO: Call your API/controller to fetch ALL members.
      //
      // Example:
      //
      // final result = await studentController.getAllStudents();
      //
      // if (!mounted) return;
      //
      // setState(() {
      //   _members
      //     ..clear()
      //     ..addAll(result);
      // });

      await Future<void>.delayed(
        const Duration(milliseconds: 300),
      );
    } catch (error) {
      _handleError(error);
    } finally {
      _stopLoading();
    }
  }

  /// =============================================================
  /// FETCH ACTIVE MEMBERS
  /// =============================================================

  Future<void> _fetchActiveMembers() async {
    _startLoading();

    try {
      // TODO: Call your API/controller to fetch ACTIVE members.

      await Future<void>.delayed(
        const Duration(milliseconds: 300),
      );
    } catch (error) {
      _handleError(error);
    } finally {
      _stopLoading();
    }
  }

  /// =============================================================
  /// FETCH EXPIRING MEMBERS
  /// =============================================================

  Future<void> _fetchExpiringMembers({
    required MemberDayFilter filter,
  }) async {
    _startLoading();

    try {
      final int startDay = filter.startDay;
      final int endDay = filter.endDay;

      // TODO: Call your API/controller to fetch EXPIRING members.
      //
      // Send:
      // status   = expiring
      // startDay = startDay
      // endDay   = endDay
      //
      // Example:
      //
      // await studentController.getExpiringStudents(
      //   startDay: startDay,
      //   endDay: endDay,
      // );

      debugPrint(
        'Fetch EXPIRING: $startDay to $endDay days',
      );

      await Future<void>.delayed(
        const Duration(milliseconds: 300),
      );
    } catch (error) {
      _handleError(error);
    } finally {
      _stopLoading();
    }
  }

  /// =============================================================
  /// FETCH EXPIRED MEMBERS
  /// =============================================================

  Future<void> _fetchExpiredMembers({
    required MemberDayFilter filter,
  }) async {
    _startLoading();

    try {
      final int startDay = filter.startDay;
      final int endDay = filter.endDay;

      // TODO: Call your API/controller to fetch EXPIRED members.
      //
      // Send:
      // status   = expired
      // startDay = startDay
      // endDay   = endDay

      debugPrint(
        'Fetch EXPIRED: $startDay to $endDay days',
      );

      await Future<void>.delayed(
        const Duration(milliseconds: 300),
      );
    } catch (error) {
      _handleError(error);
    } finally {
      _stopLoading();
    }
  }

  /// =============================================================
  /// MAIN STATUS TAB CHANGE
  /// =============================================================

  Future<void> _onStatusChanged(
    MemberStatus status,
  ) async {
    if (_selectedStatus == status) return;

    setState(() {
      _selectedStatus = status;

      /// Whenever Expiring or Expired is selected manually,
      /// default filter must be 1–3 days.
      if (status.hasDayFilter) {
        _selectedDayFilter =
            MemberDayFilter.oneToThree;
      }
    });

    await _fetchMembers();
  }

  /// =============================================================
  /// DAY FILTER CHANGE
  /// =============================================================

  Future<void> _onDayFilterChanged(
    MemberDayFilter filter,
  ) async {
    if (_selectedDayFilter == filter) return;

    setState(() {
      _selectedDayFilter = filter;
    });

    await _fetchMembers();
  }

  /// =============================================================
  /// SEARCH
  /// =============================================================

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();

    _searchDebounce = Timer(
      const Duration(milliseconds: 450),
      () {
        _searchMembers(value.trim());
      },
    );
  }

  Future<void> _searchMembers(String query) async {
    if (query.isEmpty) {
      await _fetchMembers();
      return;
    }

    // TODO: Call your member search API.
    //
    // Keep the current status/filter if your backend supports it.
    //
    // Example:
    //
    // search: query
    // status: _selectedStatus
    // startDay/endDay: only for Expiring and Expired

    debugPrint('Search member: $query');
  }

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

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MembersColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const _MembersAppBar(),

            _SearchField(
              controller: _searchController,
              onChanged: _onSearchChanged,
            ),

            const SizedBox(height: 18),

            _StatusTabs(
              selectedStatus: _selectedStatus,
              onChanged: _onStatusChanged,
            ),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              child: _selectedStatus.hasDayFilter
                  ? _DayFilterSection(
                      key: ValueKey(_selectedStatus),
                      selectedFilter: _selectedDayFilter,
                      onChanged: _onDayFilterChanged,
                    )
                  : const SizedBox(
                      key: ValueKey('no-filter'),
                      height: 18,
                    ),
            ),

            Expanded(
              child: _MembersBody(
                isLoading: _isLoading,
                errorMessage: _errorMessage,
                members: _members,
                selectedStatus: _selectedStatus,
                onRefresh: _onRefresh,
                onRetry: _fetchMembers,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ===============================================================
/// CUSTOM APP BAR
/// ===============================================================

class _MembersAppBar extends StatelessWidget {
  const _MembersAppBar();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 68,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            _CircularIconButton(
              icon: Icons.arrow_back_rounded,
              onTap: () {
                Navigator.maybePop(context);
              },
            ),

            const Expanded(
              child: Text(
                'Members',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: MembersColors.heading,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.4,
                ),
              ),
            ),

            _CircularIconButton(
              icon: Icons.tune_rounded,
              onTap: () {
                // TODO: Open advanced filter bottom sheet.
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// ===============================================================
/// CIRCULAR ICON BUTTON
/// ===============================================================

class _CircularIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircularIconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: MembersColors.surface,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(
            icon,
            size: 22,
            color: MembersColors.heading,
          ),
        ),
      ),
    );
  }
}

/// ===============================================================
/// SEARCH FIELD
/// ===============================================================

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _SearchField({
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Search member',
          hintStyle: const TextStyle(
            color: MembersColors.muted,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: MembersColors.muted,
          ),
          filled: true,
          fillColor: MembersColors.surface,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
          ),
          border: _border(),
          enabledBorder: _border(),
          focusedBorder: _border(
            color: MembersColors.primary,
          ),
        ),
      ),
    );
  }

  OutlineInputBorder _border({
    Color color = MembersColors.border,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(
        color: color,
        width: 1,
      ),
    );
  }
}

/// ===============================================================
/// STATUS TABS
/// ===============================================================

class _StatusTabs extends StatelessWidget {
  final MemberStatus selectedStatus;
  final ValueChanged<MemberStatus> onChanged;

  const _StatusTabs({
    required this.selectedStatus,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        itemCount: MemberStatus.values.length,
        separatorBuilder: (_, __) {
          return const SizedBox(width: 8);
        },
        itemBuilder: (context, index) {
          final status = MemberStatus.values[index];

          return _StatusTab(
            status: status,
            isSelected: selectedStatus == status,
            onTap: () {
              onChanged(status);
            },
          );
        },
      ),
    );
  }
}

/// ===============================================================
/// SINGLE STATUS TAB
/// ===============================================================

class _StatusTab extends StatelessWidget {
  final MemberStatus status;
  final bool isSelected;
  final VoidCallback onTap;

  const _StatusTab({
    required this.status,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected
          ? MembersColors.primary
          : MembersColors.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? MembersColors.primary
                  : MembersColors.border,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            status.label,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : MembersColors.body,
              fontSize: 14,
              fontWeight: isSelected
                  ? FontWeight.w600
                  : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

/// ===============================================================
/// DAY FILTER SECTION
/// ===============================================================

class _DayFilterSection extends StatelessWidget {
  final MemberDayFilter selectedFilter;
  final ValueChanged<MemberDayFilter> onChanged;

  const _DayFilterSection({
    super.key,
    required this.selectedFilter,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
      child: Container(
        height: 46,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFFEEF1F6),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: MemberDayFilter.values.map((filter) {
            return Expanded(
              child: _DayFilterButton(
                filter: filter,
                isSelected: selectedFilter == filter,
                onTap: () {
                  onChanged(filter);
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// ===============================================================
/// SINGLE DAY FILTER BUTTON
/// ===============================================================

class _DayFilterButton extends StatelessWidget {
  final MemberDayFilter filter;
  final bool isSelected;
  final VoidCallback onTap;

  const _DayFilterButton({
    required this.filter,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected
          ? MembersColors.surface
          : Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? const [
                    BoxShadow(
                      color: Color(0x0F101828),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            filter.label,
            style: TextStyle(
              color: isSelected
                  ? MembersColors.heading
                  : MembersColors.body,
              fontSize: 13,
              fontWeight: isSelected
                  ? FontWeight.w600
                  : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

/// ===============================================================
/// MEMBERS BODY
/// ===============================================================

class _MembersBody extends StatelessWidget {
  final bool isLoading;
  final String? errorMessage;
  final List<MemberListItem> members;
  final MemberStatus selectedStatus;
  final Future<void> Function() onRefresh;
  final VoidCallback onRetry;

  const _MembersBody({
    required this.isLoading,
    required this.errorMessage,
    required this.members,
    required this.selectedStatus,
    required this.onRefresh,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && members.isEmpty) {
      return const LoadingState();
    }

    if (errorMessage != null && members.isEmpty) {
      return ErrorState(
        onRetry: onRetry,
      );
    }

    if (members.isEmpty) {
      return EmptyState(
        status: selectedStatus,
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: MembersColors.primary,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 2, 18, 30),
        itemCount: members.length,
        separatorBuilder: (_, __) {
          return const SizedBox(height: 12);
        },
        itemBuilder: (context, index) {
          return _MemberCard(
            member: members[index],
            status: selectedStatus,
            onTap: () {
              // TODO: Open student detail screen.
            },
            onCall: () {
              // TODO: Call member.
            },
            onMessage: () {
              // TODO: Message member.
            },
          );
        },
      ),
    );
  }
}

/// ===============================================================
/// MEMBER CARD
/// ===============================================================

class _MemberCard extends StatelessWidget {
  final MemberListItem member;
  final MemberStatus status;
  final VoidCallback onTap;
  final VoidCallback onCall;
  final VoidCallback onMessage;

  const _MemberCard({
    required this.member,
    required this.status,
    required this.onTap,
    required this.onCall,
    required this.onMessage,
  });

  @override
  Widget build(BuildContext context) {
    final style = MemberCardStyle.fromStatus(status);

    return Material(
      color: style.background,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: style.border,
            ),
          ),
          child: Row(
            children: [
              _MemberAvatar(
                name: member.name,
                imageUrl: member.imageUrl,
                backgroundColor: style.avatarBackground,
              ),

              const SizedBox(width: 14),

              // Expanded(
              //   child: MemberInformation(
              //     member: member,
              //     statusColor: style.accent,
              //   ),
              // ),

              const SizedBox(width: 8),

              _MemberActions(
                onCall: onCall,
                onMessage: onMessage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ===============================================================
/// MEMBER AVATAR
/// ===============================================================

class _MemberAvatar extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final Color backgroundColor;

  const _MemberAvatar({
    required this.name,
    required this.imageUrl,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 27,
      backgroundColor: backgroundColor,
      child: Text(
        _initials(name),
        style: const TextStyle(
          color: MembersColors.primary,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  String _initials(String value) {
    final words = value.trim().split(RegExp(r'\s+'));

    if (words.isEmpty || words.first.isEmpty) {
      return '?';
    }

    if (words.length == 1) {
      return words.first[0].toUpperCase();
    }

    return '${words.first[0]}${words.last[0]}'
        .toUpperCase();
  }
}

/// ===============================================================
/// MEMBER INFORMATION
/// ===============================================================



  

/// ===============================================================
/// MEMBER ACTIONS
/// ===============================================================



/// ===============================================================
/// SMALL ACTION BUTTON
/// ===============================================================



/// ===============================================================
/// MEMBER CARD STYLE
/// ===============================================================



/// ===============================================================
/// LOADING STATE
/// ===============================================================



/// ===============================================================
/// EMPTY STATE
/// ===============================================================



/// ===============================================================
/// ERROR STATE
/// ===============================================================

