import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/member_screen.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/members.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/members_screen_args.dart';

class TotalStudentButton extends StatelessWidget {
  const TotalStudentButton({super.key, required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      //borderRadius: BorderRadius.circular(20 * scale),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MembersScreen(
              args: MembersScreenArgs(initialStatus: MemberStatus.all),
              appBarTitle: 'Members',
            ),
          ),
        );
      },
      child: Container(
        height: 55 * scale,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14 * scale),
          border: Border.all(
            color: AppColors.buttonPrimary,
            width: 0.8 * scale,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 14 * scale,
              offset: Offset(0, 4 * scale),
            ),
          ],
        ),
        child: Text(
          'Total Members',
          style: TextStyle(
            color: AppColors.primaryShade,
            fontSize: 16 * scale,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.1 * scale,
          ),
        ),
      ),
    );
  }
}
