import 'dart:io';

import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/drawer/drawer_screen/library/widgets/section_title.dart';
import 'package:library_management/drawer/drawer_screen/library/widgets/text_field.dart';

Widget buildBasicStep({
  required Key formKeyStep1,
  required VoidCallback pickLogo,
  required File? logoImage,
  required TextEditingController libraryNameController,
  required TextEditingController whatsappController,
  required TextEditingController cityController,
  double scale = 1,
}) {
  return SingleChildScrollView(
    padding: EdgeInsets.symmetric(horizontal: 20 * scale),
    child: Form(
      key: formKeyStep1,
      child: Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26 * scale),
        ),
        child: Padding(
          padding: EdgeInsets.all(22 * scale),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10 * scale),

              _logoPick(pickLogo: pickLogo, logoImage: logoImage, scale: scale),

              SizedBox(height: 30 * scale),

              sectionTitle("Library Name"),

              SizedBox(height: 8 * scale),

              textField(
                controller: libraryNameController,
                hintText: "e.g. Your Library",
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter library name";
                  }
                  return null;
                },
                fillColor: AppColors.background,
                textInputAction: TextInputAction.next,
              ),

              SizedBox(height: 16 * scale),

              sectionTitle("WhatsApp Number"),

              SizedBox(height: 8 * scale),

              textField(
                controller: whatsappController,
                hintText: "9999999999",
                validator: (value) {
                  final phone = value?.trim() ?? "";

                  if (phone.isEmpty) {
                    return "Enter WhatsApp number";
                  }

                  if (!RegExp(r'^[6-9]\d{9}$').hasMatch(phone)) {
                    return "Enter a valid 10-digit Indian mobile number";
                  }

                  return null;
                },
                fillColor: AppColors.background,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                maxLength: 10,
              ),

              SizedBox(height: 16 * scale),

              sectionTitle("City"),

              SizedBox(height: 8 * scale),

              textField(
                controller: cityController,
                hintText: "e.g. New Delhi",
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter city";
                  }
                  return null;
                },
                fillColor: AppColors.background,
                textInputAction: TextInputAction.done,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _logoPick({
  required VoidCallback pickLogo,
  required File? logoImage,
  required double scale,
}) {
  return Center(
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: pickLogo,
          child: Hero(
            tag: const ValueKey("setup_library_logo"),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 100 * scale,
              height: 100 * scale,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.background,
                border: Border.all(color: AppColors.grey100, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: logoImage == null
                  ? Icon(
                      Icons.local_library_rounded,
                      size: 46 * scale,
                      color: AppColors.buttonPrimary,
                    )
                  : Image.file(logoImage, fit: BoxFit.cover),
            ),
          ),
        ),

        Positioned(
          right: 2,
          bottom: 2,
          child: GestureDetector(
            onTap: pickLogo,
            child: Container(
              width: 30 * scale,
              height: 30 * scale,
              decoration: BoxDecoration(
                color: AppColors.buttonPrimaryHover,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Icon(
                Icons.edit_outlined,
                color: Colors.white,
                size: 14 * scale,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
