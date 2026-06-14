import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';

class AppLogoHeader extends StatelessWidget {
  const AppLogoHeader({
    super.key,
    required this.logoSize,
    this.heading = 'MY LIBRARY PRO',
    this.subHeading = 'Your Library Organized',
  });

  final double logoSize;
  final String heading;
  final String subHeading;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/library_logo.png',
          height: logoSize,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 18),
        Text(
          heading,
          textAlign: TextAlign.center,
          style: textTheme.headlineMedium?.copyWith(
            color: AppColors.heading,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subHeading,
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(color: AppColors.body),
        ),
      ],
    );
  }
}
