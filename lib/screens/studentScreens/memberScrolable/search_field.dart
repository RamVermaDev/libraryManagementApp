import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;
  final String hintText;

  const SearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.onClear,
    this.hintText = 'Search name/phone',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        style: const TextStyle(
          color: AppColors.heading,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          isDense: true,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: AppColors.caption,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppColors.caption,
                    size: 18,
                  ),
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                    if (onClear != null) onClear!();
                  },
                )
              : const Icon(
                  Icons.search_rounded,
                  color: AppColors.caption,
                  size: 20,
                ),
          filled: true,
          fillColor: AppColors.surface,
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          border: _border(),
          enabledBorder: _border(),
          focusedBorder: _border(color: AppColors.primary),
        ),
      ),
    );
  }

  OutlineInputBorder _border({Color color = AppColors.border}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: color, width: 1),
    );
  }
}
