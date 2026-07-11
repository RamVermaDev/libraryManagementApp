import 'package:flutter/material.dart';
import 'package:library_management/drawer/drawerWidgets/app_bar_widget.dart';
import 'package:library_management/models/student_model.dart';
import 'package:library_management/screens/studentScreens/memberDetailScreen/action_card.dart';
import 'package:library_management/screens/studentScreens/memberDetailScreen/admission_card.dart';
import 'package:library_management/screens/studentScreens/memberDetailScreen/membership_card.dart';
import 'package:library_management/screens/studentScreens/memberDetailScreen/payement_card.dart';
import 'package:library_management/screens/studentScreens/memberDetailScreen/profile_card.dart';

class MemberDetailedScreen extends StatelessWidget {
  const MemberDetailedScreen({super.key, required this.member});

  final StudentModel member;

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
                      name: member.name,
                      phone: member.phone,
                      id: member.idProof,
                      number: 1,
                    ),

                    SizedBox(height: 18 * scale),

                    // CALL, WHATSAPP, MESSAGE, & RENEW
                    ActionCard(
                      scale: scale,
                      phone: member.phone,
                      message: 'Hi',
                    ),

                    SizedBox(height: 24 * scale),

                    //JOIN-DATE, EXPIRE-DATE, PLAN & PROGRAM
                    MembershipCard(
                      scale: scale,
                      joinDate: _formattedDate(member.joiningDate),
                      expireDate: _formattedDate(member.currentExpireDate),
                      plan: member.currentPlan,
                      program: '${member.currentProgramDays.toString()} Days',
                    ),

                    SizedBox(height: 24 * scale),

                    //AMOUNT, PENDING, & DISCOUNT
                    PaymentCard(
                      scale: scale,
                      amount: member.totalPaid.toInt().toString(),
                      discount: member.totalDiscount.toInt().toString(),
                      pending: member.totalPending.toInt().toString(),
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
