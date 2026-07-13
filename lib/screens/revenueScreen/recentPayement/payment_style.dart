import 'package:flutter/material.dart';

class PaymentMethodStyle {
  const PaymentMethodStyle({
    required this.icon,
    required this.color,
    required this.background,
  });

  final IconData icon;
  final Color color;
  final Color background;

  factory PaymentMethodStyle.from(String paymentMode) {
    switch (paymentMode) {
      case 'Cash':
        return const PaymentMethodStyle(
          icon: Icons.payments_outlined,
          color: Color(0xFF059669),
          background: Color(0xFFE8F8F1),
        );
      case 'Online':
        return const PaymentMethodStyle(
          icon: Icons.qr_code_2_rounded,
          color: Color(0xFF2563EB),
          background: Color(0xFFEAF1FF),
        );
      default:
        return const PaymentMethodStyle(
          icon: Icons.help_outline,
          color: Colors.grey,
          background: Color(0xFFF3F4F6),
        );
    }
  }
}
