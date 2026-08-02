import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/controllers/student_controller.dart';
import 'package:library_management/models/student_model.dart';
import 'package:library_management/screens/studentScreens/memberDetailScreen/action_card.dart';
import 'package:library_management/screens/studentScreens/memberDetailScreen/member_detailed_screen.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/empty_state.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/error_state.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/loading_state.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/member_card.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/members.dart';
import 'package:library_management/screens/studentScreens/pauseResume/pause_student_sheet.dart';
import 'package:library_management/screens/studentScreens/pauseResume/resume_student_sheet.dart';
import 'package:library_management/screens/studentScreens/pauseResume/unblock_student_sheet.dart';
import 'package:library_management/screens/studentScreens/renewAdmission/renew_admission_screen.dart';
import 'package:library_management/services/student_message_service.dart';

class MembersBody extends ConsumerWidget {
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;
  final MemberStatus selectedStatus;
  final ScrollController scrollController;
  final Future<void> Function() onRefresh;
  final VoidCallback onRetry;
  final List<StudentModel> members;
  final bool isSearching;

  const MembersBody({
    super.key,
    required this.isLoading,
    required this.isLoadingMore,
    required this.errorMessage,
    required this.selectedStatus,
    required this.scrollController,
    required this.onRefresh,
    required this.onRetry,
    required this.members,
    this.isSearching = false,
  });

  static final StudentController _studentController = StudentController();

  MemberStatus _statusForMember(StudentModel member) {
    if (selectedStatus == MemberStatus.pending) {
      return MemberStatus.pending;
    }

    final expireDate = member.currentExpireDate;
    if (expireDate == null) {
      return MemberStatus.active;
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(
      expireDate.year,
      expireDate.month,
      expireDate.day,
    );

    final daysUntilExpiry = targetDate.difference(today).inDays;

    if (daysUntilExpiry < 0) {
      return MemberStatus.expired;
    }

    if (daysUntilExpiry <= 10) {
      return MemberStatus.expiring;
    }

    return MemberStatus.active;
  }

  Future<void> _handlePause(
      BuildContext context, WidgetRef ref, StudentModel member) async {
    final studentId = member.id;
    if (studentId == null || studentId.isEmpty) return;

    await PauseStudentSheet.show(
      context: context,
      member: member,
      scale: 1.0,
      onPause: (reason) async {
        return await _studentController.pauseStudent(
          context: context,
          ref: ref,
          libraryId: member.libraryId,
          studentId: studentId,
          reason: reason,
        );
      },
    );
  }

  Future<void> _handleResume(
      BuildContext context, WidgetRef ref, StudentModel member) async {
    final studentId = member.id;
    if (studentId == null || studentId.isEmpty) return;

    await ResumeStudentSheet.show(
      context: context,
      member: member,
      scale: 1.0,
      onResume: (result) async {
        return await _studentController.resumeStudent(
          context: context,
          ref: ref,
          libraryId: member.libraryId,
          studentId: studentId,
          extensionDays: result.extensionDays,
          seatId: result.seatId,
        );
      },
    );
  }

  Future<void> _handleUnblock(
      BuildContext context, WidgetRef ref, StudentModel member) async {
    final studentId = member.id;
    if (studentId == null || studentId.isEmpty) return;

    final confirmed = await UnblockStudentSheet.show(
      context: context,
      member: member,
      scale: 1.0,
    );

    if (confirmed == true && context.mounted) {
      await _studentController.unblockStudent(
        context: context,
        ref: ref,
        libraryId: member.libraryId,
        studentId: studentId,
      );
    }
  }

  void _handleRenew(BuildContext context, StudentModel member) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RenewAdmissionScreen(member: member),
      ),
    );
  }

  Future<void> _handlePending(
      BuildContext context, WidgetRef ref, StudentModel member) async {
    final studentId = member.id;
    if (studentId == null || studentId.isEmpty) return;

    await showModalBottomSheet<PendingResolutionResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PendingResolutionBottomSheet(
        totalPending: member.totalPending,
        onSubmit: (res) async {
          await _studentController.clearStudentPending(
            context: context,
            ref: ref,
            libraryId: member.libraryId,
            studentId: studentId,
            action: res.action,
            amount: res.amount,
            paymentMode: res.paymentMode,
            note: res.note,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isLoading && members.isEmpty) {
      return const LoadingState();
    }

    if (errorMessage != null && members.isEmpty) {
      return ErrorState(onRetry: onRetry);
    }

    if (members.isEmpty) {
      return EmptyState(
        status: selectedStatus,
        title: isSearching ? 'Not found' : null,
        subtitle: isSearching ? 'No matching name or phone number' : null,
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColors.primary,
      child: ListView.separated(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 2, 18, 30),
        itemCount: members.length + (isLoadingMore ? 1 : 0),
        separatorBuilder: (_, __) {
          return const SizedBox(height: 12);
        },
        itemBuilder: (context, index) {
          if (index == members.length) {
            return const Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final member = members[index];
          final planDisplay = (member.currentPlanDays ?? 0) > 0
              ? '${member.currentPlanDays} Days'
              : 'Monthly';

          final libraryName = StudentMessageService.getLibraryName(
            ref,
            targetLibraryId: member.libraryId,
          );

          final message = StudentMessageService.generateMessage(
            student: member,
            libraryName: libraryName,
          );

          return MemberCard(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return MemberDetailedScreen(member: member);
                  },
                ),
              );
            },
            memberNumber: index + 1,
            idProof: member.idProof,
            img: member.profileImage,
            name: member.name,
            plan: planDisplay,
            slotTiming: member.slotTiming,
            seatNumber: member.seatId,
            status: _statusForMember(member),
            rawStatus: member.status,
            message: message,
            number: member.phone,
            expireDate: member.currentExpireDate,
            pendingAmount: member.totalPending,
            onPause: () => _handlePause(context, ref, member),
            onResume: () => _handleResume(context, ref, member),
            onRenew: () => _handleRenew(context, member),
            onUnblock: () => _handleUnblock(context, ref, member),
            onPending: () => _handlePending(context, ref, member),
          );
        },
      ),
    );
  }
}
