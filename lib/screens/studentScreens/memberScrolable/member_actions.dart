import 'package:flutter/material.dart';
import 'package:library_management/services/external_app_service.dart';

class MemberActions extends StatelessWidget {
  const MemberActions({
    super.key,
    required this.number,
    required this.message,
  });

  final String number;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Call Button
        _ActionButton(
          icon: Icons.phone_rounded,
          backgroundColor: const Color(0xFFEFF6FF),
          iconColor: const Color(0xFF1D4ED8),
          onTap: () async {
            await ExternalAppService.makePhoneCall(number);
          },
        ),

        const SizedBox(width: 8),

        // SMS Message Button
        _ActionButton(
          icon: Icons.chat_bubble_outline_rounded,
          backgroundColor: const Color(0xFFEFF6FF),
          iconColor: const Color(0xFF1D4ED8),
          onTap: () async {
            await ExternalAppService.sendSms(
              phoneNumber: number,
              message: message,
            );
          },
        ),

        const SizedBox(width: 8),

        // WhatsApp Button
        _ActionButton(
          assetPath: 'assets/icons/whatsapp.png',
          icon: Icons.message_rounded,
          backgroundColor: const Color(0xFFE8F5E9),
          iconColor: const Color(0xFF2E7D32),
          onTap: () async {
            await ExternalAppService.openWhatsApp(
              phoneNumber: number,
              message: message,
            );
          },
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.backgroundColor,
    required this.iconColor,
    required this.onTap,
    this.icon,
    this.assetPath,
  });

  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback onTap;
  final IconData? icon;
  final String? assetPath;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 38,
          height: 38,
          child: Center(
            child: assetPath != null
                ? Image.asset(
                    assetPath!,
                    width: 20,
                    height: 20,
                    color: iconColor,
                    errorBuilder: (_, __, ___) => Icon(
                      icon ?? Icons.message_rounded,
                      size: 19,
                      color: iconColor,
                    ),
                  )
                : Icon(
                    icon,
                    size: 19,
                    color: iconColor,
                  ),
          ),
        ),
      ),
    );
  }
}
