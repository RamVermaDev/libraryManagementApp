// class EarningsTrendCard extends StatelessWidget {
//   const EarningsTrendCard({
//     super.key,
//     required this.selectedMonth,
//     required this.values,
//     required this.selectedPeriod,
//     required this.onPeriodChanged,
//   });

//   final DateTime selectedMonth;
//   final List<double> values;
//   final TrendPeriod selectedPeriod;
//   final ValueChanged<TrendPeriod> onPeriodChanged;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
//       decoration: AppCardDecoration.standard(),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               const Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Earnings trend',
//                       style: TextStyle(
//                         color: AppColors.heading,
//                         fontSize: 17,
//                         fontWeight: FontWeight.w700,
//                         letterSpacing: -0.4,
//                       ),
//                     ),
//                     SizedBox(height: 4),
//                     Text(
//                       'Income activity over time',
//                       style: TextStyle(
//                         color: AppColors.caption,
//                         fontSize: 12,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               TrendPeriodSelector(
//                 selectedPeriod: selectedPeriod,
//                 onChanged: onPeriodChanged,
//               ),
//             ],
//           ),

//           const SizedBox(height: 24),

//           EarningsLineChart(
//             values: values,
//             selectedMonth: selectedMonth,
//             selectedPeriod: selectedPeriod,
//           ),

//           const SizedBox(height: 14),

//           const ChartLegend(),
//         ],
//       ),
//     );
//   }
// }

// // ============================================================
// // TREND PERIOD SELECTOR
// // ============================================================

// class TrendPeriodSelector extends StatelessWidget {
//   const TrendPeriodSelector({
//     super.key,
//     required this.selectedPeriod,
//     required this.onChanged,
//   });

//   final TrendPeriod selectedPeriod;
//   final ValueChanged<TrendPeriod> onChanged;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 36,
//       padding: const EdgeInsets.all(3),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF3F5F8),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           TrendPeriodButton(
//             label: '30D',
//             isSelected: selectedPeriod == TrendPeriod.thirtyDays,
//             onTap: () {
//               onChanged(TrendPeriod.thirtyDays);
//             },
//           ),

//           TrendPeriodButton(
//             label: '12M',
//             isSelected: selectedPeriod == TrendPeriod.twelveMonths,
//             onTap: () {
//               onChanged(TrendPeriod.twelveMonths);
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ============================================================
// // TREND PERIOD BUTTON
// // ============================================================

// class TrendPeriodButton extends StatelessWidget {
//   const TrendPeriodButton({
//     super.key,
//     required this.label,
//     required this.isSelected,
//     required this.onTap,
//   });

//   final String label;
//   final bool isSelected;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 180),
//       curve: Curves.easeOut,
//       decoration: BoxDecoration(
//         color: isSelected ? AppColors.card : Colors.transparent,
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: isSelected
//             ? const [
//                 BoxShadow(
//                   color: Color(0x0D0F172A),
//                   blurRadius: 5,
//                   offset: Offset(0, 1),
//                 ),
//               ]
//             : null,
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(8),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
//             child: Text(
//               label,
//               style: TextStyle(
//                 color: isSelected ? AppColors.primary : AppColors.caption,
//                 fontSize: 11,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ============================================================
// // EARNINGS LINE CHART
// // ============================================================

// class EarningsLineChart extends StatelessWidget {
//   const EarningsLineChart({
//     super.key,
//     required this.values,
//     required this.selectedMonth,
//     required this.selectedPeriod,
//   });

//   final List<double> values;
//   final DateTime selectedMonth;
//   final TrendPeriod selectedPeriod;

//   @override
//   Widget build(BuildContext context) {
//     if (values.isEmpty) {
//       return const SizedBox(
//         height: 190,
//         child: Center(
//           child: Text(
//             'No earnings data',
//             style: TextStyle(
//               color: AppColors.caption,
//               fontSize: 13,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ),
//       );
//     }

