import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/context_extension.dart';
import 'package:library_management/controllers/image_controller.dart';
import 'package:library_management/screens/studentScreens/student_dialog_screen/dialog_action_buttons.dart';
import 'package:library_management/screens/studentScreens/student_dialog_screen/photo_avatar_section.dart';
import 'package:library_management/screens/studentScreens/student_dialog_screen/student_detailed_box.dart';
import 'package:library_management/services/profile_photo_service.dart';

class StudentAddedDialog extends ConsumerStatefulWidget {
  const StudentAddedDialog({
    super.key,
    required this.name,
    required this.phone,
    required this.timming,
    required this.seatName,
    required this.planDays,
    required this.expireDate,
    required this.amount,
    this.discount = 0,
    required this.finalAmount,
    this.pending = 0,
    this.paymentMode,
    required this.onConfirm,
  });

  final String name;
  final String phone;
  final String timming;
  final String seatName;
  final int planDays;
  final DateTime expireDate;
  final double amount;
  final double discount;
  final double finalAmount;
  final double pending;
  final String? paymentMode;

  /// Returns true if backend student creation succeeded, false if error.
  /// Passes the photoPublicId string (or null if no photo uploaded).
  final Future<bool> Function(String? photoPublicId) onConfirm;

  @override
  ConsumerState<StudentAddedDialog> createState() => _StudentAddedDialogState();
}

class _StudentAddedDialogState extends ConsumerState<StudentAddedDialog> {
  File? _image;
  String? _photoPublicId;
  bool _isImageUploading = false;
  bool _isCanceling = false;
  bool _isLoading = false;

  final _imageController = ImageController();

  Future<void> _pickImage(ImageSource source) async {
    Navigator.pop(context);

    final croppedImage = await ProfilePhotoService.pick(
      context: context,
      source: source,
    );

    if (croppedImage == null || !mounted) return;

    setState(() {
      _isImageUploading = true;
    });

    try {
      final publicId = await _imageController.uploadImage(
        context: context,
        ref: ref,
        image: croppedImage,
      );

      if (mounted) {
        setState(() {
          _image = croppedImage;
          _photoPublicId = publicId;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isImageUploading = false;
        });
      }
    }
  }

  void _showPicker(double scale) {
    if (_isLoading || _isImageUploading || _isCanceling) return;

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(bottom: 20 * scale),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.photo_library_outlined, size: 24 * scale),
                  title: Text(
                    "Choose from Gallery",
                    style: TextStyle(fontSize: 16 * scale),
                  ),
                  onTap: () => _pickImage(ImageSource.gallery),
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt_outlined, size: 24 * scale),
                  title: Text(
                    "Take Photo",
                    style: TextStyle(fontSize: 16 * scale),
                  ),
                  onTap: () => _pickImage(ImageSource.camera),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleCancel() async {
    if (_isLoading || _isImageUploading || _isCanceling) return;

    if (_photoPublicId != null && _photoPublicId!.isNotEmpty) {
      debugPrint(
        'Cancel tapped with pre-uploaded photo. Triggering image deletion for publicId: $_photoPublicId',
      );
      setState(() {
        _isCanceling = true;
      });

      try {
        await _imageController.deleteImage(
          context: context,
          ref: ref,
          publicId: _photoPublicId!,
        );
      } finally {
        if (mounted) {
          setState(() {
            _isCanceling = false;
          });
        }
      }
    } else {
      debugPrint('Cancel tapped with no photo uploaded.');
    }

    if (mounted) {
      Navigator.pop(context, false);
    }
  }

  Future<void> _handleConfirm() async {
    if (_isLoading || _isImageUploading || _isCanceling) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await widget.onConfirm(_photoPublicId);
      if (success && mounted) {
        Navigator.pop(context, true);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double scale = context.scale;
    final bool isBusy = _isLoading || _isImageUploading || _isCanceling;

    return PopScope(
      canPop: !isBusy,
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6 * scale, sigmaY: 6 * scale),
              child: Container(color: Colors.black38),
            ),
            Center(
              child: Container(
                width: 350 * scale,
                margin: EdgeInsets.symmetric(horizontal: 20 * scale),
                padding: EdgeInsets.all(22 * scale),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24 * scale),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header Title
                    Text(
                      'Verify before continue',
                      style: TextStyle(
                        fontSize: 17 * scale,
                        fontWeight: FontWeight.w600,
                        color: AppColors.heading,
                      ),
                    ),
                    SizedBox(height: 20 * scale),

                    // Avatar Section
                    PhotoAvatarSection(
                      scale: scale,
                      image: _image,
                      isImageUploading: _isImageUploading,
                      onTap: () => _showPicker(scale),
                    ),
                    SizedBox(height: 20 * scale),

                    // Outlined Icon Info Cards
                    StudentDetailsBox(
                      scale: scale,
                      name: widget.name,
                      phone: widget.phone,
                      timming: widget.timming,
                      seatName: widget.seatName,
                      planDays: widget.planDays,
                      expireDate: widget.expireDate,
                      amount: widget.amount,
                      discount: widget.discount,
                      finalAmount: widget.finalAmount,
                      pending: widget.pending,
                      paymentMode: widget.paymentMode,
                    ),
                    SizedBox(height: 24 * scale),

                    // Action Buttons
                    DialogActionButtons(
                      scale: scale,
                      isLoading: _isLoading,
                      isImageUploading: _isImageUploading,
                      isCanceling: _isCanceling,
                      onCancel: _handleCancel,
                      onConfirm: _handleConfirm,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



