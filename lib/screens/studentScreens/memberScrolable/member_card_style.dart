import 'dart:ui';

import 'package:library_management/app_colors.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/members.dart';

class MemberCardStyle {
  final Color background;
  final Color border;
  final Color accent;
  final Color avatarBackground;

  const MemberCardStyle({
    required this.background,
    required this.border,
    required this.accent,
    required this.avatarBackground,
  });

  factory MemberCardStyle.fromStatus(MemberStatus status) {
    switch (status) {
      case MemberStatus.active:
        return const MemberCardStyle(
          background: AppColors.memberActiveSoft,
          border: Color(0xFFDDEFE3),
          accent: AppColors.memberActive,
          avatarBackground: Color(0xFFE4F4E9),
        );

      case MemberStatus.expiring:
        return const MemberCardStyle(
          background: AppColors.memberExpiringSoft,
          border: Color(0xFFF4E7CA),
          accent: AppColors.memberExpiring,
          avatarBackground: Color(0xFFF9ECD2),
        );

      case MemberStatus.expired:
        return const MemberCardStyle(
          background: AppColors.memberExpiredSoft,
          border: Color(0xFFF3DDE0),
          accent: AppColors.memberExpired,
          avatarBackground: Color(0xFFF7E2E5),
        );

      case MemberStatus.all:
        return const MemberCardStyle(
          background: AppColors.surface,
          border: AppColors.border,
          accent: AppColors.primary,
          avatarBackground: AppColors.primarySoft,
        );

      case MemberStatus.pending:
        return const MemberCardStyle(
          background: AppColors.memberPendingSoft,
          border: Color(0xFFDDE4EC),
          accent: AppColors.memberPending,
          avatarBackground: Color(0xFFE5EAF0),
        );
    }
  }
}
