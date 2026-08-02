import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';

class DrawerList extends StatelessWidget {
  const DrawerList({super.key, required this.menuItems});

  final List<Map<String, dynamic>> menuItems;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: menuItems.length,
      separatorBuilder: (_, __) => const Divider(
        height: 1,
        thickness: 1,
        color: AppColors.border,
        indent: 52,
      ),
      itemBuilder: (context, index) {
        final tile = menuItems[index];

        return ListTile(
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
          leading: Icon(
            tile['icon'] as IconData,
            color: AppColors.heading,
            size: 22,
          ),
          title: Text(
            tile['title'] as String,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.heading,
            ),
          ),
          trailing: const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.caption,
            size: 20,
          ),
          onTap: () {
            Navigator.pop(context); // Close drawer
            Navigator.pushNamed(context, tile['route'] as String);
          },
        );
      },
    );
  }
}
