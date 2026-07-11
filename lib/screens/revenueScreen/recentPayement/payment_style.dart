import 'package:flutter/material.dart';
import 'package:library_management/screens/revenueScreen/payement_item.dart';

class PaymentMethodStyle {
  const PaymentMethodStyle({
    required this.icon,
    required this.color,
    required this.background,
  });

  final IconData icon;
  final Color color;
  final Color background;

  factory PaymentMethodStyle.from(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return const PaymentMethodStyle(
          icon: Icons.payments_outlined,
          color: Color(0xFF059669),
          background: Color(0xFFE8F8F1),
        );
      case PaymentMethod.upi:
        return const PaymentMethodStyle(
          icon: Icons.qr_code_2_rounded,
          color: Color(0xFF2563EB),
          background: Color(0xFFEAF1FF),
        );
      case PaymentMethod.bankTransfer:
        return const PaymentMethodStyle(
          icon: Icons.account_balance_outlined,
          color: Color(0xFF9A6718),
          background: Color(0xFFFFF5DE),
        );
    }
  }
}

class PaymentFormatter {
  static String method(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.upi:
        return 'UPI';
      case PaymentMethod.bankTransfer:
        return 'Bank transfer';
    }
  }
}
