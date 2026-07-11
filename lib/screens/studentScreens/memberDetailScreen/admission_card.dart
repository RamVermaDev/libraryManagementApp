import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/screens/studentScreens/memberDetailScreen/card_decoration.dart';

class AdmissionsCard extends StatelessWidget {
  final double scale;

  const AdmissionsCard({super.key, required this.scale});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(18 * scale);

    return Container(
      decoration: cardDecoration(radius: 18 * scale),
      child: Material(
        color: Colors.white,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {},
          child: SizedBox(
            height: 76 * scale,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20 * scale),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Admissions',
                      style: TextStyle(
                        color: AppColors.heading,
                        fontSize: 19 * scale,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 19 * scale,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
