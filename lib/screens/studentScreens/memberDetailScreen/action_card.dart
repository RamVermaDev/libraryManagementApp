import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/screens/studentScreens/memberDetailScreen/card_decoration.dart';
import 'package:library_management/screens/studentScreens/memberDetailScreen/action_item.dart';
import 'package:library_management/services/external_app_service.dart';

class ActionCard extends StatelessWidget {
  const ActionCard({
    super.key,
    required this.scale,
    required this.phone,
    required this.message,
  });
  final double scale;
  final String phone;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 105 * scale,
      decoration: cardDecoration(radius: 17 * scale),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Expanded(
            child: ActionItem(
              scale: scale,
              icon: Icons.phone_outlined,
              label: 'Call',
              color: AppColors.primary,
              onTap: () async {
                await ExternalAppService.makePhoneCall(phone);
              },
            ),
          ),

          _ActionDivider(scale: scale),

          Expanded(
            child: ActionItem(
              scale: scale,
              icon: Icons.chat_rounded,
              label: 'WhatsApp',
              color: AppColors.whatsapp,
              onTap: () async {
                await ExternalAppService.openWhatsApp(
                  phoneNumber: phone,
                  message: message,
                );
              },
            ),
          ),

          _ActionDivider(scale: scale),

          Expanded(
            child: ActionItem(
              scale: scale,
              icon: Icons.chat_bubble_outline_rounded,
              label: 'Message',
              color: AppColors.primary,
              onTap: () {},
            ),
          ),

          _ActionDivider(scale: scale),

          Expanded(
            child: ActionItem(
              scale: scale,
              icon: Icons.autorenew_rounded,
              label: 'Renew',
              color: AppColors.purple,
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionDivider extends StatelessWidget {
  final double scale;

  const _ActionDivider({required this.scale});

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 60 * scale, color: AppColors.divider);
  }
}
