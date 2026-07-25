import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';

class StudentDetailsBox extends StatelessWidget {
  const StudentDetailsBox({
    super.key,
    required this.scale,
    required this.name,
    required this.phone,
    required this.timming,
    required this.seatName,
    required this.planDays,
    required this.expireDate,
    required this.amount,
    required this.discount,
    required this.finalAmount,
    required this.pending,
    this.paymentMode,
  });

  final double scale;
  final String name;
  final String phone;
  final String timming;
  final String seatName;
  final int planDays;
  final DateTime expireDate;
  final double amount;
  final double discount;
  final double finalAmount;
  final double pending;
  final String? paymentMode;

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14 * scale),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(20 * scale),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.8)),
      ),
      child: Column(
        children: [
          // Student Name Item
          _OutlinedDetailItem(
            icon: Icons.person_outline_rounded,
            title: name,
            scale: scale,
            isHighlight: true,
          ),
          SizedBox(height: 8 * scale),

          // Phone Number
          _OutlinedDetailItem(
            icon: Icons.phone_outlined,
            title: phone,
            scale: scale,
          ),
          SizedBox(height: 8 * scale),

          // Slot Timing
          _OutlinedDetailItem(
            icon: Icons.schedule_outlined,
            title: timming,
            scale: scale,
          ),
          SizedBox(height: 8 * scale),

          // Assigned Seat
          _OutlinedDetailItem(
            icon: Icons.chair_outlined,
            title: seatName,
            scale: scale,
          ),
          SizedBox(height: 8 * scale),

          // Plan Duration & Expiry Date
          _OutlinedDetailItem(
            icon: Icons.calendar_today_outlined,
            title: '$planDays Days • Exp: ${_formatDate(expireDate)}',
            scale: scale,
          ),
          SizedBox(height: 12 * scale),

          // Amount & Fee Breakdown Card (NO ICON)
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 14 * scale,
              vertical: 12 * scale,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primary.withValues(alpha: 0.88),
                ],
              ),
              borderRadius: BorderRadius.circular(14 * scale),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                if (discount > 0) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Base Fee',
                        style: TextStyle(
                          fontSize: 12 * scale,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                      Text(
                        '₹ ${amount.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 12 * scale,
                          color: Colors.white.withValues(alpha: 0.8),
                          decoration: TextDecoration.lineThrough,
                          decorationColor: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2 * scale),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Discount',
                        style: TextStyle(
                          fontSize: 12 * scale,
                          color: Colors.greenAccent.shade100,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '- ₹ ${discount.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 12 * scale,
                          color: Colors.greenAccent.shade100,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    height: 10 * scale,
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ],

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Total Fee',
                        style: TextStyle(
                          fontSize: 14 * scale,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withValues(alpha: 0.95),
                        ),
                      ),
                    ),
                    Text(
                      '₹ ${finalAmount.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 17 * scale,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    if (paymentMode != null && paymentMode!.isNotEmpty) ...[
                      SizedBox(width: 10 * scale),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 9 * scale,
                          vertical: 3 * scale,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20 * scale),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          paymentMode!,
                          style: TextStyle(
                            fontSize: 11 * scale,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                if (pending > 0) ...[
                  SizedBox(height: 6 * scale),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pending Amount',
                        style: TextStyle(
                          fontSize: 11 * scale,
                          color: Colors.orangeAccent.shade100,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '₹ ${pending.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 12 * scale,
                          color: Colors.orangeAccent.shade100,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OutlinedDetailItem extends StatelessWidget {
  const _OutlinedDetailItem({
    required this.icon,
    required this.title,
    required this.scale,
    this.isHighlight = false,
  });

  final IconData icon;
  final String title;
  final double scale;
  final bool isHighlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12 * scale,
        vertical: 9 * scale,
      ),
      decoration: BoxDecoration(
        color: isHighlight
            ? AppColors.primary.withValues(alpha: 0.06)
            : Colors.white,
        borderRadius: BorderRadius.circular(12 * scale),
        border: Border.all(
          color: isHighlight
              ? AppColors.primary.withValues(alpha: 0.25)
              : AppColors.border.withValues(alpha: 0.7),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 19 * scale,
            color: isHighlight ? AppColors.primary : AppColors.grey700,
          ),
          SizedBox(width: 10 * scale),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14 * scale,
                fontWeight: isHighlight ? FontWeight.bold : FontWeight.w500,
                color: isHighlight ? AppColors.primary : AppColors.heading,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
