import 'package:flutter/material.dart';

class AmountDisplayField extends StatelessWidget {
  const AmountDisplayField({
    super.key,
    required this.amount,
    this.height = 52,
    this.padding = 18,
  });

  final double amount;
  final double height;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: EdgeInsets.symmetric(horizontal: padding),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          const Text(
            'Amount',
            style: TextStyle(fontSize: 18, color: Colors.black87),
          ),
          const Spacer(),
          Text(
            '₹${amount.toStringAsFixed(0)}',
            style: const TextStyle(fontSize: 18, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
