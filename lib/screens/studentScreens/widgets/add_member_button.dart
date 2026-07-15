import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/screens/studentScreens/add_student_screen.dart';

class AddMemberButton extends StatelessWidget {
  const AddMemberButton({super.key, required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        //borderRadius: BorderRadius.circular(12 * scale),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddStudentScreen()),
          );
        },
        child: Container(
          height: 55 * scale,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(14 * scale),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 14 * scale,
                offset: Offset(0, 4 * scale),
              ),
            ],
          ),
          child: Stack(
            children: [
              /// Center Text
              Center(
                child: Text(
                  'Add Member',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16 * scale,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.1 * scale,
                  ),
                ),
              ),

              /// Bottom Right Plus Icon
              Positioned(
                right: 12 * scale,
                bottom: 10 * scale,
                child: Icon(Icons.add, color: Colors.white, size: 14 * scale),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
