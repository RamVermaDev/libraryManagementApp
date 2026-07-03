import 'package:flutter/material.dart';

class StudentDetailPaymentContainer extends StatelessWidget {
  const StudentDetailPaymentContainer({
    super.key,
    required this.title,
    required this.amount,
    this.containerColor = Colors.white,
  });

  final String title;
  final String amount;
  final Color containerColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: containerColor,
        border: Border.all(width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsetsGeometry.fromLTRB(25, 2, 25, 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Text(amount, style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
