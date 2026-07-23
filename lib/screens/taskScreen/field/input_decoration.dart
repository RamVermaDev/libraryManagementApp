import 'package:flutter/material.dart';

InputDecoration inputDecoration({
  required String hintText,
  Color? fillColor,
  Widget? suffixIcon,
}) {
  double radius = 10;
  return InputDecoration(
    suffixIcon: suffixIcon,
    hintText: hintText,
    hintStyle: const TextStyle(color: Color(0xFF98A2B3), fontSize: 13),
    filled: true,
    fillColor: fillColor ?? Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: const BorderSide(color: Color(0xFF0B2A66), width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: const BorderSide(color: Colors.red),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: const BorderSide(color: Colors.red),
    ),
    counterText: '',
  );
}
