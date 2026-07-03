import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';

class StudentDropdownField<T> extends StatefulWidget {
  const StudentDropdownField({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.label,
    required this.prefixIcon,
    this.validator,
    this.borderRadius = 4,
    this.height = 52,
    this.borderWidth = 1.2,
    this.isRequired = true,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 12,
    ),
  });

  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? label;
  final IconData prefixIcon;
  final String? Function(T?)? validator;

  final double borderRadius;
  final double height;
  final double borderWidth;
  final bool isRequired;
  final EdgeInsetsGeometry contentPadding;
  @override
  State<StudentDropdownField<T>> createState() =>
      _StudentDropdownFieldState<T>();
}

class _StudentDropdownFieldState<T> extends State<StudentDropdownField<T>> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: DropdownButtonFormField<T>(
        initialValue: widget.value,
        items: widget.items,
        onChanged: widget.onChanged,
        validator: widget.validator,
        isExpanded: true,
        icon: const Icon(Icons.keyboard_arrow_down_rounded),
        style: const TextStyle(fontSize: 18, color: Colors.black),

        decoration: InputDecoration(
          counterText: '',
          label: widget.label == null
              ? null
              : RichText(
                  text: TextSpan(
                    text: widget.label,
                    style: const TextStyle(color: Colors.black54, fontSize: 16),
                    children: widget.isRequired
                        ? const [
                            TextSpan(
                              text: " *",
                              style: TextStyle(color: Colors.red),
                            ),
                          ]
                        : const [],
                  ),
                ),

          prefixIcon: Icon(widget.prefixIcon),
          contentPadding: widget.contentPadding,

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(
              width: widget.borderWidth,
              color: Colors.grey,
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(
              width: widget.borderWidth + 0.5,
              color: AppColors.black,
            ),
          ),

          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(
              width: widget.borderWidth,
              color: Colors.red,
            ),
          ),

          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(
              width: widget.borderWidth + 0.5,
              color: Colors.red,
            ),
          ),

          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
