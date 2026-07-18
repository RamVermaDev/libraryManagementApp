import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';

class LibraryAvatar extends StatelessWidget {
  const LibraryAvatar({super.key, required this.title, this.scale = 1});

  final String title;
  final double scale;

  String get initials {
    final words = title.trim().split(RegExp(r'\s+'));

    if (words.isEmpty) return "L";

    if (words.length == 1) {
      return words.first[0].toUpperCase();
    }

    return (words.first[0] + words.last[0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65 * scale,
      width: 65 * scale,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.buttonPrimary,

        boxShadow: [
          BoxShadow(
            color: const Color(0xff2F6BFF).withValues(alpha: .30),
            blurRadius: 8,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20 * scale,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
