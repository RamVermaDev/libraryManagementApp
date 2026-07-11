import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/member_screen.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/members.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/members_screen_args.dart';

class TotalStudentButton extends StatelessWidget {
  const TotalStudentButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return MembersScreen(
                args: MembersScreenArgs(initialStatus: MemberStatus.all),
                appBarTitle: 'Members',
              );
            },
          ),
        );
      },
      child: Container(
        height: 55,
        padding: EdgeInsets.fromLTRB(12, 4, 12, 4),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(4),
        ),
        alignment: Alignment.center,

        child: Text(
          'Total Members',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
