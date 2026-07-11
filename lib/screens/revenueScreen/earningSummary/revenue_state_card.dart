import 'package:flutter/material.dart';
import 'package:library_management/screens/revenueScreen/revenue_card_decoration.dart';
import 'package:library_management/screens/revenueScreen/revenue_formatters.dart';

class RevenueStatCard extends StatelessWidget {
  const RevenueStatCard({
    super.key,
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
    required this.background,
    this.cardColor,
  });

  final String title;
  final double amount;
  final IconData icon;
  final Color color;
  final Color background;
  final Color? cardColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppCardDecoration.standard(cardColor: cardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6B7280),
                    letterSpacing: 0.1,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              CurrencyFormatter.format(amount),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
                letterSpacing: -0.4,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