//     return SizedBox(
//       width: double.infinity,
//       height: 190,
//       child: CustomPaint(
//         painter: EarningsChartPainter(
//           values: values,
//           selectedMonth: selectedMonth,
//           selectedPeriod: selectedPeriod,
//         ),
//       ),
//     );
//   }
// }

// // ============================================================
// // CHART PAINTER
// // ============================================================

// class EarningsChartPainter extends CustomPainter {
//   const EarningsChartPainter({
//     required this.values,
//     required this.selectedMonth,
//     required this.selectedPeriod,
//   });

//   final List<double> values;
//   final DateTime selectedMonth;
//   final TrendPeriod selectedPeriod;

//   static const double _leftPadding = 42;
//   static const double _rightPadding = 8;
//   static const double _topPadding = 12;
//   static const double _bottomPadding = 28;

//   @override
//   void paint(Canvas canvas, Size size) {
//     if (values.length < 2) return;

//     final chartWidth = size.width - _leftPadding - _rightPadding;

//     final chartHeight = size.height - _topPadding - _bottomPadding;

//     final maxValue = values.reduce(
//       (current, next) => current > next ? current : next,
//     );

//     final chartMax = _calculateChartMax(maxValue);

//     _drawGrid(canvas, size, chartHeight, chartMax);

//     _drawChartLine(canvas, chartWidth, chartHeight, chartMax);

//     _drawXAxisLabels(canvas, size, chartWidth);
//   }

//   double _calculateChartMax(double maxValue) {
//     if (maxValue <= 0) return 1000;

//     final padded = maxValue * 1.25;

//     if (padded <= 1000) return 1000;
//     if (padded <= 2000) return 2000;
//     if (padded <= 5000) return 5000;
//     if (padded <= 10000) return 10000;

//     return padded;
//   }

//   void _drawGrid(
//     Canvas canvas,
//     Size size,
//     double chartHeight,
//     double chartMax,
//   ) {
//     final gridPaint = Paint()
//       ..color = const Color(0xFFECEF3F4)
//       ..strokeWidth = 1;

//     const lineCount = 4;

//     for (int i = 0; i < lineCount; i++) {
//       final progress = i / (lineCount - 1);

//       final y = _topPadding + (chartHeight * progress);

//       canvas.drawLine(
//         Offset(_leftPadding, y),
//         Offset(size.width - _rightPadding, y),
//         gridPaint,
//       );

//       final value = chartMax - (chartMax * progress);

//       _drawText(
//         canvas: canvas,
//         text: CurrencyFormatter.compact(value),
//         offset: Offset(0, y - 6),
//         fontSize: 9,
//         color: AppColors.caption,
//       );
//     }
//   }

//   void _drawChartLine(
//     Canvas canvas,
//     double chartWidth,
//     double chartHeight,
//     double chartMax,
//   ) {
//     final linePaint = Paint()
//       ..color = AppColors.primary
//       ..strokeWidth = 2.5
//       ..strokeCap = StrokeCap.round
//       ..strokeJoin = StrokeJoin.round
//       ..style = PaintingStyle.stroke;

//     final fillPaint = Paint()
//       ..shader =
//           LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               AppColors.primary.withValues(alpha: 0.14),
//               AppColors.primary.withValues(alpha: 0),
//             ],
//           ).createShader(
//             Rect.fromLTWH(_leftPadding, _topPadding, chartWidth, chartHeight),
//           );

//     final linePath = Path();
//     final fillPath = Path();

//     final points = <Offset>[];

//     for (int i = 0; i < values.length; i++) {
//       final x = _leftPadding + (chartWidth / (values.length - 1)) * i;

//       final normalized = (values[i] / chartMax).clamp(0.0, 1.0);

//       final y = _topPadding + chartHeight - (normalized * chartHeight);

//       points.add(Offset(x, y));
//     }

//     linePath.moveTo(points.first.dx, points.first.dy);

//     fillPath.moveTo(points.first.dx, _topPadding + chartHeight);

