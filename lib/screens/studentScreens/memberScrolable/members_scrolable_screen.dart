import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management/controllers/student_controller.dart';
import 'package:library_management/drawer/drawerWidgets/app_bar_widget.dart';
import 'package:library_management/provider/student_provider.dart';
import 'package:library_management/screens/studentScreens/memberDetailScreen/member_detailed_screen.dart';
import 'package:library_management/screens/studentScreens/widgets/card/student_card.dart';

class MembersScrolableScreen extends ConsumerStatefulWidget {
  const MembersScrolableScreen({super.key, required this.appBarTitle});

  final String appBarTitle;

  @override
  ConsumerState<MembersScrolableScreen> createState() =>
      _MembersScrolableScreenState();
}

class _MembersScrolableScreenState
    extends ConsumerState<MembersScrolableScreen> {
  final _scrollController = ScrollController();
  final _studentController = StudentController();

  bool _isFirstLoading = true;
  bool _isMoreLoading = false;
  bool _hasMore = true;

  int _page = 1;

  //ProviderListenable<dynamic> get studentsProvider => null;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    Future.microtask(() {
      _fetchStudents();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isMoreLoading &&
        _hasMore) {
      _fetchMoreStudents();
    }
  }

  Future<void> _fetchStudents() async {
    try {
      await _studentController.getAllStudents(
        ref: ref,
        libraryId: '6a422593f2ed24f734e41864',
        page: 1,
        limit: 20,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isFirstLoading = false;
        });
      }
    }
  }

  Future<void> _fetchMoreStudents() async {
    setState(() {
      _isMoreLoading = true;
    });

    final nextPage = _page + 1;

    try {
      final hasMoreStudents = await _studentController.getAllStudents(
        ref: ref,
        libraryId: '6a422593f2ed24f734e41864',
        page: nextPage,
        limit: 20,
        append: true,
      );

      if (mounted) {
        setState(() {
          if (hasMoreStudents) {
            _page = nextPage;
          } else {
            _hasMore = false;
          }
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isMoreLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final students = ref.watch(studentProvider);

    return Scaffold(
      appBar: AppBarWidget(title: widget.appBarTitle, actionIcon: Icons.search),
      body: _isFirstLoading
          ? const Center(child: CircularProgressIndicator())
          : students.isEmpty
          ? const Center(child: Text('No students found'))
          : ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(14, 30, 14, 30),
              itemCount: students.length + (_isMoreLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == students.length) {
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final student = students[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: StudentCard(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return MemberDetailedScreen(
                              studentNumber: index + 1,
                              studentName: student.name,
                              gender: 'NA',
                              phone: student.phone,
                              idProof: student.idProof,
                              totalAmount: student.totalPaid.toString(),
                              //later fetch from backend
                              totalDiscount: '0',
                              totalPending: student.totalPending.toString(),
                              expireDate: student.currentExpireDate,
                              joinDate: student.joiningDate,
                              plan: student.currentPlan,
                              program: student.currentProgramDays,
                            );
                          },
                        ),
                      );
                    },
                    studentName: student.name,
                    studentNumber: index + 1,
                    lableOne: 'Expire on',
                    expireDate: student.currentExpireDate,
                    lableTwo: 'Plan',
                    valueTwo: student.currentPlan,
                  ),
                );
              },
            ),
    );
  }
}
