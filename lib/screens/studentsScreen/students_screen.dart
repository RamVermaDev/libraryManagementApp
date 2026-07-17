import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/context_extension.dart';
import 'package:library_management/controllers/student_summary_controller.dart';
import 'package:library_management/provider/current_library_provider.dart';
import 'package:library_management/provider/student_summary_provider.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/member_screen.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/members.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/members_screen_args.dart';
import 'package:library_management/screens/studentScreens/widgets/add_member_button.dart';
import 'package:library_management/screens/studentsScreen/total_student_button.dart';
import 'package:library_management/screens/studentScreens/widgets/icon_button_student.dart';
import 'package:library_management/screens/studentsScreen/membership_container.dart';
import 'package:library_management/screens/studentsScreen/active_member_button.dart';

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

    final libraryId = ref.read(currentLibraryProvider);
    isLoading = libraryId != null && studentSummary == null;

    if (studentSummary == null && libraryId != null) {
      Future.microtask(() {
        _getStudentSummary(libraryId);
      });
    }
  }

  Future<void> _getStudentSummary(String libraryId) async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
    });

    try {
      await StudentSummaryController().getStudentSummary(
        ref: ref,
        libraryId: libraryId,
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
    ref.listen<String?>(currentLibraryProvider, (previous, next) {
      if (previous == next || next == null) return;
      _getStudentSummary(next);
    });

    final studentSummary = ref.watch(studentSummaryProvider);
    final activeStudent = studentSummary?.active ?? 0;

    final expiring1To3Days = studentSummary?.expiring1To3Days ?? 0;
    final expiring4To7Days = studentSummary?.expiring4To7Days ?? 0;
    final expiring8To10Days = studentSummary?.expiring8To10Days ?? 0;

    final expired1To3Days = studentSummary?.expired1To3Days ?? 0;
    final expired4To7Days = studentSummary?.expired4To7Days ?? 0;
    final expired8To10Days = studentSummary?.expired8To10Days ?? 0;

    final double scale = context.scale;
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
                  scale: scale,
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: TotalStudentButton(scale: scale)),
                    SizedBox(width: 20),
                    Expanded(child: AddMemberButton(scale: scale)),
                  ],
                ),
                SizedBox(height: 40),
                MembershipContainer(
                  scale: scale,
                  onTapeOne: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return MembersScreen(
                            args: MembersScreenArgs(
                              initialStatus: MemberStatus.expiring,
                              initialDayFilter: MemberDayFilter.oneToThree,
                            ),
                            appBarTitle: 'Expiring Member',
                          );
                        },
                      ),
                    );
                  },
                  onTapeTwo: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return MembersScreen(
                            args: MembersScreenArgs(
                              initialStatus: MemberStatus.expiring,
                              initialDayFilter: MemberDayFilter.fourToSix,
                            ),
                            appBarTitle: 'Expiring Member',
                          );
                        },
                      ),
                    );
                  },
                  onTapeThree: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return MembersScreen(
                            args: MembersScreenArgs(
                              initialStatus: MemberStatus.expiring,
                              initialDayFilter: MemberDayFilter.sevenToTen,
                            ),
                            appBarTitle: 'Expiring Member',
                          );
                        },
                      ),
                    );
                  },

                  title: 'Expiring Soon',
                  cardTitle: 'MEMBERS',
                  dayNumber: ['1-3 DAYS ', '4-6 DAYS', '7-10 DAYS'],
                  dayCount: [
                    expiring1To3Days,
                    expiring4To7Days,
                    expiring8To10Days,
                  ],

                  conatinerColor: AppColors.warningLight,
                  isLoading: isLoading,
                ),
                SizedBox(height: 20),
                MembershipContainer(
                  scale: scale,
                  onTapeOne: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return MembersScreen(
                            args: MembersScreenArgs(
                              initialStatus: MemberStatus.expired,
                              initialDayFilter: MemberDayFilter.oneToThree,
                            ),
                            appBarTitle: 'Expiring Member',
                          );
                        },
                      ),
                    );
                  },
                  onTapeTwo: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return MembersScreen(
                            args: MembersScreenArgs(
                              initialStatus: MemberStatus.expired,
                              initialDayFilter: MemberDayFilter.fourToSix,
                            ),
                            appBarTitle: 'Expiring Member',
                          );
                        },
                      ),
                    );
                  },
                  onTapeThree: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return MembersScreen(
                            args: MembersScreenArgs(
                              initialStatus: MemberStatus.expired,
                              initialDayFilter: MemberDayFilter.sevenToTen,
                            ),
                            appBarTitle: 'Expiring Member',
                          );
                        },
                      ),
                    );
                  },
                  title: 'Recently Expired',
                  conatinerColor: AppColors.expiredContainerTwo,

                  cardTitle: 'MEMBERS',
                  dayNumber: ['1-3 DAYS', '4-6 DAYS', '7-10 DAYS'],
                  dayCount: [
                    expired1To3Days,
                    expired4To7Days,
                    expired8To10Days,
                  ],

                  isLoading: isLoading,
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    IconButtonStudent(
                      scale: scale,
                      icon: Icons.payment,
                      text: 'Due Amount',
                      onTap: () {},
                    ),
                    SizedBox(width: 12),
                    IconButtonStudent(
                      scale: scale,
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
