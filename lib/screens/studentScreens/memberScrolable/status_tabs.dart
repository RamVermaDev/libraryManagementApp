import 'package:flutter/material.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/members.dart';

class StatusTabs extends StatelessWidget {
  final PageController pageController;
  final ValueChanged<MemberStatus> onChanged;

  const StatusTabs({
    super.key,
    required this.pageController,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58,
      child: AnimatedBuilder(
        animation: pageController,
        builder: (context, child) {
          final double currentPage = pageController.hasClients
              ? pageController.page ?? pageController.initialPage.toDouble()
              : pageController.initialPage.toDouble();

          return LayoutBuilder(
            builder: (context, constraints) {
              final double tabWidth =
                  constraints.maxWidth / MemberStatus.values.length;

              return Stack(
                children: [
                  // 1. TAB LABELS
                  Row(
                    children: MemberStatus.values.map((status) {
                      final int index = status.index;

                      // Distance of this tab from current page.
                      final double distance = (currentPage - index).abs().clamp(
                        0.0,
                        1.0,
                      );

                      // Smooth text color during swipe.
                      final Color textColor = Color.lerp(
                        const Color(0xFF6B6B6B),
                        const Color(0xFF171717),
                        1 - distance,
                      )!;

                      return Expanded(
                        child: InkWell(
                          onTap: () {
                            onChanged(status);
                          },
                          child: Center(
                            child: Text(
                              status.label,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.lerp(
                                  FontWeight.w400,
                                  FontWeight.w600,
                                  1 - distance,
                                ),
                                color: textColor,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  // 2. BOTTOM BORDER
                  const Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFE5E7EB),
                    ),
                  ),

                  // 3. ANIMATED INDICATOR
                  Positioned(
                    left: currentPage * tabWidth,
                    bottom: 0,
                    width: tabWidth,
                    child: const _TabIndicator(),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _TabIndicator extends StatelessWidget {
  const _TabIndicator();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: FractionallySizedBox(
        widthFactor: 0.72,
        child: Container(
          height: 3,
          decoration: BoxDecoration(
            color: const Color(0xFF91AA9D),
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ),
    );
  }
}
