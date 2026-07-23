import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  static const double _designWidth = 430;

  double get scale {
    return (MediaQuery.sizeOf(this).width / _designWidth).clamp(0.85, 1.12);
  }
}
