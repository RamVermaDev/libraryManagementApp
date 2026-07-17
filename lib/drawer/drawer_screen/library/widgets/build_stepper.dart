import 'package:flutter/material.dart';

Widget buildStepper(int currentStep) {
  const accent = Color(0xFF111111); // near-black accent
  const inactiveTrack = Color(0xFFE9E9EC);
  const inactiveText = Color(0xFFAFAFAF);

  Widget buildTrack(bool active) {
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        height: 3,
        decoration: BoxDecoration(
          color: active ? accent : inactiveTrack,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget buildLabel(String text, bool active) {
    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 250),
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 13,
        letterSpacing: 0.1,
        color: active ? accent : inactiveText,
      ),
      child: Text(text),
    );
  }

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Column(
      children: [
        Row(
          children: [
            buildTrack(true), // step 0 is always completed/current
            const SizedBox(width: 6),
            buildTrack(currentStep >= 1),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildLabel("Basic Details", currentStep == 0),
            buildLabel("Seat Availability", currentStep == 1),
          ],
        ),
      ],
    ),
  );
}
