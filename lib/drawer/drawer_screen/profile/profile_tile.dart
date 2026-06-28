import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';

class ProfileTile extends StatelessWidget {
  const ProfileTile({
    super.key,
    required this.title,
    required this.value,
    this.isIconValue = false,
    this.iconValue = Icons.abc,
    this.isClickable = false,
    this.clickableValue,
  });

  final String title;
  final String value;
  final bool isIconValue;
  final IconData iconValue;
  final bool isClickable;
  final VoidCallback? clickableValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
            ),
          ),

          isIconValue
              ? isClickable
                    ? IconButton(
                        color: AppColors.primary,
                        onPressed: clickableValue,
                        icon: Icon(iconValue),
                      )
                    : Icon(iconValue)
              : isClickable
              ? InkWell(
                  onTap: clickableValue,
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: AppColors.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              : Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
        ],
      ),
    );
  }
}
