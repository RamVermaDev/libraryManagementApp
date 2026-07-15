import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/member_screen.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/members.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/members_screen_args.dart';

class ActiveMemberButton extends StatelessWidget {
  const ActiveMemberButton({
    super.key,
    required this.activeStudent,
    required this.isLoading,
    required this.scale,
  });

  final int activeStudent;
  final bool isLoading;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MembersScreen(
              args: MembersScreenArgs(initialStatus: MemberStatus.active),
              appBarTitle: "Active Members",
            ),
          ),
        );
      },
      child: Container(
        height: 130 * scale,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18 * scale),
          border: Border.all(color: AppColors.grey200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .04),
              blurRadius: 18 * scale,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            /// LEFT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Active Members",
                    style: TextStyle(
                      fontSize: 22 * scale,
                      fontWeight: FontWeight.w700,
                      color: AppColors.activeButtonText,
                    ),
                  ),

                  const Spacer(),

                  isLoading
                      ? SpinKitThreeBounce(
                          color: AppColors.buttonPrimary,
                          size: 22 * scale,
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              activeStudent.toString(),
                              style: TextStyle(
                                fontSize: 40 * scale,
                                height: 1,
                                fontWeight: FontWeight.bold,
                                color: AppColors.buttonPrimary,
                              ),
                            ),

                            // SizedBox(width: 14 * scale),

                            // Container(
                            //   padding: const EdgeInsets.symmetric(
                            //     horizontal: 8,
                            //     vertical: 5,
                            //   ),
                            //   decoration: BoxDecoration(
                            //     color: AppColors.primaryShadeLight,
                            //     borderRadius: BorderRadius.circular(20),
                            //   ),
                            //   child: Row(
                            //     children: [
                            //       Icon(
                            //         Icons.trending_up,
                            //         color: AppColors.buttonPrimary,
                            //         size: 18 * scale,
                            //       ),
                            //       SizedBox(width: 3),
                            //       Text(
                            //         "12%",
                            //         style: TextStyle(
                            //           color: AppColors.buttonPrimary,
                            //           fontWeight: FontWeight.bold,
                            //           fontSize: 14 * scale,
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                ],
              ),
            ),

            /// RIGHT ICON
            Icon(
              Icons.groups_rounded,
              size: 55 * scale,
              color: AppColors.grey200,
            ),
          ],
        ),
      ),
    );
  }
}
