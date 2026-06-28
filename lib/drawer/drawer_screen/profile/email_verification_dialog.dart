import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    if (_otpController.text.trim().length != 6 || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final isVerified = await _userController.verifyEmailOtp(
      context: context,
      ref: widget.ref,
      otp: _otpController.text,
    );

    if (!mounted) return;

    if (isVerified) {
      Navigator.pop(context, true);
      return;
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Email Verification'),
      content: TextField(
        controller: _otpController,
        enabled: !_isLoading,
        keyboardType: TextInputType.number,
        maxLength: 6,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(6),
        ],
        decoration: const InputDecoration(
          labelText: 'Enter OTP',
          counterText: '',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _verifyOtp,
          child: _isLoading
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Verify'),
        ),
      ],
    );
  }
}
