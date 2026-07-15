import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:library_management/app_colors.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        height: 75,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .05),
              blurRadius: 30,
              spreadRadius: 1,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildItem(
              index: 0,
              label: "Students",
              icon: Icons.groups_outlined,
              activeIcon: Icons.groups_rounded,
            ),
            _buildItem(
              index: 1,
              label: "Tasks",
              icon: Icons.task_alt_outlined,
              activeIcon: Icons.task_alt_rounded,
            ),
            _buildItem(
              index: 2,
              label: "Revenue",
              icon: Icons.account_balance_wallet_outlined,
              activeIcon: Icons.account_balance_wallet_rounded,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem({
    required int index,
    required String label,
    required IconData icon,
    required IconData activeIcon,
  }) {
    final selected = index == currentIndex;

    return Expanded(
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap(index);
        },
        borderRadius: BorderRadius.circular(20),
        splashFactory: NoSplash.splashFactory,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// Lift Animation
              AnimatedSlide(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                offset: selected ? const Offset(0, -0.06) : Offset.zero,
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutBack,
                  scale: selected ? 1.05 : 1,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(
                          scale: Tween<double>(
                            begin: .85,
                            end: 1,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: Icon(
                      selected ? activeIcon : icon,
                      key: ValueKey(selected),
                      size: selected ? 24 : 20,
                      color: selected
                          ? AppColors.primary
                          : Colors.grey.shade600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 6),

              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                style: TextStyle(
                  fontSize: selected ? 14 : 13,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected ? AppColors.primary : Colors.grey.shade600,
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
