import 'package:flutter/material.dart';
import 'package:library_management/drawer/drawer_footer.dart';
import 'package:library_management/drawer/drawer_heading.dart';
import 'package:library_management/drawer/drawer_list.dart';

class DrawerLayout extends StatelessWidget {
  DrawerLayout({super.key});

  final menuItems = [
    {
      'icon': Icons.person_2_outlined,
      'title': 'My Profile',
      'route': '/profile',
    },
    {
      'icon': Icons.local_library_outlined,
      'title': 'My Library',
      'route': '/library',
    },
    {
      'icon': Icons.subscriptions_outlined,
      'title': 'Subscription',
      'route': '/subscription',
    },
    {
      'icon': Icons.payment_outlined,
      'title': 'Enrolement Fee',
      'route': '/enrolement',
    },
    {
      'icon': Icons.assignment_ind_outlined,
      'title': 'Plan Setup',
      'route': '/plan',
    },
    {
      'icon': Icons.schedule_outlined,
      'title': 'Program Setup',
      'route': '/program',
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
      width: MediaQuery.of(context).size.width * 0.7,
      backgroundColor: Color(0xFFD0E6FF),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DrawerHeading(libraryName: 'SVADHYAYA LIBRARY'),
            Divider(thickness: 1),
            DrawerList(menuItems: menuItems),
            DrawerFooter(),
          ],
        ),
      ),
    );
  }
}
