import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/models/payemnt_model.dart';
import 'package:library_management/screens/revenueScreen/recentPayement/payment_style.dart';
import 'package:library_management/screens/revenueScreen/revenue_formatters.dart';

class PaymentTile extends StatelessWidget {
  const PaymentTile({super.key, required this.payment, required this.scale});

  final PaymentModel payment;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final isRefund = payment.tracker == 'refund';
    final style = isRefund
        ? const PaymentMethodStyle(
            icon: Icons.undo_rounded,
            color: AppColors.error,
            background: AppColors.errorLight,
          )
        : PaymentMethodStyle.from(payment.paymentMode);

    final titleText = isRefund
        ? '${payment.paymentMode} (Refund)'
        : payment.paymentMode;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(
        children: [
          Container(
            width: 36 * scale,
            height: 36 * scale,
            decoration: BoxDecoration(
              color: style.background,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(style.icon, size: 22 * scale, color: style.color),
          ),
          SizedBox(width: 16 * scale),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titleText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14 * scale,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF101B33),
                  ),
                ),
                SizedBox(height: 2 * scale),
                Text(
                  DateFormatter.paymentDate(payment.paymentDate),
                  style: TextStyle(
                    fontSize: 11 * scale,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF747D93),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12 * scale),
          Text(
            '${isRefund ? "- " : ""}${CurrencyFormatter.format(payment.amount)}',
            style: TextStyle(
              fontSize: 15 * scale,
              fontWeight: FontWeight.w700,
              color: isRefund ? AppColors.error : AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}
