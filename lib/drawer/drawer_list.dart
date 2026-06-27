import 'package:flutter/material.dart';

class DrawerList extends StatelessWidget {
  const DrawerList({super.key, required this.menuItems});

  final List<Map<String, dynamic>> menuItems;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          final tile = menuItems[index];

          return ListTile(
            leading: Icon(tile['icon'] as IconData),
            title: Text(tile['title'] as String),
            onTap: () {
              Navigator.pop(context); // Close drawer

              Navigator.pushNamed(context, tile['route'] as String);
            },
          );
        },
      ),
    );
  }
}
