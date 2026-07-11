import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/screens/studentScreens/memberDetailScreen/card_decoration.dart';
import 'package:library_management/screens/studentScreens/memberDetailScreen/payement_row.dart';

class PaymentCard extends StatelessWidget {
  final double scale;

  const PaymentCard({
    super.key,
    required this.scale,
    required this.amount,
    required this.discount,
    required this.pending,
  });

  final String amount;
  final String discount;
  final String pending;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: cardDecoration(radius: 18 * scale),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          PaymentRow(
            scale: scale,
            label: 'Amount',
            value: '₹$amount/-',
            labelColor: AppColors.primary,
          ),

          Container(height: 1, color: AppColors.divider),

          PaymentRow(
            scale: scale,
            label: 'Discount',
            value: '₹$discount/-',
            labelColor: AppColors.success,
          ),

          PaymentRow(
            scale: scale,
            label: 'Pending',
            value: '₹$pending/-',
            labelColor: AppColors.error,
            valueColor: AppColors.error,
            backgroundColor: AppColors.errorLight,
          ),
        ],
      ),
    );
  }
}
