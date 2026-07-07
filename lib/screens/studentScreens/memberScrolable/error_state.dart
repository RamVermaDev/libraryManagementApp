import 'package:flutter/material.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/member_color.dart';

class ErrorState extends StatelessWidget {
  final VoidCallback onRetry;

  const ErrorState({super.key, 
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 42,
              color: MembersColors.expired,
            ),

            const SizedBox(height: 14),

            const Text(
              'Could not load members',
              style: TextStyle(
                color: MembersColors.heading,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 16),

            FilledButton(
              onPressed: onRetry,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}