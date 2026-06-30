import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/screens/studentScreens/members_scrolable_screen.dart';
import 'package:library_management/screens/studentScreens/widgets/active_student_button.dart';
import 'package:library_management/screens/studentScreens/widgets/add_member_button.dart';
import 'package:library_management/screens/studentScreens/widgets/icon_button_student.dart';
import 'package:library_management/screens/studentScreens/widgets/membership_container.dart';
import 'package:library_management/screens/studentScreens/widgets/total_member_button.dart';

class StudentsScreen extends StatelessWidget {
  const StudentsScreen({super.key});

  final double _horrizontalPadding = 16;
  final double _verticalPadding = 35;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsGeometry.fromLTRB(
              _horrizontalPadding,
              _verticalPadding,
              _horrizontalPadding,
              _verticalPadding,
            ),
            child: Column(
              children: [
                TotalMemberButton(),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: ActiveStudentButton()),
                    SizedBox(width: 20),
                    Expanded(child: AddMemberButton()),
                  ],
                ),
                SizedBox(height: 20),
                MembershipContainer(
                  icon: Icons.dangerous,
                  title: "Who's Membership are Expiring ?",
                  cardTitle: 'Expiring',
                  dayNumber: ['[ 1 -  3 ]', '[ 3 -  6 ]', '[ 7 -  10 ]'],
                  dayCount: [5, 7, 10],
                  cardConatinaerColor: AppColors.warning,
                  cardTextColor: AppColors.activeButtonText,
                  conatinerColor: AppColors.container,
                ),
                SizedBox(height: 20),
                MembershipContainer(
                  title: "Who's Membership are Expired ?",
                  conatinerColor: AppColors.badgeError,
                  icon: Icons.calculate,
                  cardTitle: 'Expired',
                  dayNumber: ['[ 1 -  3 ]', '[ 3 -  6 ]', '[ 7 -  10 ]'],
                  dayCount: [5, 7, 10],
                  cardConatinaerColor: const Color.fromARGB(255, 240, 27, 27),
                  cardTextColor: Colors.yellow,
                  titleColor: Colors.white,
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    IconButtonStudent(
                      icon: Icons.commit,
                      text: 'Due Amount',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return MembersScrolableScreen(
                                appBarTitle: 'Active Members',
                              );
                            },
                          ),
                        );
                      },
                    ),
                    SizedBox(width: 12),
                    IconButtonStudent(
                      icon: Icons.follow_the_signs,
                      text: 'Follow Up',
                      onTap: () {},
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
