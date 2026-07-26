import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:library_management/controllers/image_controller.dart';
import 'package:library_management/controllers/student_controller.dart';
import 'package:library_management/drawer/drawerWidgets/app_bar_widget.dart';
import 'package:library_management/models/student_model.dart';
import 'package:library_management/services/manage_http_response.dart';
import 'package:library_management/screens/studentScreens/memberDetailScreen/action_card.dart';
import 'package:library_management/screens/studentScreens/memberDetailScreen/admission_card.dart';
import 'package:library_management/screens/studentScreens/memberDetailScreen/membership_card.dart';
import 'package:library_management/screens/studentScreens/memberDetailScreen/payement_card.dart';
import 'package:library_management/screens/studentScreens/memberDetailScreen/profile_card.dart';
import 'package:library_management/screens/studentScreens/memberDetailScreen/refund_bottom_sheet.dart';
import 'package:library_management/screens/studentScreens/renewAdmission/renew_admission_screen.dart';
import 'package:library_management/screens/studentScreens/pauseResume/pause_student_sheet.dart';
import 'package:library_management/screens/studentScreens/pauseResume/resume_student_sheet.dart';
import 'package:library_management/screens/studentScreens/pauseResume/blacklist_student_sheet.dart';
import 'package:library_management/screens/studentScreens/pauseResume/unblock_student_sheet.dart';
import 'package:library_management/services/profile_photo_service.dart';
import 'package:library_management/services/student_message_service.dart';

class MemberDetailedScreen extends ConsumerStatefulWidget {
  const MemberDetailedScreen({super.key, required this.member});

  final StudentModel member;

  @override
  ConsumerState<MemberDetailedScreen> createState() =>
      _MemberDetailedScreenState();
}

class _MemberDetailedScreenState extends ConsumerState<MemberDetailedScreen> {
  final StudentController _studentController = StudentController();
  final ImageController _imageController = ImageController();
  late StudentModel _member;

  @override
  void initState() {
    super.initState();
    _member = widget.member;
  }

  Future<void> _changePhoto(ImageSource source) async {
    final studentId = _member.id;

    if (studentId == null || studentId.isEmpty) {
      showSnackBar(context, 'Student id missing');
      return;
    }

    final image = await ProfilePhotoService.pick(
      context: context,
      source: source,
    );

    if (image == null) return;
    if (!mounted) return;

    print('Image path');

    final profileImage = await _imageController.uploadStudentImage(
      context: context,
      ref: ref,
      studentId: studentId,
      image: image,
    );

    if (profileImage == null || !mounted) return;

    setState(() {
      _member = _member.copyWith(profileImage: profileImage);
    });
  }

  //FORMATE DATES
  String _formattedDate(givenDate) {
    if (givenDate == null) {
      return 'Select date';
    }
    final date = givenDate as DateTime;
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final monthName = months[date.month - 1];
    return '${date.day} $monthName ${date.year}';
  }

  Future<bool> _updateProfile({
    required String name,
    required String phone,
    required String? idProof,
  }) async {
    final studentId = _member.id;

    if (studentId == null || studentId.isEmpty) {
      showSnackBar(context, 'Student id missing');
      return false;
    }

    final updatedStudent = await _studentController.updateStudentProfile(
      context: context,
      ref: ref,
      libraryId: _member.libraryId,
      studentId: studentId,
      name: name,
      phone: phone,
      idProof: idProof,
    );

    if (updatedStudent == null || !mounted) return false;

    setState(() {
      _member = updatedStudent;
    });

    return true;
  }

  Future<void> _handlePendingResolution(PendingResolutionResult result) async {
    final studentId = _member.id;
    if (studentId == null || studentId.isEmpty) {
      showSnackBar(context, 'Student ID missing');
      return;
    }

    final updatedStudent = await _studentController.clearStudentPending(
      context: context,
      ref: ref,
      libraryId: _member.libraryId,
      studentId: studentId,
      action: result.action,
      amount: result.amount,
      paymentMode: result.paymentMode,
      note: result.note,
    );

    if (updatedStudent != null && mounted) {
      setState(() {
        _member = updatedStudent;
      });
    }
  }

  Future<void> _handleRefund() async {
    final studentId = _member.id;
    if (studentId == null || studentId.isEmpty) {
      showSnackBar(context, 'Student ID missing');
      return;
    }

    final updatedStudent = await showRefundBottomSheet(
      context: context,
      member: _member,
      onRefund: (result) async {
        return await _studentController.refundStudent(
          context: context,
          ref: ref,
          libraryId: _member.libraryId,
          studentId: studentId,
          refundAmount: result.refundAmount,
          paymentMode: result.paymentMode,
          note: result.note,
        );
      },
    );

    if (updatedStudent != null && mounted) {
      setState(() {
        _member = updatedStudent;
      });
    }
  }

