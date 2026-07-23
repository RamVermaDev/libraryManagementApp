import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/screens/studentScreens/memberDetailScreen/membership_row.dart';

class MembershipCard extends StatelessWidget {
  const MembershipCard({
    super.key,
    required this.scale,
    required this.joinDate,
    required this.expireDate,
    required this.planDuration,
    required this.slotId,
  });

  final double scale;
  final String joinDate;
  final String expireDate;
  final String slotId;
  final String planDuration;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        20 * scale,
        34 * scale,
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
            iconString: 'joinDate',
            label: 'Join Date',
            value: joinDate,
          ),

          SizedBox(height: 20 * scale),

          MembershipRow(
            scale: scale,
            iconString: 'expireDate',
            label: 'Expiry Date',
            value: expireDate,
          ),

          SizedBox(height: 20 * scale),

          MembershipRow(
            scale: scale,
            iconString: 'slot',
            label: 'Slot',
            value: slotId,
          ),

          SizedBox(height: 20 * scale),

          MembershipRow(
            scale: scale,
            iconString: 'timming',
            label: 'Timming',
            value: slotId,
          ),

          SizedBox(height: 20 * scale),

          MembershipRow(
            scale: scale,
            iconString: 'plan',
            label: 'Plan',
            value: planDuration,
          ),
        ],
      ),
    );
  }
}
