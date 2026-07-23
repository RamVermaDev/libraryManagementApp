import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/screens/taskScreen/field/task_text_field.dart';
import 'package:library_management/screens/taskScreen/field/title_text.dart';

class PersonalDetailsSection extends StatelessWidget {
  const PersonalDetailsSection({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.idController,
    required this.scale,
  });

  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController idController;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16 * scale),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16 * scale),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Row(
            children: [
              Icon(
                Icons.person_outline_rounded,
                color: AppColors.primary,
                size: 22 * scale,
              ),

              SizedBox(width: 12 * scale),
              const Expanded(
                child: Text(
                  "Member Information",
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          const Divider(
            height: 0.2, // Total height occupied
            thickness: 1, // Line thickness
            color: AppColors.grey200,
          ),

          SizedBox(height: 22 * scale),

          TitleText(
            title: 'Full Name',
            fontColor: AppColors.grey500,
            fontSize: 12,
            weight: FontWeight.w400,
          ),
          SizedBox(height: 4),
          TaskTextField(
            controller: nameController,
            hintText: "e.g. Ganesh",
            textInputAction: TextInputAction.next,
            fillColor: AppColors.background,
            suffixIcon: Icon(
              Icons.person_outline,
              color: AppColors.iconMuted,
              size: 20 * scale,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Please enter member name";
              }

              if (value.trim().length < 3) {
                return "Name is too short";
              }

              return null;
            },
          ),

          SizedBox(height: 16 * scale),

          TitleText(
            title: 'Phone Number',
            fontColor: AppColors.grey500,
            fontSize: 12,
            weight: FontWeight.w400,
          ),
          SizedBox(height: 4),
          TaskTextField(
            controller: phoneController,
            hintText: "e.g. 9999999999",
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            maxLength: 10,
            fillColor: AppColors.background,
            suffixIcon: Icon(
              Icons.call_outlined,
              color: AppColors.iconMuted,
              size: 20 * scale,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter phone number";
              }

              if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
                return "Invalid phone number";
              }

              return null;
            },
          ),

          SizedBox(height: 16 * scale),

          TitleText(
            title: 'ID Proof (Optional)',
            fontColor: AppColors.grey500,
            fontSize: 12,
            weight: FontWeight.w400,
          ),
          SizedBox(height: 4),
          TaskTextField(
            controller: idController,
            hintText: "e.g. Aadhar/Driving/Pan Card",
            textInputAction: TextInputAction.done,
            suffixIcon: Icon(
              Icons.badge_outlined,
              color: AppColors.iconMuted,
              size: 20 * scale,
            ),
            fillColor: AppColors.background,
          ),

          SizedBox(height: 8),
        ],
      ),
    );
  }
}
