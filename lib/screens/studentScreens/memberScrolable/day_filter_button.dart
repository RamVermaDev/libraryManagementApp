import 'package:flutter/material.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/member_color.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/members.dart';

class DayFilterButton extends StatelessWidget {
  final MemberDayFilter filter;
  final bool isSelected;
  final VoidCallback onTap;

  const DayFilterButton({
    super.key,
    required this.filter,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 28),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFE9EEEA) : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: isSelected ? Colors.transparent : const Color(0xFFD8D3CE),
              width: 1,
            ),
          ),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 180),
            style: TextStyle(
              color: isSelected ? MembersColors.heading : MembersColors.body,
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
            child: Text(filter.label, maxLines: 1, softWrap: false),
          ),
        ),
      ),
    );
  }
}
