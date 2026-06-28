import 'package:flutter/material.dart';

class DrawerTextFormField extends StatelessWidget {
  const DrawerTextFormField({
    super.key,
    required this.controller,
    required this.lable,
    required this.prefixIcon,
    required this.validator,
    required this.keyboardType,
    this.borderRadius = 8,
  });

  final TextEditingController controller;
  final String lable;
  final IconData prefixIcon;
  final double borderRadius;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: lable,
        prefixIcon: Icon(prefixIcon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
