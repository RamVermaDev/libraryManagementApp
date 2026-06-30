import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';

class TotalMemberButton extends StatelessWidget {
  const TotalMemberButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: double.infinity,
        height: 60,
        padding: EdgeInsets.fromLTRB(30, 4, 30, 4),
        decoration: BoxDecoration(
          color: AppColors.totalButton,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Icon(Icons.people, color: Colors.white, size: 25),
            SizedBox(width: 12),
            Text(
              'Total Members',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.1,
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: Text(
                  '100',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
