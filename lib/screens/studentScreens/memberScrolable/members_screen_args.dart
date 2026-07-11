import 'package:library_management/screens/studentScreens/memberScrolable/members.dart';

class MembersScreenArgs {
  final MemberStatus initialStatus;
  final MemberDayFilter? initialDayFilter;

  const MembersScreenArgs({required this.initialStatus, this.initialDayFilter});

  const MembersScreenArgs.all()
    : initialStatus = MemberStatus.all,
      initialDayFilter = null;

  const MembersScreenArgs.active()
    : initialStatus = MemberStatus.active,
      initialDayFilter = null;

  const MembersScreenArgs.expiring({
    MemberDayFilter filter = MemberDayFilter.oneToThree,
  }) : initialStatus = MemberStatus.expiring,
       initialDayFilter = filter;

  const MembersScreenArgs.expired({
    MemberDayFilter filter = MemberDayFilter.oneToThree,
  }) : initialStatus = MemberStatus.expired,
       initialDayFilter = filter;
}