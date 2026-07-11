enum MemberStatus { all, active, expiring, expired, pending }

/// ===============================================================
/// MEMBER DAY FILTER
/// ===============================================================

enum MemberDayFilter {
  oneToThree(1, 3),
  fourToSix(4, 6),
  sevenToTen(7, 10);

  final int startDay;
  final int endDay;

  const MemberDayFilter(this.startDay, this.endDay);
}

/// ===============================================================
/// EXTENSIONS
/// ===============================================================

extension MemberStatusX on MemberStatus {
  String get label {
    switch (this) {
      case MemberStatus.all:
        return 'All';

      case MemberStatus.active:
        return 'Active';

      case MemberStatus.pending:
        return 'Pending';

      case MemberStatus.expiring:
        return 'Expiring';

      case MemberStatus.expired:
        return 'Expired';
    }
  }

  bool get hasDayFilter {
    return this == MemberStatus.expiring || this == MemberStatus.expired;
  }
}

extension MemberDayFilterX on MemberDayFilter {
  String get label {
    switch (this) {
      case MemberDayFilter.oneToThree:
        return '1–3 Days';

      case MemberDayFilter.fourToSix:
        return '4–6 Days';

      case MemberDayFilter.sevenToTen:
        return '7–10 Days';
    }
  }

  int get startDay {
    switch (this) {
      case MemberDayFilter.oneToThree:
        return 1;

      case MemberDayFilter.fourToSix:
        return 4;

      case MemberDayFilter.sevenToTen:
        return 7;
    }
  }

  int get endDay {
    switch (this) {
      case MemberDayFilter.oneToThree:
        return 3;

      case MemberDayFilter.fourToSix:
        return 6;

      case MemberDayFilter.sevenToTen:
        return 10;
    }
  }
}
