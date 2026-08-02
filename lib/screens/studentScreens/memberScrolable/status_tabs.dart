import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/members.dart';

class StatusTabs extends StatefulWidget {
  final PageController pageController;
  final ValueChanged<MemberStatus> onChanged;

  const StatusTabs({
    super.key,
    required this.pageController,
    required this.onChanged,
  });

  @override
  State<StatusTabs> createState() => _StatusTabsState();
}

class _StatusTabsState extends State<StatusTabs> {
  final ScrollController _tabScrollController = ScrollController();
  final Map<MemberStatus, GlobalKey> _tabKeys = {
    for (final status in MemberStatus.values) status: GlobalKey(),
  };

  @override
  void initState() {
    super.initState();
    widget.pageController.addListener(_onPageScroll);
  }

  @override
  void dispose() {
    widget.pageController.removeListener(_onPageScroll);
    _tabScrollController.dispose();
    super.dispose();
  }

  void _onPageScroll() {
    if (!widget.pageController.hasClients) return;
    final page = widget.pageController.page?.round() ?? 0;
    if (page >= 0 && page < MemberStatus.values.length) {
      _scrollToTab(MemberStatus.values[page]);
    }
  }

  void _scrollToTab(MemberStatus status) {
    final key = _tabKeys[status];
    if (key?.currentContext == null) return;
    Scrollable.ensureVisible(
      key!.currentContext!,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      alignment: 0.5,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: AnimatedBuilder(
        animation: widget.pageController,
        builder: (context, child) {
          final double currentPage = widget.pageController.hasClients
              ? widget.pageController.page ??
                  widget.pageController.initialPage.toDouble()
              : widget.pageController.initialPage.toDouble();

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: _tabScrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: MemberStatus.values.map((status) {
                      final int index = status.index;
                      final double distance =
                          (currentPage - index).abs().clamp(0.0, 1.0);
                      final bool isSelected = distance < 0.5;

                      final Color textColor = Color.lerp(
                        const Color(0xFF64748B),
                        const Color(0xFF1E293B),
                        1 - distance,
                      )!;

                      return Container(
                        key: _tabKeys[status],
                        margin: const EdgeInsets.only(right: 12),
                        child: InkWell(
                          onTap: () {
                            widget.onChanged(status);
                            _scrollToTab(status);
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  status.label,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    color: textColor,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 180),
                                  height: 2.0,
                                  width: isSelected ? 34 : 0,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(99),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const Divider(
                height: 1,
                thickness: 1,
                color: Color(0xFFF1F5F9),
              ),
            ],
          );
        },
      ),
    );
  }
}
