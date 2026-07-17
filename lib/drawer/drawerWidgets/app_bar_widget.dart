import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({
    super.key,
    required this.title,
    this.actionIcon,
    this.onActionPressed,
  });

  final String title;
  final IconData? actionIcon;
  final VoidCallback? onActionPressed;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      //centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
      ),
      actions: [
        ...(actionIcon != null
            ? [IconButton(onPressed: onActionPressed, icon: Icon(actionIcon))]
            : []),
      ],
    );
  }
}
