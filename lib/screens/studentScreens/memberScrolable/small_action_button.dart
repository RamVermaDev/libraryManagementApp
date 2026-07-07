import 'package:flutter/material.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/member_color.dart';

class SmallActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const SmallActionButton({super.key, 
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: MembersColors.surface,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: MembersColors.border,
            ),
          ),
          child: Icon(
            icon,
            size: 17,
            color: MembersColors.primary,
          ),
        ),
      ),
    );
  }
}