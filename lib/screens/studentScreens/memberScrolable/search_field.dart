import 'package:flutter/material.dart';
import 'package:library_management/screens/studentScreens/memberScrolable/member_color.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const SearchField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Search member',
          hintStyle: const TextStyle(
            color: MembersColors.muted,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: MembersColors.muted,
          ),
          filled: true,
          fillColor: MembersColors.surface,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          border: _border(),
          enabledBorder: _border(),
          focusedBorder: _border(color: MembersColors.primary),
        ),
      ),
    );
  }

  OutlineInputBorder _border({Color color = MembersColors.border}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: color, width: 1),
    );
  }
}
