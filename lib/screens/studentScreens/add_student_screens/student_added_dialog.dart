import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/context_extension.dart';

class StudentAddedDialog extends StatefulWidget {
  const StudentAddedDialog({
    super.key,
    required this.name,
    required this.phone,
    required this.timming,
    required this.finalAmount,
  });

  final String name;
  final String phone;
  final String timming;
  final String finalAmount;

  @override
  State<StudentAddedDialog> createState() => _StudentAddedDialogState();
}

class _StudentAddedDialogState extends State<StudentAddedDialog> {
  final ImagePicker _picker = ImagePicker();

  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    Navigator.pop(context);

    final XFile? file = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (file == null) return;

    setState(() {
      _image = File(file.path);
    });
  }

  void _showPicker(double scale) {
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

  @override
  Widget build(BuildContext context) {
    final double scale = context.scale;
    return PopScope(
      canPop: false,
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5 * scale, sigmaY: 5 * scale),
              child: Container(color: Colors.black26),
            ),
            Center(
              child: Container(
                width: 340 * scale,
                margin: EdgeInsets.symmetric(horizontal: 20 * scale),
                padding: EdgeInsets.all(24 * scale),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22 * scale),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 18,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        InkWell(
                          onTap: () => _showPicker(scale),
                          borderRadius: BorderRadius.circular(100 * scale),
                          child: CircleAvatar(
                            radius: 40 * scale,
                            backgroundColor: AppColors.primary.withValues(
                              alpha: .08,
                            ),
                            backgroundImage: _image != null
                                ? FileImage(_image!)
                                : null,
                            child: _image == null
                                ? Icon(
                                    Icons.person,
                                    size: 42 * scale,
                                    color: AppColors.primary,
                                  )
                                : null,
                          ),
                        ),
                        Positioned(
                          right: -1 * scale,
                          bottom: -1 * scale,
                          child: InkWell(
                            onTap: () => _showPicker(scale),
                            child: Container(
                              padding: EdgeInsets.all(8 * scale),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 10 * scale,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 25 * scale),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(14 * scale),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(14 * scale),
                      ),
                      child: Column(
                        children: [
                          _detailRow(
                            title: 'Name',
                            titleDetail: widget.name,
                            scale: scale,
                          ),

                          SizedBox(height: 8 * scale),

                          _detailRow(
                            title: 'Phone Number',
                            titleDetail: widget.phone,
                            scale: scale,
                          ),

                          SizedBox(height: 8 * scale),

                          _detailRow(
                            title: 'Timming',
                            titleDetail: widget.timming,
                            scale: scale,
                          ),

                          SizedBox(height: 8 * scale),

                          _detailRow(
                            title: 'Amount',
                            titleDetail: widget.finalAmount,
                            scale: scale,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 28 * scale),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            style: OutlinedButton.styleFrom(
                              minimumSize: Size.fromHeight(52 * scale),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12 * scale),
                              ),
                            ),
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16 * scale,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12 * scale),
                        Expanded(
                          child: FilledButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              minimumSize: Size.fromHeight(52 * scale),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12 * scale),
                              ),
                            ),
                            child: Text(
                              "Confirm",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16 * scale,
                              ),
                            ),
                          ),
                        ),
                      ],
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

Widget _detailRow({
  required String title,
  required String titleDetail,
  required double scale,
}) {
  return Row(
    children: [
      Text('$title:'),
      SizedBox(width: 10 * scale),
      Expanded(
        child: Text(
          titleDetail,
          style: TextStyle(fontSize: 14 * scale, fontWeight: FontWeight.w500),
        ),
      ),
    ],
  );
}
