import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({super.key, required this.title});

  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFD0E6FF),
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      actions: [
        IconButton(
          onPressed: () {
            // Add Library
          },
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
