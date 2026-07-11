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
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          textStyle: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
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
