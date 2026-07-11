import 'package:flutter/material.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/day_filter_button.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/members.dart';

class DayFilterSection extends StatelessWidget {
  final MemberDayFilter selectedFilter;
  final ValueChanged<MemberDayFilter> onChanged;

  const DayFilterSection({
    super.key,
    required this.selectedFilter,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 78,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        itemCount: MemberDayFilter.values.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final filter = MemberDayFilter.values[index];

          return DayFilterButton(
            filter: filter,
            isSelected: selectedFilter == filter,
            onTap: () => onChanged(filter),
          );
        },
      ),
    );
  }
}