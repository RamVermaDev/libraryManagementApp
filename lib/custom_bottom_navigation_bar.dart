import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/app_notification.dart';
import 'package:library_management/provider/app_mode_provider.dart';

class CustomBottomNavigationBar extends ConsumerWidget {
  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appMode = ref.watch(appModeProvider);
    final isGeneralMode = appMode == AppMode.general;

    return SafeArea(
      top: false,
      child: Container(
        height: 75,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
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
              context: context,
              index: 0,
              label: "Students",
              icon: Icons.groups_outlined,
              activeIcon: Icons.groups_rounded,
              isLocked: false,
            ),
            _buildItem(
              context: context,
              index: 1,
              label: "Tasks",
              icon: Icons.task_alt_outlined,
              activeIcon: Icons.task_alt_rounded,
              isLocked: isGeneralMode,
            ),
            _buildItem(
              context: context,
              index: 2,
              label: "Revenue",
              icon: Icons.account_balance_wallet_outlined,
              activeIcon: Icons.account_balance_wallet_rounded,
              isLocked: isGeneralMode,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem({
    required BuildContext context,
    required int index,
    required String label,
    required IconData icon,
    required IconData activeIcon,
    required bool isLocked,
  }) {
    final selected = index == currentIndex;

    return Expanded(
      child: InkWell(
        onTap: () {
          if (isLocked) {
            HapticFeedback.vibrate();
            AppNotification.show(
              context,
              message: '$label is locked in General mode',
            );
            return;
          }
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
                      color: isLocked
                          ? Colors.grey.shade400
                          : (selected ? AppColors.primary : Colors.grey.shade600),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 6),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                    style: TextStyle(
                      fontSize: selected ? 14 : 13,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      color: isLocked
                          ? Colors.grey.shade400
                          : (selected ? AppColors.primary : Colors.grey.shade600),
                    ),
                    child: Text(label),
                  ),
                  if (isLocked) ...[
                    const SizedBox(width: 4),
                    Icon(
                      Icons.lock_rounded,
                      size: 13,
                      color: Colors.grey.shade400,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
