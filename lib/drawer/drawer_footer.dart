import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/drawer/drawer_screen/profile/logout_confirmation_dialog.dart';

class DrawerFooter extends ConsumerWidget {
  const DrawerFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(height: 1, thickness: 1, color: AppColors.border),
        ListTile(
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
          leading: const Icon(
            Icons.logout_rounded,
            color: AppColors.heading,
            size: 22,
          ),
          title: const Text(
            'Log out',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.heading,
            ),
          ),
          onTap: () {
            Navigator.pop(context); // Close drawer
            showLogoutConfirmationDialog(context: context, ref: ref);
          },
        ),
        const SizedBox(height: 24),
        const Text(
          'Version 1.0.0+1',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.caption,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
