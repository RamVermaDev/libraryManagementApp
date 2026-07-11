import 'dart:ui';

import 'package:library_management/screens/studentScreens/memberScrolable/member_color.dart';
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
          background: MembersColors.activeSoft,
          border: Color(0xFFDDEFE3),
          accent: MembersColors.active,
          avatarBackground: Color(0xFFE4F4E9),
        );

      case MemberStatus.expiring:
        return const MemberCardStyle(
          background: MembersColors.expiringSoft,
          border: Color(0xFFF4E7CA),
          accent: MembersColors.expiring,
          avatarBackground: Color(0xFFF9ECD2),
        );

      case MemberStatus.expired:
        return const MemberCardStyle(
          background: MembersColors.expiredSoft,
          border: Color(0xFFF3DDE0),
          accent: MembersColors.expired,
          avatarBackground: Color(0xFFF7E2E5),
        );

      case MemberStatus.all:
        return const MemberCardStyle(
          background: MembersColors.surface,
          border: MembersColors.border,
          accent: MembersColors.primary,
          avatarBackground: MembersColors.primarySoft,
        );

      case MemberStatus.pending:
        return const MemberCardStyle(
          background: MembersColors.pendingSoft,
          border: Color(0xFFDDE4EC),
          accent: MembersColors.pending,
          avatarBackground: Color(0xFFE5EAF0),
        );
    }
  }
}
