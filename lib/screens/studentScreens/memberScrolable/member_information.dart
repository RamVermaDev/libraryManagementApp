import 'package:flutter/material.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/member_color.dart';

class MemberInformation extends StatelessWidget {
  const MemberInformation({
    super.key,
    required this.memberName,
    required this.expireDate,
    required this.plan,
  });

  final String memberName;
  final DateTime? expireDate;
  final String plan;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Member name
        Text(
          memberName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: MembersColors.heading,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 4),

        // Expiry date
        Text(
          'Expire on : ${_formatDate(expireDate)}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: MembersColors.body,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 2),

        // Member plan
        Text(
          'Plan : $plan',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: MembersColors.body,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final day = date?.day.toString().padLeft(2, '0');

    return '$day ${months[date!.month - 1]} ${date.year}';
  }
}
