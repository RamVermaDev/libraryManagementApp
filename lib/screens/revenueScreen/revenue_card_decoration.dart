import 'package:flutter/material.dart';

class AppCardDecoration {
  static BoxDecoration standard({Color? cardColor}) {
    return BoxDecoration(
      color: cardColor ?? Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFE5E8EF)),
      boxShadow: const [
        BoxShadow(
          color: Color(0x080F172A),
          blurRadius: 18,
          offset: Offset(0, 8),
        ),
      ],
    );
  }
}
