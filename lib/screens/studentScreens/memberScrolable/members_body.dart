import 'package:flutter/material.dart';
import 'package:library_management/models/student_model.dart';
import 'package:library_management/screens/studentScreens/memberDetailScreen/member_detailed_screen.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/empty_state.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/error_state.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/loading_state.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/member_card.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/member_color.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/members.dart';

class MembersBody extends StatelessWidget {
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;
  final MemberStatus selectedStatus;
  final ScrollController scrollController;
  final Future<void> Function() onRefresh;
  final VoidCallback onRetry;
  final List<StudentModel> members;

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
  });

  MemberStatus _statusForMember(StudentModel member) {
    // On pages other than All, keep the existing page design
    if (selectedStatus != MemberStatus.all) {
      return selectedStatus;
    }

    final expireDate = member.currentExpireDate;

    // No expiry date → keep normal All design
    if (expireDate == null) {
      return MemberStatus.all;
    }

    final today = DateTime.now();
    final currentDate = DateTime(today.year, today.month, today.day);

    final expiryDate = DateTime(
      expireDate.year,
      expireDate.month,
      expireDate.day,
    );

    final daysUntilExpiry = expiryDate.difference(currentDate).inDays;

    // Expired → expired design
    if (daysUntilExpiry < 0) {
      return MemberStatus.expired;
    }

    // Expiring within 10 days → expiring design
    if (daysUntilExpiry <= 10) {
      return MemberStatus.expiring;
    }

    // Active → keep normal All design
    return MemberStatus.all;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading && members.isEmpty) {
      return const LoadingState();
    }

    if (errorMessage != null && members.isEmpty) {
      return ErrorState(onRetry: onRetry);
    }

    if (members.isEmpty) {
      return EmptyState(status: selectedStatus);
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: MembersColors.primary,
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
            name: member.name,
            plan: member.currentPlan,
            status: _statusForMember(member),
            message: 'Hello',
            number: member.phone,
            expireDate: member.currentExpireDate,
          );
        },
      ),
    );
  }
}
