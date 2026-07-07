import 'package:flutter/material.dart';
import 'package:library_management/screens/studentScreens/widgets/card/memberships_card.dart';

class MembershipContainer extends StatelessWidget {
  const MembershipContainer({
    super.key,
    required this.title,
    required this.conatinerColor,
    required this.icon,
    required this.cardTitle,
    required this.dayNumber,
    required this.dayCount,
    required this.cardConatinaerColor,
    required this.cardTextColor,
    this.titleColor,
    this.isLoading = false,
  });
  final IconData icon;
  final String title;
  final Color? titleColor;
  final List<String> dayNumber;
  final List<int> dayCount;
  final Color cardConatinaerColor;
  final Color cardTextColor;
  final Color conatinerColor;
  final String cardTitle;
  final bool isLoading;


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: conatinerColor,
        border: Border.all(width: 0.5),
      ),

      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: titleColor ?? Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              MembershipsCard(
                title: cardTitle,
                daysNumber: dayNumber[0],
                dayCount: dayCount[0],
                icon: icon,
                containerColor: cardConatinaerColor,
                containerTextColor: cardTextColor,
                isLoading: isLoading,
              ),
              SizedBox(width: 2),
              MembershipsCard(
                title: cardTitle,
                daysNumber: dayNumber[1],
                dayCount: dayCount[1],
                icon: icon,
                containerColor: cardConatinaerColor,
                containerTextColor: cardTextColor,
                isLoading: isLoading,
              ),
              SizedBox(width: 2),
              MembershipsCard(
                title: cardTitle,
                daysNumber: dayNumber[2],
                dayCount: dayCount[2],
                icon: icon,
                containerColor: cardConatinaerColor,
                containerTextColor: cardTextColor,
                isLoading: isLoading,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
