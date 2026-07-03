import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/drawer/drawerWidgets/app_bar_widget.dart';
import 'package:library_management/screens/studentScreens/student_detailed_screen.dart';
import 'package:library_management/screens/studentScreens/widgets/card/due_student_card.dart';
import 'package:library_management/screens/studentScreens/widgets/card/expired_student_card.dart';
import 'package:library_management/screens/studentScreens/widgets/card/student_card.dart';

class MembersScrolableScreen extends StatelessWidget {
  const MembersScrolableScreen({super.key, required this.appBarTitle});
  final String appBarTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: appBarTitle, actionIcon: Icons.search),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.fromLTRB(14, 30, 14, 30),
          child: Column(
            children: [
              DueStudentCard(
                onTap: () {},
                studentName: 'Student Name',
                lableOne: 'Expire on',
                valueOne: '01 Jan 2025',
                lableTwo: 'Plan',
                valueTwo: 'Morning 6 Hrs',
              ),

              ExpiredStudentCard(
                onTap: () {},
                studentName: 'Student Name',
                studentNumber: 3,
                lableOne: 'Expire on',
                valueOne: '01 Jan 2025',
                lableTwo: 'Plan',
                valueTwo: 'Morning 6 Hrs',
                cardItemsColor: AppColors.badgeError,
              ),

              StudentCard(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return StudentDetailedScreen(studentNumber: 1);
                      },
                    ),
                  );
                },
                studentName: 'Student Name',
                studentNumber: 3,
                lableOne: 'Expire on',
                valueOne: '01 Jan 2025',
                lableTwo: 'Plan',
                valueTwo: 'Morning 6 Hrs',
              ),
              StudentCard(
                onTap: () {},
                studentName: 'Student Name',
                studentNumber: 3,
                lableOne: 'Expire on',
                valueOne: '01 Jan 2025',
                lableTwo: 'Plan',
                valueTwo: 'Morning 6 Hrs',
              ),
              StudentCard(
                onTap: () {},
                studentName: 'Student Name',
                studentNumber: 3,
                lableOne: 'Expire on',
                valueOne: '01 Jan 2025',
                lableTwo: 'Plan',
                valueTwo: 'Morning 6 Hrs',
              ),
              StudentCard(
                onTap: () {},
                studentName: 'Student Name',
                studentNumber: 3,
                lableOne: 'Expire on',
                valueOne: '01 Jan 2025',
                lableTwo: 'Plan',
                valueTwo: 'Morning 6 Hrs',
              ),
              StudentCard(
                onTap: () {},
                studentName: 'Student Name',
                studentNumber: 3,
                lableOne: 'Expire on',
                valueOne: '01 Jan 2025',
                lableTwo: 'Plan',
                valueTwo: 'Morning 6 Hrs',
              ),
              StudentCard(
                onTap: () {},
                studentName: 'Student Name',
                studentNumber: 3,
                lableOne: 'Expire on',
                valueOne: '01 Jan 2025',
                lableTwo: 'Plan',
                valueTwo: 'Morning 6 Hrs',
              ),
              StudentCard(
                onTap: () {},
                studentName: 'Student Name',
                studentNumber: 3,
                lableOne: 'Expire on',
                valueOne: '01 Jan 2025',
                lableTwo: 'Plan',
                valueTwo: 'Morning 6 Hrs',
              ),
              StudentCard(
                onTap: () {},
                studentName: 'Student Name',
                studentNumber: 3,
                lableOne: 'Expire on',
                valueOne: '01 Jan 2025',
                lableTwo: 'Plan',
                valueTwo: 'Morning 6 Hrs',
              ),
              StudentCard(
                onTap: () {},
                studentName: 'Student Name',
                studentNumber: 3,
                lableOne: 'Expire on',
                valueOne: '01 Jan 2025',
                lableTwo: 'Plan',
                valueTwo: 'Morning 6 Hrs',
              ),
              StudentCard(
                onTap: () {},
                studentName: 'Student Name',
                studentNumber: 3,
                lableOne: 'Expire on',
                valueOne: '01 Jan 2025',
                lableTwo: 'Plan',
                valueTwo: 'Morning 6 Hrs',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
