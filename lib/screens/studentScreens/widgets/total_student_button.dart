import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';

class TotalStudentButton extends StatelessWidget {
  const TotalStudentButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 55,
        padding: EdgeInsets.fromLTRB(12, 4, 12, 4),
        decoration: BoxDecoration(
          color: AppColors.totalButton,
          borderRadius: BorderRadius.circular(4),
        ),
        alignment: Alignment.center,

        child: Text(
          'Total Members',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
