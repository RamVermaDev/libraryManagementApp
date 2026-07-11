import 'package:flutter/material.dart';
import 'package:library_management/services/external_app_service.dart';

class MemberActions extends StatelessWidget {
  const MemberActions({super.key, required this.number, required this.message});

  final String number;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ActionIcon(
          assetPath: 'assets/icons/call.png',
          onTap: () async {
            await ExternalAppService.makePhoneCall(number);
          },
        ),

        const SizedBox(height: 4),

        _ActionIcon(
          assetPath: 'assets/icons/whatsapp.png',
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

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({required this.assetPath, required this.onTap});

  final String assetPath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        width: 42,
        height: 42,
        child: Center(
          child: Image.asset(
            assetPath,
            width: 25,
            height: 25,
            color: const Color(0xFF7D8796),
          ),
        ),
      ),
    );
  }
}
