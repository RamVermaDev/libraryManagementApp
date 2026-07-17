import 'package:flutter/material.dart';
import 'package:library_management/screens/taskScreen/field/input_decoration.dart';

Widget textField({
    required TextEditingController controller,
    required String hintText,
    required String? Function(String?) validator,
    required Color fillColor,
    int? maxLength,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLength: maxLength,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      decoration: inputDecoration(hintText: hintText, fillColor: fillColor),
    );
  }