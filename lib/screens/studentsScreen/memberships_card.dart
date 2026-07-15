import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:library_management/app_colors.dart';

class MembershipsCard extends StatelessWidget {
  const MembershipsCard({
    super.key,
    required this.title,
    required this.daysNumber,
    required this.dayCount,
    required this.isLoading,
    required this.onTap,
    this.scale = 1,
  });

  final String title;
  final String daysNumber;
  final int dayCount;
  final bool isLoading;
  final VoidCallback onTap;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        //borderRadius: BorderRadius.circular(14 * scale),
        onTap: isLoading ? null : onTap,
        child: Container(
          height: 110 * scale,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14 * scale),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 12 * scale,
                offset: Offset(0, 4 * scale),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 12 * scale,
            vertical: 18 * scale,
          ),
          child: Column(
            children: [
              Text(
                daysNumber.toUpperCase(),
                style: TextStyle(
                  fontSize: 10 * scale,
                  color: AppColors.grey500,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const Spacer(),

              isLoading
                  ? SpinKitThreeBounce(
                      color: AppColors.primary,
                      size: 24 * scale,
                    )
                  : Text(
                      dayCount.toString(),
                      style: TextStyle(
                        fontSize: 26 * scale,
                        fontWeight: FontWeight.w700,
                        color: AppColors.buttonPrimaryHover,
                        height: 1,
                      ),
                    ),

              const Spacer(),

              Text(
                title.toUpperCase(),
                style: TextStyle(
                  fontSize: 7 * scale,
                  color: AppColors.grey500,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
