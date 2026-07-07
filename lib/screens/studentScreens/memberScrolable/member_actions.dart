import 'package:flutter/material.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/small_action_button.dart';

class MemberActions extends StatelessWidget {
  final VoidCallback onCall;
  final VoidCallback onMessage;

  const MemberActions({super.key, 
    required this.onCall,
    required this.onMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SmallActionButton(
          icon: Icons.phone_outlined,
          onTap: onCall,
        ),

        const SizedBox(height: 8),

        SmallActionButton(
          icon: Icons.chat_bubble_outline_rounded,
          onTap: onMessage,
        ),
      ],
    );
  }
}