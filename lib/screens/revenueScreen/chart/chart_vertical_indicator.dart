import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';

class ChartVerticalIndicator extends StatelessWidget {
  const ChartVerticalIndicator({super.key, required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: CustomPaint(painter: _DashedPainter()),
    );
  }
}

class _DashedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withOpacity(.25)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    const dashHeight = 5.0;
    const dashSpace = 5.0;

    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashHeight),
        paint,
      );

      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
