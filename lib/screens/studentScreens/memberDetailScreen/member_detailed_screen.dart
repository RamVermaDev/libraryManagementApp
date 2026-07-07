import 'package:flutter/material.dart';
import 'package:library_management/drawer/drawerWidgets/app_bar_widget.dart';
import 'package:library_management/screens/studentScreens/memberDetailed/action_card.dart';
import 'package:library_management/screens/studentScreens/memberDetailed/admission_card.dart';
import 'package:library_management/screens/studentScreens/memberDetailed/membership_card.dart';
import 'package:library_management/screens/studentScreens/memberDetailed/payement_card.dart';
import 'package:library_management/screens/studentScreens/memberDetailScreen/profile_card.dart';

class MemberDetailedScreen extends StatelessWidget {
  const MemberDetailedScreen({
    super.key,
    this.img,
    required this.studentNumber,
    required this.studentName,
    this.gender,
    required this.phone,
    required this.idProof,
    required this.totalAmount,
    required this.totalDiscount,
    required this.totalPending,
    required this.joinDate,
    required this.expireDate,
    required this.plan,
    required this.program,
  });

  final String? img;
  final int studentNumber;
  final String studentName;
  final String? gender;
  final String phone;
  final String? idProof;
  final String totalAmount;
  final String totalDiscount;
  final String totalPending;

  final DateTime? joinDate;
  final DateTime? expireDate;
  final String plan;
  final int? program;

  //FORMATE DATES
  String _formattedDate(givenDate) {
    if (givenDate == null) {
      return 'Select date';
    }
    final date = givenDate;
    return '${date.day}-${date.month}-${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Member Info',
        actionIcon: Icons.edit_document,
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
                      name: studentName,
                      phone: phone,
                      id: idProof,
                      number: studentNumber,
                    ),

                    SizedBox(height: 18 * scale),

                    // CALL, WHATSAPP, MESSAGE, & RENEW
                    ActionCard(scale: scale, phone: phone, message: 'Hi'),

                    SizedBox(height: 24 * scale),

                    //JOIN-DATE, EXPIRE-DATE, PLAN & PROGRAM
                    MembershipCard(
                      scale: scale,
                      joinDate: _formattedDate(joinDate),
                      expireDate: _formattedDate(expireDate),
                      plan: plan,
                      program: '${program.toString()} Days',
                    ),

                    SizedBox(height: 24 * scale),

                    //AMOUNT, PENDING, & DISCOUNT
                    PaymentCard(
                      scale: scale,
                      amount: totalAmount,
                      discount: totalDiscount,
                      pending: totalPending,
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