  void _handleRenew() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RenewAdmissionScreen(
          member: _member,
          onRenewed: (updatedStudent) {
            setState(() {
              _member = updatedStudent;
            });
          },
        ),
      ),
    );
  }

  Future<void> _handlePause(double scale) async {
    final studentId = _member.id;
    if (studentId == null || studentId.isEmpty) return;

    final updatedStudent = await PauseStudentSheet.show(
      context: context,
      member: _member,
      scale: scale,
      onPause: (reason) async {
        return await _studentController.pauseStudent(
          context: context,
          ref: ref,
          libraryId: _member.libraryId,
          studentId: studentId,
          reason: reason,
        );
      },
    );

    if (updatedStudent != null && mounted) {
      setState(() {
        _member = updatedStudent;
      });
    }
  }

  Future<void> _handleResume(double scale) async {
    final studentId = _member.id;
    if (studentId == null || studentId.isEmpty) return;

    final updatedStudent = await ResumeStudentSheet.show(
      context: context,
      member: _member,
      scale: scale,
      onResume: (result) async {
        return await _studentController.resumeStudent(
          context: context,
          ref: ref,
          libraryId: _member.libraryId,
          studentId: studentId,
          extensionDays: result.extensionDays,
          seatId: result.seatId,
        );
      },
    );

    if (updatedStudent != null && mounted) {
      setState(() {
        _member = updatedStudent;
      });
    }
  }

  Future<void> _handleBlacklist(double scale) async {
    final studentId = _member.id;
    if (studentId == null || studentId.isEmpty) return;

    final updatedStudent = await BlacklistStudentSheet.show(
      context: context,
      member: _member,
      scale: scale,
      onBlacklist: (reason) async {
        return await _studentController.blacklistStudent(
          context: context,
          ref: ref,
          libraryId: _member.libraryId,
          studentId: studentId,
          reason: reason,
        );
      },
    );

    if (updatedStudent != null && mounted) {
      setState(() {
        _member = updatedStudent;
      });
    }
  }

  Future<void> _handleUnblock(double scale) async {
    final studentId = _member.id;
    if (studentId == null || studentId.isEmpty) return;

    final confirmed = await UnblockStudentSheet.show(
      context: context,
      member: _member,
      scale: scale,
    );

    if (confirmed != true || !mounted) return;

    final updatedStudent = await _studentController.unblockStudent(
      context: context,
      ref: ref,
      libraryId: _member.libraryId,
      studentId: studentId,
    );

    if (updatedStudent != null && mounted) {
      setState(() {
        _member = updatedStudent;
      });
    }
  }

  Future<void> _handleDeleteStudent() async {
    final studentId = _member.id;
    if (studentId == null || studentId.isEmpty) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Row(
          children: [
            Icon(Icons.delete_outline_rounded, color: Colors.red, size: 26),
            SizedBox(width: 8),
            Text(
              'Delete Student?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to delete ${_member.name}? Their seat will be released immediately.',
              style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFFCDD2)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Color(0xFFD32F2F), size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'This action is irreversible!',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFD32F2F),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(ctx, false),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Delete',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    final success = await _studentController.deleteStudent(
      context: context,
      ref: ref,
      libraryId: _member.libraryId,
      studentId: studentId,
      student: _member,
    );

    if (success && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final libraryName = StudentMessageService.getLibraryName(
      ref,
      targetLibraryId: _member.libraryId,
    );

    final reminderMessage = StudentMessageService.generateMessage(
      student: _member,
      libraryName: libraryName,
    );

    final bool isPaused = _member.status == 'paused';
    final bool isBlacklisted = _member.status == 'blacklisted';

    return Scaffold(
      appBar: AppBarWidget(
        title: 'Member Info',
        actionIcon: Icons.delete_outline_rounded,
        color: Colors.red,
        onActionPressed: _handleDeleteStudent,
      ),

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final scale = (constraints.maxWidth / 430).clamp(0.82, 1.12);
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  18 * scale,
                  0,
                  18 * scale,
                  28 * scale,
                ),

                child: Column(
                  children: [
                    const SizedBox(height: 15),

                    ProfileCard(
                      scale: scale,
                      name: _member.name,
                      phone: _member.phone,
                      id: _member.idProof,
                      number: 1,
                      status: _member.status,
                      expireDate: _member.currentExpireDate,
                      onSave: _updateProfile,
                      imageUrl: _member.profileImage,
                      onChangePhoto: _changePhoto,
                    ),

                    SizedBox(height: 18 * scale),

                    // CALL, WHATSAPP, MESSAGE, & RENEW
                    ActionCard(
                      scale: scale,
                      phone: _member.phone,
                      message: reminderMessage,
                      pending: _member.totalPending,
                      totalPaid: _member.totalPaid,
                      expiryDate: _member.currentExpireDate ?? DateTime.now(),
                      isPaused: isPaused,
                      isBlacklisted: isBlacklisted,
                      onPendingAction: _handlePendingResolution,
                      onRefund: _handleRefund,
                      onRenew: _handleRenew,
                      onPause: () => _handlePause(scale),
                      onResume: () => _handleResume(scale),
                      onBlacklist: () => _handleBlacklist(scale),
                      onUnblock: () => _handleUnblock(scale),
                    ),

                    SizedBox(height: 24 * scale),

                    MembershipCard(
                      scale: scale,
                      joinDate: _formattedDate(_member.joiningDate),
                      expireDate: _formattedDate(_member.currentExpireDate),
                      slot: _member.slotTiming ?? 'Not Available',
                      planDuration:
                          '${_member.currentPlanDays.toString()} Days',
                    ),

                    SizedBox(height: 24 * scale),

                    //AMOUNT, PENDING, & DISCOUNT
                    PaymentCard(
                      scale: scale,
                      amount: _member.totalPaid.toInt().toString(),
                      discount: _member.totalDiscount.toInt().toString(),
                      pending: _member.totalPending.toInt().toString(),
                    ),

                    SizedBox(height: 18 * scale),

                    //ALL STUDENT ADMISSION
                    AdmissionsCard(scale: scale),

                    //ReceiptContainer(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
