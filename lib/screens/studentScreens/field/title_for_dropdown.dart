import 'package:flutter/material.dart';

class TitleForDropdown extends StatelessWidget {
  const TitleForDropdown({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.left,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    );
  }
}
