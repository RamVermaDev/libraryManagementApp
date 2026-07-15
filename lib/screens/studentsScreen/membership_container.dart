import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/screens/studentsScreen/memberships_card.dart';

class MembershipContainer extends StatelessWidget {
  const MembershipContainer({
    super.key,
    required this.title,
    required this.conatinerColor,
    required this.cardTitle,
    required this.dayNumber,
    required this.dayCount,
    this.titleColor,
    this.isLoading = false,
    required this.onTapeOne,
    required this.onTapeTwo,
    required this.onTapeThree,
    required this.scale,
  });

  final String title;
  final Color conatinerColor;
  final String cardTitle;
  final List<String> dayNumber;
  final List<int> dayCount;
  final Color? titleColor;
  final bool isLoading;
  final VoidCallback onTapeOne;
  final VoidCallback onTapeTwo;
  final VoidCallback onTapeThree;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(22 * scale),
      decoration: BoxDecoration(
        color: conatinerColor,
        borderRadius: BorderRadius.circular(22 * scale),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18 * scale,
              fontWeight: FontWeight.w700,
              color: titleColor ?? AppColors.heading,
            ),
          ),

          SizedBox(height: 18 * scale),

          Row(
            children: [
              MembershipsCard(
                title: cardTitle,
                daysNumber: dayNumber[0],
                dayCount: dayCount[0],
                isLoading: isLoading,
                onTap: onTapeOne,
                scale: scale,
              ),

              SizedBox(width: 16 * scale),

              MembershipsCard(
                title: cardTitle,
                daysNumber: dayNumber[1],
                dayCount: dayCount[1],
                isLoading: isLoading,
                onTap: onTapeTwo,
                scale: scale,
              ),

              SizedBox(width: 16 * scale),

              MembershipsCard(
                title: cardTitle,
                daysNumber: dayNumber[2],
                dayCount: dayCount[2],
                isLoading: isLoading,
                onTap: onTapeThree,
                scale: scale,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
