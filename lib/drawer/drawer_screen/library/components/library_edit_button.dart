import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';

class LibraryEditButton extends StatelessWidget {
  const LibraryEditButton({super.key, required this.onTap, this.scale = 1});

  final VoidCallback onTap;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Ink(
          height: 32 * scale,
          width: 32 * scale,
          decoration: BoxDecoration(
            color: AppColors.grey100,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            Icons.edit_outlined,
            size: 16 * scale,
            color: Colors.grey.shade700,
          ),
        ),
      ),
    );
  }
}
