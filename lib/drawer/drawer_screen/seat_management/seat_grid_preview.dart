import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/models/seat_config_model.dart';

class SeatGridPreview extends StatefulWidget {
  final SeatConfigModel config;

  const SeatGridPreview({super.key, required this.config});

  @override
  State<SeatGridPreview> createState() => _SeatGridPreviewState();
}

class _SeatGridPreviewState extends State<SeatGridPreview> {
  int? _selectedSeatIndex;

  @override
  Widget build(BuildContext context) {
    final seats = widget.config.seats;
    final columns = widget.config.columns > 0 ? widget.config.columns : 5;
    final prefix = widget.config.prefix.trim().isNotEmpty
        ? widget.config.prefix.trim()
        : 'A';

    if (seats.isEmpty) {
      return Container(
        height: 180,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.event_seat_outlined, size: 42, color: Colors.grey.shade400),
            const SizedBox(height: 8),
            Text(
              'No seats configured yet',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header & Seat Count
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Layout Preview',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.heading,
                ),
              ),
              Text(
                '${seats.length} Total Seats',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Legend Bar: ONLY Seat and Selected
          Row(
            children: const [
              _LegendBadge(
                bgColor: Colors.white,
                borderColor: AppColors.border,
                dotColor: AppColors.body,
                label: 'Seat',
              ),
              SizedBox(width: 14),
              _LegendBadge(
                bgColor: AppColors.primarySoft,
                borderColor: AppColors.primary,
                dotColor: AppColors.primary,
                label: 'Selected',
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Seat Grid Display
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: seats.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.0,
            ),
            itemBuilder: (context, index) {
              final seatMap = seats[index] as Map<String, dynamic>;
              final number = seatMap['seatNumber'] ?? (index + 1);
              final rawLabel = seatMap['label']?.toString();

              final label = (rawLabel != null && rawLabel.isNotEmpty)
                  ? rawLabel
                  : (prefix.endsWith('-') ? '$prefix$number' : '$prefix-$number');

              final isSelected = _selectedSeatIndex == index;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (_selectedSeatIndex == index) {
                      _selectedSeatIndex = null;
                    } else {
                      _selectedSeatIndex = index;
                    }
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                      width: isSelected ? 2.0 : 1.2,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.event_seat_rounded,
                        size: 16,
                        color: isSelected ? Colors.white : AppColors.primary,
                      ),
                      const SizedBox(height: 2),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Text(
                            label,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: isSelected ? Colors.white : AppColors.heading,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _LegendBadge extends StatelessWidget {
  final Color bgColor;
  final Color borderColor;
  final Color dotColor;
  final String label;

  const _LegendBadge({
    required this.bgColor,
    required this.borderColor,
    required this.dotColor,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.heading,
            ),
          ),
        ],
      ),
    );
  }
}
