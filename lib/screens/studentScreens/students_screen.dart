import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/controllers/student_summary_controller.dart';
import 'package:library_management/provider/student_summary_provider.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/members_scrolable_screen.dart';
import 'package:library_management/screens/studentScreens/widgets/total_student_button.dart';
import 'package:library_management/screens/studentScreens/widgets/add_member_button.dart';
import 'package:library_management/screens/studentScreens/widgets/icon_button_student.dart';
import 'package:library_management/screens/studentScreens/widgets/membership_container.dart';
import 'package:library_management/screens/studentScreens/widgets/active_member_button.dart';

class StudentsScreen extends ConsumerStatefulWidget {
  const StudentsScreen({super.key});

  @override
  ConsumerState<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends ConsumerState<StudentsScreen> {
  final double _horrizontalPadding = 16;
  final double _verticalPadding = 35;

  late bool isLoading;

  @override
  void initState() {
    super.initState();

    final studentSummary = ref.read(studentSummaryProvider);

    isLoading = studentSummary == null;

    if (studentSummary == null) {
      Future.microtask(() {
        _getStudentSummary();
      });
    }
  }

  Future<void> _getStudentSummary() async {
    try {
      await StudentSummaryController().getStudentSummary(
        ref: ref,
        //TO BE CHANGE
        libraryId: '6a422593f2ed24f734e41864',
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final studentSummary = ref.watch(studentSummaryProvider);
    final activeStudent = studentSummary?.active ?? 0;

    final expiring1To3Days = studentSummary?.expiring1To3Days ?? 0;
    final expiring4To7Days = studentSummary?.expiring4To7Days ?? 0;
    final expiring8To10Days = studentSummary?.expiring8To10Days ?? 0;

    final expired1To3Days = studentSummary?.expired1To3Days ?? 0;
    final expired4To7Days = studentSummary?.expired4To7Days ?? 0;
    final expired8To10Days = studentSummary?.expired8To10Days ?? 0;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(
              horizontal: _horrizontalPadding,
              vertical: _verticalPadding,
            ),
            child: Column(
              children: [
                ActiveMemberButton(
                  activeStudent: activeStudent,
                  isLoading: isLoading,
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: TotalStudentButton()),
                    SizedBox(width: 20),
                    Expanded(child: AddMemberButton()),
                  ],
                ),
                SizedBox(height: 20),
                MembershipContainer(
                  icon: Icons.warning_amber,
                  title: "Who's Membership are Expiring ?",
                  cardTitle: 'Expiring',
                  dayNumber: ['[ 1-3 Days ]', '[ 4-6 Days ]', '[ 7-10 Days ]'],
                  dayCount: [
                    expiring1To3Days,
                    expiring4To7Days,
                    expiring8To10Days,
                  ],
                  cardConatinaerColor: AppColors.warning,
                  cardTextColor: AppColors.activeButtonText,
                  conatinerColor: AppColors.container,
                  isLoading: isLoading,
                ),
                SizedBox(height: 20),
                MembershipContainer(
                  title: "Who's Membership are Expired ?",
                  conatinerColor: AppColors.badgeError,
                  icon: Icons.block,
                  cardTitle: 'Expired',
                  dayNumber: ['[ 1-3 Days ]', '[ 4-6 Days ]', '[ 7-10 Days ]'],
                  dayCount: [
                    expired1To3Days,
                    expired4To7Days,
                    expired8To10Days,
                  ],
                  cardConatinaerColor: const Color.fromARGB(255, 240, 27, 27),
                  cardTextColor: Colors.yellow,
                  titleColor: Colors.white,
                  isLoading: isLoading,
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    IconButtonStudent(
                      icon: Icons.payment,
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
                      icon: Icons.schedule,
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
