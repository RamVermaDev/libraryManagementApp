import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/members.dart';

class EmptyState extends StatelessWidget {
  final MemberStatus status;
  final String? title;
  final String? subtitle;

  const EmptyState({
    super.key,
    required this.status,
    this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: AppColors.primarySoft,
                shape: BoxShape.circle,
              ),
              child: Icon(
                title != null ? Icons.search_off_rounded : Icons.people_outline_rounded,
                color: AppColors.primary,
                size: 28,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              title ?? 'No ${status.label.toLowerCase()} members',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.heading,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              subtitle ?? (title != null ? 'Try a different name or phone number' : 'Members will appear here when available.'),
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.grey300, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
