import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';

class StudentTextFormField extends StatelessWidget {
  const StudentTextFormField({
    super.key,
    required this.controller,
    required this.lable,
    required this.prefixIcon,
    required this.validator,
    required this.textInputAction,
    this.keyboardType,
    this.borderRadius = 4,
    this.height = 52,
    this.borderWidth = 1.2,
    this.isRequired = true,
    this.maxLength = 30,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 12,
    ),
  });

  final TextEditingController controller;
  final String lable;
  final IconData prefixIcon;
  final double borderRadius;
  final double height;
  final double borderWidth;
  final EdgeInsetsGeometry contentPadding;

  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  final bool isRequired;
  final int maxLength;
  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        maxLength: maxLength,
        style: TextStyle(fontSize: 18),
        textInputAction: textInputAction,

        decoration: InputDecoration(
          counterText: '',
          label: RichText(
            text: TextSpan(
              text: lable,
              style: const TextStyle(color: Colors.black54, fontSize: 16),
              children: isRequired
                  ? const [
                      TextSpan(
                        text: " *",
                        style: TextStyle(color: Colors.red),
                      ),
                    ]
                  : const [],
            ),
          ),
          prefixIcon: Icon(prefixIcon),
          contentPadding: contentPadding,

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(width: borderWidth, color: Colors.grey),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              width: borderWidth + 0.5,
              color: AppColors.grey400,
            ),
          ),

          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(width: borderWidth, color: Colors.red),
          ),

          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(width: borderWidth + 0.5, color: Colors.red),
          ),

          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
