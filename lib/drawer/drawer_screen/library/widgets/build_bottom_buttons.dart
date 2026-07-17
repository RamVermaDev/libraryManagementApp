import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:library_management/app_colors.dart';

Widget buildBottomButtons({
  required int currentStep,
  required VoidCallback nextStep,
  required VoidCallback previousStep,
  required bool isLoading,
  required String submitLabel,
  double scale = 1,
}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
    child: AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: currentStep == 0
          ? SizedBox(
              key: const ValueKey(1),
              width: double.infinity,
              height: 52 * scale,
              child: FilledButton(
                onPressed: nextStep,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.buttonPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  "Continue",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                ),
              ),
            )
          : Row(
              key: const ValueKey(2),
              children: [
                Expanded(
                  child: SizedBox(
                    height: 52 * scale,
                    child: OutlinedButton(
                      onPressed: previousStep,
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text("Back"),
                    ),
                  ),
                ),
                SizedBox(width: 50 * scale),
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 52 * scale,
                    child: FilledButton(
                      onPressed: isLoading ? () {} : nextStep,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.buttonPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: isLoading
                          ? SpinKitThreeBounce(
                              color: Colors.white,
                              size: 16 * scale,
                            )
                          : Text(
                              submitLabel,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14 * scale,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
    ),
  );
}
