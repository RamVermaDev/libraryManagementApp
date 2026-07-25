import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:library_management/app_colors.dart';

class DialogActionButtons extends StatelessWidget {
  const DialogActionButtons({
    super.key,
    required this.scale,
    required this.isLoading,
    required this.isImageUploading,
    required this.isCanceling,
    required this.onCancel,
    required this.onConfirm,
  });

  final double scale;
  final bool isLoading;
  final bool isImageUploading;
  final bool isCanceling;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = isLoading || isImageUploading || isCanceling;

    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: isDisabled ? null : onCancel,
            style: OutlinedButton.styleFrom(
              minimumSize: Size.fromHeight(50 * scale),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12 * scale),
              ),
              side: const BorderSide(color: AppColors.border),
            ),
            child: isCanceling
                ? SpinKitThreeBounce(color: AppColors.grey700, size: 16 * scale)
                : Text(
                    "Cancel",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15 * scale,
                      color: isDisabled ? AppColors.grey400 : AppColors.grey700,
                    ),
                  ),
          ),
        ),
        SizedBox(width: 12 * scale),
        Expanded(
          child: ElevatedButton(
            onPressed: isDisabled ? null : onConfirm,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonPrimary,
              minimumSize: Size.fromHeight(50 * scale),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12 * scale),
              ),
            ),
            child: isLoading
                ? const SpinKitThreeBounce(color: Colors.white, size: 18)
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_outline_rounded,
                        color: Colors.white,
                        size: 18 * scale,
                      ),
                      SizedBox(width: 6 * scale),
                      Text(
                        "Confirm",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15 * scale,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
