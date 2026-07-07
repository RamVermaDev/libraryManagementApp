import 'package:flutter/material.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/member_color.dart';

class LoadingState extends StatelessWidget {
  const LoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: MembersColors.primary,
        strokeWidth: 2.5,
      ),
    );
  }
}
