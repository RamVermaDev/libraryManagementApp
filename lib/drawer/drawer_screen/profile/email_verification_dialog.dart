import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/controllers/user_controller.dart';

Future<void> showEmailVerificationOtpDialogBox({
  required BuildContext context,
  required WidgetRef ref,
}) async {
  await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return _EmailVerificationOtpDialog(ref: ref);
    },
  );
}

class _EmailVerificationOtpDialog extends StatefulWidget {
  const _EmailVerificationOtpDialog({required this.ref});

  final WidgetRef ref;

  @override
  State<_EmailVerificationOtpDialog> createState() =>
      _EmailVerificationOtpDialogState();
}

class _EmailVerificationOtpDialogState
    extends State<_EmailVerificationOtpDialog> {
  final TextEditingController _otpController = TextEditingController();
  final UserController _userController = UserController();
  bool _isLoading = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    final otpText = _otpController.text.trim();
    if (otpText.length != 6 || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final isVerified = await _userController.verifyEmailOtp(
      context: context,
      ref: widget.ref,
      otp: otpText,
    );

    if (!mounted) return;

    if (isVerified) {
      Navigator.pop(context, true);
      return;
    }

    _otpController.clear();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Soft Icon Badge
            Container(
              width: 54,
              height: 54,
              decoration: const BoxDecoration(
                color: AppColors.primarySoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.mark_email_read_outlined,
                color: AppColors.primary,
                size: 26,
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'Verify Email Address',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.heading,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Enter the 6-digit OTP sent to your email',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.caption,
              ),
            ),

            const SizedBox(height: 20),

            // OTP Input Field
            TextField(
              controller: _otpController,
              enabled: !_isLoading,
              keyboardType: TextInputType.number,
              maxLength: 6,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 8,
                color: AppColors.heading,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
              decoration: InputDecoration(
                hintText: '000000',
                hintStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 8,
                  color: AppColors.caption.withValues(alpha: 0.4),
                ),
                counterText: '',
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.primary, width: 2),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Actions Row
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 46,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: _isLoading
                          ? null
                          : () => Navigator.pop(context, false),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: AppColors.heading,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: SizedBox(
                    height: 46,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.buttonPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: _isLoading ? null : _verifyOtp,
                      child: _isLoading
                          ? const SpinKitThreeBounce(
                              color: Colors.white,
                              size: 16,
                            )
                          : const Text(
                              'Verify',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
