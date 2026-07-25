import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:library_management/app_colors.dart';

class PhotoAvatarSection extends StatelessWidget {
  const PhotoAvatarSection({super.key, 
    required this.scale,
    required this.image,
    required this.isImageUploading,
    required this.onTap,
  });

  final double scale;
  final File? image;
  final bool isImageUploading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: EdgeInsets.all(3 * scale),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
              child: InkWell(
                onTap: isImageUploading ? null : onTap,
                borderRadius: BorderRadius.circular(100 * scale),
                child: CircleAvatar(
                  radius: 38 * scale,
                  backgroundColor: AppColors.primary.withValues(alpha: .08),
                  backgroundImage: image != null ? FileImage(image!) : null,
                  child: isImageUploading
                      ? SpinKitThreeBounce(
                          color: AppColors.primary,
                          size: 18 * scale,
                        )
                      : (image == null
                            ? Icon(
                                Icons.person_outline_rounded,
                                size: 42 * scale,
                                color: AppColors.primary,
                              )
                            : null),
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: InkWell(
                onTap: isImageUploading ? null : onTap,
                child: Container(
                  padding: EdgeInsets.all(7 * scale),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.white,
                    size: 14 * scale,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 6 * scale),
        Text(
          isImageUploading
              ? 'Uploading photo...'
              : (image == null ? 'Tap to add photo' : 'Photo ready'),
          style: TextStyle(
            fontSize: 11 * scale,
            color: isImageUploading
                ? AppColors.primary
                : (image == null ? AppColors.grey500 : AppColors.success),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}