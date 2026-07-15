import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
    required this.scale,
  });

  final String title;
  final double? amount;
  final IconData icon;
  final Color color;
  final Color background;
  final Color? cardColor;

  final double scale;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16 * scale),
      decoration: AppCardDecoration.standard(cardColor: cardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 18 * scale, color: color),
              SizedBox(width: 8 * scale),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13 * scale,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6B7280),
                    letterSpacing: 0.1,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 12 * scale),

          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: amount == null
                ? SpinKitThreeBounce(color: color, size: 14 * scale)
                : Text(
                    CurrencyFormatter.format(amount!),
                    style: TextStyle(
                      fontSize: 18 * scale,
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
