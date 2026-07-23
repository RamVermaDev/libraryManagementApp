import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';

class SlotCardSelected extends StatelessWidget {
  const SlotCardSelected({
    super.key,
    required this.scale,
    required this.time,
    required this.name,
    required this.price,
    required this.availableSeats,
    required this.isSelected,
  });

  final double scale;

  final String time;
  final String name;
  final String price;

  final int availableSeats;

  final bool isSelected;

  bool get isFull => availableSeats <= 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.buttonPrimary,
        borderRadius: BorderRadius.circular(10 * scale),
        border: Border.all(color: AppColors.buttonPrimary, width: 0.4),
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),

          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SlotTitle(scale: scale, time: time, name: name),

                    SizedBox(height: 8 * scale),

                    _SlotPrice(scale: scale, price: price),
                  ],
                ),
              ),

              SizedBox(width: 18 * scale),

              _SlotStatusBadge(scale: scale, seats: availableSeats),
            ],
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
  });

  final double scale;
  final String time;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          time,
          style: TextStyle(
            fontSize: 16 * scale,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        //SizedBox(height: 1 * scale),
        Text(
          name,
          style: TextStyle(fontSize: 14 * scale, color: Colors.white),
        ),
      ],
    );
  }
}

class _SlotPrice extends StatelessWidget {
  const _SlotPrice({required this.scale, required this.price});

  final double scale;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Text(
      price,
      style: TextStyle(
        fontSize: 14 * scale,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    );
  }
}

class _SlotStatusBadge extends StatelessWidget {
  const _SlotStatusBadge({required this.scale, required this.seats});

  final double scale;
  final int seats;

  @override
  Widget build(BuildContext context) {
    return Text(
      "$seats seats left",
      textAlign: TextAlign.right,
      style: TextStyle(
        fontSize: 13 * scale,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
    );
  }
}
