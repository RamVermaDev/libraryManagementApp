import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.screenChange,
    required this.buttonText,
    required this.buttonRoutes,
    this.buttonIcon = false,
  });
  final Widget screenChange;
  final String buttonText;
  final bool buttonRoutes;
  final bool buttonIcon;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) {
                return screenChange;
              },
            ),
            (route) => buttonRoutes,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          textStyle: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(buttonText, style: TextStyle(fontSize: 16)),
            if (buttonIcon) ...[
              SizedBox(width: 10),
              Icon(Icons.arrow_right_alt),
            ],
          ],
        ),
      ),
    );
  }
}
