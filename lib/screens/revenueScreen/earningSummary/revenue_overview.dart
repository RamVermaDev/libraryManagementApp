import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/screens/revenueScreen/earningSummary/revenue_state_card.dart';
import 'package:library_management/screens/revenueScreen/section_header.dart';

class RevenueOverview extends StatelessWidget {
  const RevenueOverview({
    super.key,
    required this.today,
    required this.month,
    required this.year,
    required this.allTime,
    required this.scale,
    required this.isLoading,
  });

  final double? today;
  final double? month;
  final double? year;
  final double? allTime;
  final double scale;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Earning Summary', fontSize: 18 * scale),
        SizedBox(height: 16 * scale),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10 * scale,
          crossAxisSpacing: 10 * scale,
          childAspectRatio: 2,
          children: [
            RevenueStatCard(
              title: 'Today',
              amount: today,
              icon: Icons.calendar_month_outlined,
              color: const Color(0xFF059669),
              background: const Color(0xFFE4F6EF),
              scale: scale,
              isLoading: isLoading,
            ),
            RevenueStatCard(
              title: 'This Month',
              amount: month,
              icon: Icons.calendar_month_outlined,
              color: const Color(0xFF2563EB),
              background: const Color(0xFFEAF1FF),
              cardColor: AppColors.grey200,
              scale: scale,
              isLoading: isLoading,
            ),
            RevenueStatCard(
              title: 'This Year',
              amount: year,
              icon: Icons.calendar_month_outlined,
              color: const Color(0xFF3322B8),
              background: const Color(0xFFF0EAFF),
              scale: scale,
              isLoading: isLoading,
            ),
            RevenueStatCard(
              title: 'All Time',
              amount: allTime,
              icon: Icons.all_inclusive_rounded,
              color: const Color(0xFFEA580C),
              background: const Color(0xFFFFEFE6),
              scale: scale,
              isLoading: isLoading,
            ),
          ],
        ),
      ],
    );
  }
}
