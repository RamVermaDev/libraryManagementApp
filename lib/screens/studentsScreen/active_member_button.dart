import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/member_screen.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/members.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/members_screen_args.dart';

class ActiveMemberButton extends StatelessWidget {
  const ActiveMemberButton({
    super.key,
    required this.activeStudent,
    required this.isLoading,
  });

  final int activeStudent;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return MembersScreen(
                args: MembersScreenArgs(initialStatus: MemberStatus.active),
                appBarTitle: 'Active Member',
              );
            },
          ),
        );
      },
      child: Container(
        width: double.infinity,
        height: 60,
        padding: EdgeInsets.fromLTRB(30, 4, 30, 4),
        decoration: BoxDecoration(
          color: AppColors.warning,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Icon(Icons.people, color: Colors.white, size: 25),
            SizedBox(width: 12),
            Text(
              'Active Members',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.1,
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: isLoading
                    ? SizedBox(
                        width: 30,
                        child: SpinKitWave(color: Colors.white, size: 20),
                      )
                    : Text(
                        activeStudent.toString(),
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
