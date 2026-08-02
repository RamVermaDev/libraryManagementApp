import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/drawer/drawer_footer.dart';
import 'package:library_management/drawer/drawer_heading.dart';
import 'package:library_management/drawer/drawer_list.dart';

class DrawerLayout extends StatelessWidget {
  DrawerLayout({super.key});

  final menuItems = [
    {
      'icon': Icons.person_outline_rounded,
      'title': 'Profile',
      'route': '/profile',
    },
    {
      'icon': Icons.local_library_outlined,
      'title': 'Library',
      'route': '/library',
    },
    {
      'icon': Icons.subscriptions_outlined,
      'title': 'Subscription',
      'route': '/subscription',
    },
    {
      'icon': Icons.assignment_ind_outlined,
      'title': 'Slot Setup',
      'route': '/slot',
    },
    {
      'icon': Icons.event_seat_outlined,
      'title': 'Available Seat',
      'route': '/seat',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.78,
      backgroundColor: AppColors.surface,
      elevation: 4,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: SafeArea(
        child: Column(
          children: [
            const DrawerHeading(),
            const Divider(height: 1, thickness: 1, color: AppColors.border),
            Expanded(child: DrawerList(menuItems: menuItems)),
            const DrawerFooter(),
          ],
        ),
      ),
    );
  }
}
