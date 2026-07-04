import 'package:flutter/material.dart';
import 'package:library_management/screens/taskScreen/field/input_decoration.dart';

class TaskTextField extends StatelessWidget {
  const TaskTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.validator,
    this.minLines = 1,
    this.maxLines = 1,
    this.maxLength,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.enabled = true,
  });

  final String hintText;
  final TextEditingController controller;

  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;

  final int minLines;
  final int maxLines;
  final int? maxLength;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      enabled: enabled,
      minLines: minLines,
      maxLines: maxLines,
      maxLength: maxLength,
      keyboardType: keyboardType,
      textInputAction: textInputAction,

      decoration: inputDecoration(hintText: hintText),
    );
  }
}
