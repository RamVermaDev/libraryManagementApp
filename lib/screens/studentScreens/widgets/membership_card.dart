import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';

class MembershipCard extends StatelessWidget {
  const MembershipCard({
    super.key,
    required this.icon,
    required this.title,
    required this.daysNumber,
    required this.dayCount,
    required this.containerColor,
    required this.containerTextColor,
  });
  final String title;
  final String daysNumber;
  final int dayCount;
  final IconData icon;
  final Color containerTextColor;
  final Color containerColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: AppColors.black,
            width: 1, // Thin border
          ),
        ),

        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: EdgeInsetsGeometry.all(12),
            child: Column(
              children: [
                Icon(icon),
                SizedBox(height: 12),
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
                Text(daysNumber),
                SizedBox(height: 20),
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: containerColor,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    dayCount.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: containerTextColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
