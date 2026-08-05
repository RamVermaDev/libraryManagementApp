import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/app_notification.dart';
import 'package:library_management/provider/app_mode_provider.dart';

class DrawerList extends ConsumerWidget {
  const DrawerList({super.key, required this.menuItems});

  final List<Map<String, dynamic>> menuItems;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appMode = ref.watch(appModeProvider);
    final isGeneralMode = appMode == AppMode.general;

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
        final route = tile['route'] as String;
        final title = tile['title'] as String;

        final isReceptionMode = appMode == AppMode.reception;

        final isLocked = (isGeneralMode && route != '/profile') ||
            (isReceptionMode && (route == '/library' || route == '/subscription'));

        return ListTile(
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
          leading: Icon(
            tile['icon'] as IconData,
            color: isLocked ? Colors.grey.shade400 : AppColors.heading,
            size: 22,
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isLocked ? Colors.grey.shade400 : AppColors.heading,
            ),
          ),
          trailing: Icon(
            isLocked ? Icons.lock_rounded : Icons.chevron_right_rounded,
            color: isLocked ? Colors.grey.shade400 : AppColors.caption,
            size: isLocked ? 15 : 20,
          ),
          onTap: () {
            if (isLocked) {
              final modeLabel = isGeneralMode ? 'General' : 'Receptionist';
              AppNotification.show(
                context,
                message: '$title is locked in $modeLabel mode',
              );
              return;
            }
            Navigator.pop(context); // Close drawer
            Navigator.pushNamed(context, route);
          },
        );
      },
    );
  }
}
