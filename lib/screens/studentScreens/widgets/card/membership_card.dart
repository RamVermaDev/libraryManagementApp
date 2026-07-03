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
    required this.isLoading,
  });
  final String title;
  final String daysNumber;
  final int dayCount;
  final IconData icon;
  final Color containerTextColor;
  final Color containerColor;
  final bool isLoading;

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
          onTap: isLoading ? null : () {},
          child: Padding(
            padding: EdgeInsetsGeometry.fromLTRB(8, 12, 8, 16),
            child: Column(
              children: [
                Icon(icon),
                SizedBox(height: 4),
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
                Text(daysNumber),
                SizedBox(height: 16),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: containerColor,
                  ),
                  alignment: Alignment.center,
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : Text(
                          dayCount.toString(),
                          style: TextStyle(
                            fontSize: 17,
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
