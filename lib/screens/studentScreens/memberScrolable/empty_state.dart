import 'package:flutter/material.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/member_color.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/todelete.dart';

class EmptyState extends StatelessWidget {
  final MemberStatus status;

  const EmptyState({super.key, 
    required this.status,
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
              width: 68,
              height: 68,
              decoration: const BoxDecoration(
                color: MembersColors.primarySoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.people_outline_rounded,
                color: MembersColors.primary,
                size: 30,
              ),
            ),

            const SizedBox(height: 18),

            Text(
              'No ${status.label.toLowerCase()} members',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: MembersColors.heading,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 7),

            const Text(
              'Members will appear here when available.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: MembersColors.muted,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}