//     fillPath.lineTo(points.first.dx, points.first.dy);

//     for (int i = 1; i < points.length; i++) {
//       final previous = points[i - 1];
//       final current = points[i];

//       final controlX = (previous.dx + current.dx) / 2;

//       linePath.cubicTo(
//         controlX,
//         previous.dy,
//         controlX,
//         current.dy,
//         current.dx,
//         current.dy,
//       );

//       fillPath.cubicTo(
//         controlX,
//         previous.dy,
//         controlX,
//         current.dy,
//         current.dx,
//         current.dy,
//       );
//     }

//     fillPath.lineTo(points.last.dx, _topPadding + chartHeight);

//     fillPath.close();

//     canvas.drawPath(fillPath, fillPaint);
//     canvas.drawPath(linePath, linePaint);

//     _drawLatestPoint(canvas, points);
//   }

//   void _drawLatestPoint(Canvas canvas, List<Offset> points) {
//     int lastIndex = values.length - 1;

//     while (lastIndex > 0 && values[lastIndex] == 0) {
//       lastIndex--;
//     }

//     if (values[lastIndex] == 0) return;

//     final point = points[lastIndex];

//     canvas.drawCircle(point, 6, Paint()..color = AppColors.card);

//     canvas.drawCircle(point, 3.5, Paint()..color = AppColors.primary);
//   }

//   void _drawXAxisLabels(Canvas canvas, Size size, double chartWidth) {
//     final indexes = selectedPeriod == TrendPeriod.thirtyDays
//         ? <int>[
//             0,
//             (values.length * 0.25).floor(),
//             (values.length * 0.50).floor(),
//             (values.length * 0.75).floor(),
//             values.length - 1,
//           ]
//         : <int>[0, 2, 5, 8, 11];

//     for (final index in indexes.toSet()) {
//       final safeIndex = index.clamp(0, values.length - 1);
//       final x = _leftPadding + (chartWidth / (values.length - 1)) * safeIndex;

//       final label = selectedPeriod == TrendPeriod.thirtyDays
//           ? '${safeIndex + 1} ${DateFormatter.shortMonth(selectedMonth.month)}'
//           : DateFormatter.shortMonth(safeIndex + 1);

//       final painter = TextPainter(
//         text: TextSpan(
//           text: label,
//           style: const TextStyle(
//             color: AppColors.caption,
//             fontSize: 9,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         textDirection: TextDirection.ltr,
//       )..layout();

//       painter.paint(
//         canvas,
//         Offset(
//           (x - painter.width / 2).clamp(
//             _leftPadding - 8,
//             size.width - _rightPadding - painter.width,
//           ),
//           size.height - 16,
//         ),
//       );
//     }
//   }

//   void _drawText({
//     required Canvas canvas,
//     required String text,
//     required Offset offset,
//     required double fontSize,
//     required Color color,
//   }) {
//     final painter = TextPainter(
//       text: TextSpan(
//         text: text,
//         style: TextStyle(
//           color: color,
//           fontSize: fontSize,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//       textDirection: TextDirection.ltr,
//     )..layout();

//     painter.paint(canvas, offset);
//   }

//   @override
//   bool shouldRepaint(covariant EarningsChartPainter oldDelegate) {
//     return oldDelegate.values != values ||
//         oldDelegate.selectedMonth != selectedMonth ||
//         oldDelegate.selectedPeriod != selectedPeriod;
//   }
// }

// // ============================================================
// // CHART LEGEND
// // ============================================================

// class ChartLegend extends StatelessWidget {
//   const ChartLegend({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           width: 8,
//           height: 8,
//           decoration: const BoxDecoration(
//             color: AppColors.primary,
//             shape: BoxShape.circle,
//           ),
//         ),

//         const SizedBox(width: 7),

//         const Text(
//           'Total earnings',
//           style: TextStyle(
//             color: AppColors.body,
//             fontSize: 11,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ],
//     );
//   }
// }
