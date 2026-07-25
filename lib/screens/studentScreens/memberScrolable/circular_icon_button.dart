import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';

class CircularIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const CircularIconButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, size: 22, color: AppColors.heading),
        ),
      ),
    );
  }
}
