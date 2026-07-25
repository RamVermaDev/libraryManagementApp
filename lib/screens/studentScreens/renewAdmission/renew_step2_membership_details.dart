import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/models/slot_availability_model.dart';
import 'package:library_management/models/student_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management/provider/seat_availability_provider.dart';
import 'package:library_management/provider/slot_availability_provider.dart';
import 'package:library_management/screens/studentScreens/add_student_screens/additional_section.dart';
import 'package:library_management/screens/studentScreens/add_student_screens/membership_section.dart';
import 'package:library_management/screens/studentScreens/renewAdmission/renew_student_info_card.dart';

class RenewStep2MembershipDetails extends ConsumerWidget {
  const RenewStep2MembershipDetails({
    super.key,
    required this.formKey,
    required this.member,
    required this.scale,
    required this.selectedSlotModel,
    required this.selectedSeatId,
    required this.amountController,
    required this.discountController,
    required this.pendingController,
    required this.noteController,
    required this.planDurationController,
    required this.selectedPlan,
    required this.paymentMode,
    required this.startDate,
    required this.expireDate,
    required this.isSubmitting,
    required this.onPlanChanged,
    required this.onPlanValueChanged,
    required this.onStartDateChanged,
    required this.onExpiryDateChanged,
    required this.onPaymentChanged,
    required this.onChangeSlotSeat,
    required this.onSubmit,
    this.previousSlotDisplay,
    this.previousSeatDisplay,
  });

  final GlobalKey<FormState> formKey;
  final StudentModel member;
  final double scale;
  final SlotAvailabilityModel? selectedSlotModel;
  final String? selectedSeatId;
  final TextEditingController amountController;
  final TextEditingController discountController;
  final TextEditingController pendingController;
  final TextEditingController noteController;
  final TextEditingController planDurationController;
  final String selectedPlan;
  final String paymentMode;
  final DateTime startDate;
  final DateTime expireDate;
  final bool isSubmitting;
  final String? previousSlotDisplay;
  final String? previousSeatDisplay;

  final ValueChanged<String> onPlanChanged;
  final ValueChanged<String> onPlanValueChanged;
  final ValueChanged<DateTime> onStartDateChanged;
  final ValueChanged<DateTime> onExpiryDateChanged;
  final ValueChanged<String> onPaymentChanged;
  final VoidCallback onChangeSlotSeat;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final slots = ref.watch(slotAvailabilityProvider);
    final seats = ref.watch(seatAvailabilityProvider);

    final matchingSlot = slots
        .where((s) => s.slotTemplateId == member.slotTemplateId)
        .firstOrNull;
    final slotDisplay = previousSlotDisplay ??
        (matchingSlot != null
            ? '${matchingSlot.name} (${matchingSlot.formattedTime})'
            : null);

    final matchingSeat =
        seats.where((s) => s.seatId == member.seatId).firstOrNull;
    final seatDisplay = previousSeatDisplay ??
        (member.seatId == null
            ? 'No seat (Overbooked)'
            : (matchingSeat != null ? 'Seat ${matchingSeat.displayLabel}' : null));

    final selectedSeatModel = selectedSeatId != null
        ? seats.where((s) => s.seatId == selectedSeatId).firstOrNull
        : null;

    final selectedSeatText = selectedSeatId != null
        ? (selectedSeatModel != null
            ? 'Seat ${selectedSeatModel.displayLabel}'
            : 'Seat Selected')
        : 'No Seat (Overbooking)';

    return Form(
      key: formKey,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          14 * scale,
          16 * scale,
          14 * scale,
          40 * scale,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Student Info Header
            RenewStudentInfoCard(
              member: member,
              scale: scale,
              slotDisplay: slotDisplay,
              seatDisplay: seatDisplay,
            ),

            SizedBox(height: 16 * scale),

            // Selected Slot & Seat Summary Card with Change Option
            Container(
              padding: EdgeInsets.all(14 * scale),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16 * scale),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10 * scale),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.event_seat_rounded,
                      color: AppColors.primary,
                      size: 20 * scale,
                    ),
                  ),
                  SizedBox(width: 12 * scale),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedSlotModel?.formattedTime ?? 'Selected Slot',
                          style: TextStyle(
                            fontSize: 14 * scale,
                            fontWeight: FontWeight.bold,
                            color: AppColors.heading,
                          ),
                        ),
                        SizedBox(height: 2 * scale),
                        Text(
                          selectedSeatText,
                          style: TextStyle(
                            fontSize: 12 * scale,
                            color: AppColors.grey600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton.icon(
                    onPressed: onChangeSlotSeat,
                    icon: Icon(
                      Icons.edit_outlined,
                      size: 15 * scale,
                      color: AppColors.primary,
                    ),
                    label: Text(
                      'Change',
                      style: TextStyle(
                        fontSize: 13 * scale,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20 * scale),

            // Membership Section
            if (selectedSlotModel != null)
              MembershipSection(
                amountController: amountController,
                planDuration: planDurationController,
                onPlanChanged: onPlanChanged,
                onPlanValueChanged: onPlanValueChanged,
                selectedPlan: selectedPlan,
                onStartDateChanged: onStartDateChanged,
                onExpiryDateChanged: onExpiryDateChanged,
                startDate: startDate,
                expiryDate: expireDate,
                slotAvailabilityModel: selectedSlotModel!,
                selectedPayment: paymentMode,
                onPaymentChanged: onPaymentChanged,
                scale: scale,
              ),

            SizedBox(height: 20 * scale),

            // Additional Section
            AdditionalSection(
              amountController: amountController,
              discountController: discountController,
              pendingController: pendingController,
              noteController: noteController,
              scale: scale,
            ),

            SizedBox(height: 28 * scale),

            // Final Submit Button
            SizedBox(
              width: double.infinity,
              height: 52 * scale,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14 * scale),
                  ),
                  elevation: 0,
                ),
                onPressed: isSubmitting ? null : onSubmit,
                child: isSubmitting
                    ? const SpinKitThreeBounce(
                        color: Colors.white,
                        size: 14,
                      )
                    : Text(
                        'Renew Admission',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 15 * scale,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
