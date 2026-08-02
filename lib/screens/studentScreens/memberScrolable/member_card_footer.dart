import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/members.dart';

class MemberCardFooter extends StatelessWidget {
  final MemberStatus status;
  final String? rawStatus;
  final DateTime? expireDate;
  final double? pendingAmount;
  final VoidCallback? onRenew;
  final VoidCallback? onPause;
  final VoidCallback? onResume;
  final VoidCallback? onUnblock;
  final VoidCallback? onPending;
  final bool isLoading;

  const MemberCardFooter({
    super.key,
    required this.status,
    this.rawStatus,
    this.expireDate,
    this.pendingAmount,
    this.onRenew,
    this.onPause,
    this.onResume,
    this.onUnblock,
    this.onPending,
    this.isLoading = false,
  });

  int _calculateDays(DateTime? date) {
    if (date == null) return 0;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    return target.difference(today).inDays;
  }

  @override
  Widget build(BuildContext context) {
    final days = _calculateDays(expireDate);
    final isBlacklisted = rawStatus == 'blacklisted';
    final isPaused = rawStatus == 'paused';
    final isPendingTab = status == MemberStatus.pending;
    final isExpired =
        status == MemberStatus.expired ||
        (expireDate != null && expireDate!.isBefore(DateTime.now()));
    final isExpiring = status == MemberStatus.expiring;

    final String pendingLabel = (pendingAmount != null && pendingAmount! > 0)
        ? 'Due ₹${pendingAmount! % 1 == 0 ? pendingAmount!.toInt() : pendingAmount!.toStringAsFixed(0)}'
        : 'Due Amount';

    // Status Pill Configuration
    Color pillBg;
    Color dotColor;
    Color textColor;
    String pillText;

    // Action Buttons Configuration
    final List<_FooterActionButton> actionButtons = [];

    // Add Pending button if student has pending dues
    if ((pendingAmount != null && pendingAmount! > 0) || isPendingTab) {
      actionButtons.add(_FooterActionButton(
        label: pendingLabel,
        backgroundColor: const Color(0xFFF3E8FF),
        iconColor: const Color(0xFF7C3AED),
        icon: Icons.account_balance_wallet_outlined,
        action: onPending,
      ));
    }

    if (isBlacklisted) {
      pillBg = const Color(0xFFECEFF1);
      dotColor = const Color(0xFF455A64);
      textColor = const Color(0xFF37474F);
      pillText = 'Blacklisted';

      actionButtons.add(_FooterActionButton(
        label: 'Unblock',
        backgroundColor: const Color(0xFFDCFCE7),
        iconColor: const Color(0xFF15803D),
        icon: Icons.lock_open_rounded,
        action: onUnblock,
      ));
    } else if (isPaused) {
      pillBg = const Color(0xFFFFF8E1);
      dotColor = const Color(0xFFF57F17);
      textColor = const Color(0xFFB76E00);
      pillText = 'Paused';

      actionButtons.add(_FooterActionButton(
        label: 'Resume',
        backgroundColor: const Color(0xFFE8F5E9),
        iconColor: const Color(0xFF2E7D32),
        icon: Icons.play_circle_outline_rounded,
        action: onResume,
      ));
    } else if (isPendingTab) {
      pillBg = const Color(0xFFF3E8FF);
      dotColor = const Color(0xFF7C3AED);
      textColor = const Color(0xFF6D28D9);
      pillText = 'Pending';
    } else if (isExpired) {
      pillBg = const Color(0xFFFFEBEE);
      dotColor = const Color(0xFFD32F2F);
      textColor = const Color(0xFFC62828);
      pillText = days == 0
          ? 'Expired today'
          : 'Expired ${days.abs()} ${days.abs() == 1 ? 'day' : 'days'} ago';

      actionButtons.add(_FooterActionButton(
        label: 'Renew',
        backgroundColor: const Color(0xFFEFF6FF),
        iconColor: const Color(0xFF1D4ED8),
        icon: Icons.autorenew_rounded,
        action: onRenew,
      ));
    } else if (isExpiring) {
      pillBg = const Color(0xFFFFF8E1);
      dotColor = const Color(0xFFF57F17);
      textColor = const Color(0xFFB76E00);
      pillText = days == 0
          ? 'Expiring today'
          : 'Expiring in ${days.abs()} ${days.abs() == 1 ? 'day' : 'days'}';

      actionButtons.add(_FooterActionButton(
        label: 'Pause',
        backgroundColor: const Color(0xFFFEF3C7),
        iconColor: const Color(0xFFD97706),
        icon: Icons.pause_circle_outline_rounded,
        action: onPause,
      ));
      actionButtons.add(_FooterActionButton(
        label: 'Renew',
        backgroundColor: const Color(0xFFEFF6FF),
        iconColor: const Color(0xFF1D4ED8),
        icon: Icons.autorenew_rounded,
        action: onRenew,
      ));
    } else {
      pillBg = const Color(0xFFE8F5E9);
      dotColor = const Color(0xFF2E7D32);
      textColor = const Color(0xFF1B5E20);
      pillText = 'Active';

      actionButtons.add(_FooterActionButton(
        label: 'Pause',
        backgroundColor: const Color(0xFFFEF3C7),
        iconColor: const Color(0xFFD97706),
        icon: Icons.pause_circle_outline_rounded,
        action: onPause,
      ));
    }

    return Row(
      children: [
        // Left: Fixed Status Pill Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: pillBg,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                pillText,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        // Right: Horizontally Scrollable Action Strip
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true,
            physics: const BouncingScrollPhysics(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: actionButtons.map((btn) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: btn.backgroundColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: btn.action,
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          child: isLoading
                              ? SpinKitThreeBounce(
                                  color: btn.iconColor,
                                  size: 16,
                                )
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      btn.icon,
                                      size: 19,
                                      color: btn.iconColor,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      btn.label,
                                      style: TextStyle(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w400,
                                        color: btn.iconColor,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class _FooterActionButton {
  final String label;
  final Color backgroundColor;
  final Color iconColor;
  final IconData icon;
  final VoidCallback? action;

  _FooterActionButton({
    required this.label,
    required this.backgroundColor,
    required this.iconColor,
    required this.icon,
    this.action,
  });
}
