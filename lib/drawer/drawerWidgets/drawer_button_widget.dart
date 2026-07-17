import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';

class DrawerButtonWidget extends StatelessWidget {
  const DrawerButtonWidget({
    super.key,
    required this.screenChange,
    required this.buttonText,
    required this.buttonIcon,
    this.buttonRoutes = true,
    this.pop = false,
  });
  final Widget screenChange;
  final String buttonText;
  final bool buttonRoutes;
  final IconData buttonIcon;
  final bool pop;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.buttonPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: () {
          if (!pop) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => screenChange),
              (route) => buttonRoutes,
            );
          } else {
            Navigator.pop(context);
          }
        },
        icon: Icon(buttonIcon),
        label: Text(buttonText),
      ),
    );
  }
}
