import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';

class IconButtonStudent extends StatelessWidget {
  const IconButtonStudent({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 55,
          padding: EdgeInsets.fromLTRB(12, 4, 12, 4),
          decoration: BoxDecoration(
            color: AppColors.activeButton,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              SizedBox(width: 12),
              Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.1,
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
