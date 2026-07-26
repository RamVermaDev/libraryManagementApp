import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/members.dart';

class MemberCardFooter extends StatelessWidget {
  final MemberStatus status;
  final String? rawStatus;
  final DateTime? expireDate;
  final VoidCallback? onRenew;
  final VoidCallback? onPause;
  final VoidCallback? onResume;
  final VoidCallback? onUnblock;
  final bool isLoading;

  const MemberCardFooter({
    super.key,
    required this.status,
    this.rawStatus,
    this.expireDate,
    this.onRenew,
    this.onPause,
    this.onResume,
    this.onUnblock,
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
    final isExpired =
        status == MemberStatus.expired ||
        (expireDate != null && expireDate!.isBefore(DateTime.now()));
    final isExpiring = status == MemberStatus.expiring;

    // Status Pill Configuration
    Color pillBg;
    Color dotColor;
    Color textColor;
    String pillText;

    // Button Configuration
    String buttonLabel;
    Color buttonColor;
    VoidCallback? buttonAction;

    if (isBlacklisted) {
      pillBg = const Color(0xFFECEFF1);
      dotColor = const Color(0xFF455A64);
      textColor = const Color(0xFF37474F);
      pillText = 'Blacklisted';

      buttonLabel = 'Unblock';
      buttonColor = const Color(0xFF16A34A);
      buttonAction = onUnblock;
    } else if (isPaused) {
      pillBg = const Color(0xFFFFF8E1);
      dotColor = const Color(0xFFF57F17);
      textColor = const Color(0xFFB76E00);
      pillText = 'Paused';

      buttonLabel = 'Resume';
      buttonColor = const Color(0xFF2E7D32);
      buttonAction = onResume;
    } else if (isExpired) {
      pillBg = const Color(0xFFFFEBEE);
      dotColor = const Color(0xFFD32F2F);
      textColor = const Color(0xFFC62828);
      pillText = days == 0
          ? 'Expired today'
          : 'Expired ${days.abs()} ${days.abs() == 1 ? 'day' : 'days'} ago';

      buttonLabel = 'Renew';
      buttonColor = const Color(0xFF0052CC); // Match reference blue button
      buttonAction = onRenew;
    } else if (isExpiring) {
      pillBg = const Color(0xFFFFF8E1);
      dotColor = const Color(0xFFF57F17);
      textColor = const Color(0xFFB76E00);
      pillText = days == 0
          ? 'Expiring today'
          : 'Expiring in ${days.abs()} ${days.abs() == 1 ? 'day' : 'days'}';

      buttonLabel = 'Renew';
      buttonColor = const Color(0xFF0052CC); // Match reference blue button
      buttonAction = onRenew;
    } else {
      pillBg = const Color(0xFFE8F5E9);
      dotColor = const Color(0xFF2E7D32);
      textColor = const Color(0xFF1B5E20);
      pillText = 'Active';

      buttonLabel = 'Pause';
      buttonColor = const Color(0xFFD97706);
      buttonAction = onPause;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left: Status Pill Badge
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

        // Right: Dynamic Action Button
        ElevatedButton(
          onPressed: buttonAction,
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: isLoading
              ? const SpinKitThreeBounce(color: Colors.white, size: 18)
              : Text(
                  buttonLabel,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ],
    );
  }
}
