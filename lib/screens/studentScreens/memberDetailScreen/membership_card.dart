import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/screens/studentScreens/memberDetailScreen/membership_row.dart';

class MembershipCard extends StatelessWidget {
  const MembershipCard({
    super.key,
    required this.scale,
    required this.joinDate,
    required this.expireDate,
    required this.plan,
    required this.program,
  });

  final double scale;
  final String joinDate;
  final String expireDate;
  final String plan;
  final String program;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        20 * scale,
        24 * scale,
        20 * scale,
        25 * scale,
      ),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(20 * scale),
      ),
      child: Column(
        children: [
          MembershipRow(
            scale: scale,
            icon: Icons.calendar_month_outlined,
            label: 'Join In',
            value: joinDate,
          ),

          SizedBox(height: 28 * scale),

          MembershipRow(
            scale: scale,
            icon: Icons.hourglass_empty_rounded,
            label: 'Expire on',
            value: expireDate,
          ),

          SizedBox(height: 28 * scale),

          MembershipRow(
            scale: scale,
            icon: Icons.schedule_rounded,
            label: 'Plan',
            value: plan,
          ),

          SizedBox(height: 28 * scale),

          MembershipRow(
            scale: scale,
            icon: Icons.menu_book_rounded,
            label: 'Program',
            value: program,
          ),
        ],
      ),
    );
  }
}
