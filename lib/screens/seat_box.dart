import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/models/seat_availability_model.dart';

class SeatBox extends StatelessWidget {
  const SeatBox({
    super.key,
    required this.seat,
    required this.isSelected,
    required this.onTap,
  });

  final SeatAvailabilityModel seat;
  final bool isSelected;
  final VoidCallback onTap;

  bool get _isBooked => !seat.isAvailable;

  @override
  Widget build(BuildContext context) {
    final Color primary = AppColors.buttonPrimary;

    final Color background = isSelected
        ? primary
        : _isBooked
        ? const Color(0xffF4F6FB)
        : Colors.white;

    final Color textColor = isSelected
        ? Colors.white
        : _isBooked
        ? Colors.grey.shade400
        : AppColors.activeButtonText;

    final Color borderColor = isSelected
        ? primary
        : _isBooked
        ? const Color(0xffEAECF0)
        : const Color(0xffD0D5DD);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: _isBooked ? null : onTap,
        child: Container(
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor, width: 1.2),
          ),
          alignment: Alignment.center,
          child: Text(
            seat.displayLabel,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}

/// The small "Available / Booked / Selected" color-key row shown above the grid.
class SeatLegend extends StatelessWidget {
  const SeatLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        _LegendItem(
          color: Colors.white,
          borderColor: Color(0xffD0D5DD),
          label: 'Available',
        ),
        SizedBox(width: 16),
        _LegendItem(
          color: Color(0xffF4F6FB),
          borderColor: Color(0xffEAECF0),
          label: 'Booked',
        ),
        SizedBox(width: 16),
        _LegendItem(
          color: AppColors.buttonPrimary,
          borderColor: AppColors.buttonPrimary,
          label: 'Selected',
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.borderColor,
    required this.label,
  });

  final Color color;
  final Color borderColor;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: borderColor),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
