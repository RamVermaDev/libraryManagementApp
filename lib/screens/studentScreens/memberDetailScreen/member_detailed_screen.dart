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
import 'package:library_management/services/profile_photo_service.dart';

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

  Future<void> _changePhoto() async {
    final studentId = _member.id;

    if (studentId == null || studentId.isEmpty) {
      showSnackBar(context, 'Student id missing');
      return;
    }

    final image = await ProfilePhotoService.pick(
      context: context,
      source: ImageSource.camera,
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
    final date = givenDate;
    return '${date.day}-${date.month}-${date.year}';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Member Info',
        actionIcon: Icons.delete_outline_rounded,
        color: Colors.red,
        onActionPressed: () {},
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
                      onSave: _updateProfile,
                      imageUrl: _member.profileImage,
                      onChangePhoto: _changePhoto,
                    ),

                    SizedBox(height: 18 * scale),

                    // CALL, WHATSAPP, MESSAGE, & RENEW
                    ActionCard(
                      scale: scale,
                      phone: _member.phone,
                      message: 'Hi',
                      pending: _member.totalPending,
                      expiryDate: _member.currentExpireDate!,
                    ),

                    SizedBox(height: 24 * scale),

                    //JOIN-DATE, EXPIRE-DATE, PLAN & PROGRAM
                    MembershipCard(
                      scale: scale,
                      joinDate: _formattedDate(_member.joiningDate),
                      expireDate: _formattedDate(_member.currentExpireDate),
                      slotId: _member.seatId!,
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
