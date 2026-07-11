import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/screens/revenueScreen/recentPayement/payment_style.dart';
import 'package:library_management/screens/revenueScreen/payement_item.dart';
import 'package:library_management/screens/revenueScreen/revenue_formatters.dart';

class PaymentTile extends StatelessWidget {
  const PaymentTile({super.key, required this.payment});

  final PaymentItem payment;

  @override
  Widget build(BuildContext context) {
    final style = PaymentMethodStyle.from(payment.paymentMethod);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: style.background,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(style.icon, size: 22, color: style.color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  PaymentFormatter.method(payment.paymentMethod),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF101B33),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  DateFormatter.paymentDate(payment.paidAt),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF747D93),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            CurrencyFormatter.format(payment.amount),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}
