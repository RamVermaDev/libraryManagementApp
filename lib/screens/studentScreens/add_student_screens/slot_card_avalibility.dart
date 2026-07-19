import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';

class SlotCardAvalibility extends StatelessWidget {
  const SlotCardAvalibility({
    super.key,
    required this.scale,
    required this.time,
    required this.name,
    required this.price,
    required this.availableSeats,
    required this.isSelected,
    required this.onTap,
  });

  final double scale;

  final String time;
  final String name;
  final String price;

  final int availableSeats;

  final bool isSelected;

  final VoidCallback onTap;

  bool get isFull => availableSeats <= 0;

  @override
  Widget build(BuildContext context) {
    final Color primary = AppColors.buttonPrimary;

    final Color background = isSelected
        ? primary
        : isFull
        ? const Color(0xffF4F6FB)
        : Colors.white;

    final Color titleColor = isSelected
        ? Colors.white
        : isFull
        ? AppColors.grey700
        : AppColors.activeButtonText;

    final Color subtitleColor = isSelected
        ? Colors.white70
        : isFull
        ? Colors.grey
        : const Color(0xff667085);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      margin: EdgeInsets.only(bottom: 14 * scale),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(18 * scale),
        border: Border.all(
          color: isSelected ? Colors.white : const Color(0xffEAECF0),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18 * scale),
          onTap: isFull ? null : onTap,
          child: Padding(
            padding: EdgeInsets.all(18 * scale),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SlotTitle(
                        scale: scale,
                        time: time,
                        name: name,
                        titleColor: titleColor,
                        subtitleColor: subtitleColor,
                      ),

                      SizedBox(height: 12 * scale),

                      _SlotPrice(
                        scale: scale,
                        price: price,
                        selected: isSelected,
                        disabled: isFull,
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 12 * scale),

                _SlotStatusBadge(
                  scale: scale,
                  selected: isSelected,
                  seats: availableSeats,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SlotTitle extends StatelessWidget {
  const _SlotTitle({
    required this.scale,
    required this.time,
    required this.name,
    required this.titleColor,
    required this.subtitleColor,
  });

  final double scale;
  final String time;
  final String name;

  final Color titleColor;
  final Color subtitleColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          time,
          style: TextStyle(
            fontSize: 18 * scale,
            fontWeight: FontWeight.w700,
            color: titleColor,
          ),
        ),
        SizedBox(height: 4 * scale),
        Text(
          name,
          style: TextStyle(fontSize: 13 * scale, color: subtitleColor),
        ),
      ],
    );
  }
}

class _SlotPrice extends StatelessWidget {
  const _SlotPrice({
    required this.scale,
    required this.price,
    required this.selected,
    required this.disabled,
  });

  final double scale;
  final String price;
  final bool selected;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return Text(
      price,
      style: TextStyle(
        fontSize: 16 * scale,
        fontWeight: FontWeight.w700,
        color: disabled
            ? Colors.grey
            : selected
            ? Colors.white
            : const Color(0xff1657D9),
      ),
    );
  }
}

class _SlotStatusBadge extends StatelessWidget {
  const _SlotStatusBadge({
    required this.scale,
    required this.seats,
    required this.selected,
  });

  final double scale;
  final int seats;
  final bool selected;

  bool get isFull => seats <= 0;

  @override
  Widget build(BuildContext context) {
    return Text(
      isFull ? "Full" : "$seats seats left",
      textAlign: TextAlign.right,
      style: TextStyle(
        fontSize: 15 * scale,
        fontWeight: FontWeight.w600,
        color: isFull
            ? const Color(0xffF04438)
            : selected
            ? Colors.white
            : const Color(0xff525252),
      ),
    );
  }
}
