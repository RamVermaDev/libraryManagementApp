import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/models/slot_availability_model.dart';
import 'package:library_management/screens/studentScreens/add_student_screens/slot_card_selected.dart';
import 'package:library_management/screens/studentScreens/add_student_screens/end_student_date_field.dart';
import 'package:library_management/screens/studentScreens/add_student_screens/start_student_date_field.dart';
import 'package:library_management/screens/taskScreen/field/task_text_field.dart';
import 'package:library_management/screens/taskScreen/field/title_text.dart';

class MembershipSection extends StatelessWidget {
  const MembershipSection({
    super.key,
    required this.expiryDate,
    required this.selectedPlan,
    required this.onPlanChanged,
    required this.onStartDateChanged,
    required this.onExpiryDateChanged,
    required this.scale,
    required this.planDuration,
    required this.onPlanValueChanged,
    required this.slotAvailabilityModel,
    required this.amountController,
    // required this.paymentMethod,
    // required this.onPaymentMethodChanged,
    required this.selectedPayment,
    required this.onPaymentChanged, required this.startDate,
  });

  final TextEditingController amountController;
  // final String paymentMethod;
  // final ValueChanged<String> onPaymentMethodChanged;

  final TextEditingController planDuration;
  final ValueChanged<String> onPlanValueChanged;

  final DateTime startDate;
  final DateTime expiryDate;

  final ValueChanged<DateTime> onStartDateChanged;
  final ValueChanged<DateTime> onExpiryDateChanged;

  final String selectedPlan;
  final ValueChanged<String> onPlanChanged;

  final String selectedPayment;
  final ValueChanged<String> onPaymentChanged;

  final double scale;

  final SlotAvailabilityModel slotAvailabilityModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16 * scale),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16 * scale),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),

          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                color: AppColors.primary,
                size: 22 * scale,
              ),

              SizedBox(width: 12 * scale),

              const Expanded(
                child: Text(
                  "Plan and Subscription",
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          const Divider(height: 0.2, thickness: 1, color: AppColors.grey200),

          SizedBox(height: 22 * scale),

          const TitleText(
            title: "Plan Duration",
            fontColor: AppColors.grey500,
            fontSize: 12,
            weight: FontWeight.w400,
          ),

          const SizedBox(height: 4),

          Row(
            children: [
              Expanded(
                child: TaskTextField(
                  hintText: '30',
                  controller: planDuration,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  fillColor: AppColors.background,
                  suffixIcon: Icon(
                    Icons.calendar_view_month_outlined,
                    color: AppColors.iconMuted,
                    size: 20 * scale,
                  ),
                  onChanged: onPlanValueChanged,
                ),
              ),

              SizedBox(width: 16 * scale),

              Expanded(
                child: PopupMenuButton<String>(
                  position: PopupMenuPosition.under,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onSelected: onPlanChanged,
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: "Monthly", child: Text("Monthly")),
                    PopupMenuItem(value: "Quarterly", child: Text("Quarterly")),
                    PopupMenuItem(
                      value: "Halfyearly",
                      child: Text("Halfyearly"),
                    ),
                    PopupMenuItem(value: "Yearly", child: Text("Yearly")),
                  ],
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          selectedPlan,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 20,
                          color: AppColors.iconMuted,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 16 * scale),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TitleText(
                      title: "Start Date",
                      fontColor: AppColors.grey500,
                      fontSize: 12,
                      weight: FontWeight.w400,
                    ),

                    SizedBox(height: 4),
                    StartStudentDateField(onDateChanged: onStartDateChanged),
                  ],
                ),
              ),

              SizedBox(width: 16 * scale),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TitleText(
                      title: "Expiry Date",
                      fontColor: AppColors.grey500,
                      fontSize: 12,
                      weight: FontWeight.w400,
                    ),
                    SizedBox(height: 4),
                    EndStudentDateField(
                      startDate: startDate,
                      initialDate: expiryDate,
                      onDateChanged: onExpiryDateChanged,
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 16 * scale),

          SlotCardSelected(
            scale: scale,
            time: slotAvailabilityModel.formattedTime,
            name: slotAvailabilityModel.name,
            price: slotAvailabilityModel.formattedPrice,
            availableSeats: slotAvailabilityModel.availableSeats,
            isSelected: false,
          ),

          SizedBox(height: 16 * scale),

          Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TitleText(
                      title: "Amount",
                      fontColor: AppColors.grey500,
                      fontSize: 12,
                      weight: FontWeight.w400,
                    ),

                    const SizedBox(height: 4),

                    TaskTextField(
                      controller: amountController,
                      hintText: "e.g. 1500",
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      fillColor: AppColors.background,
                      suffixIcon: Icon(
                        Icons.currency_rupee,
                        color: AppColors.iconMuted,
                        size: 20 * scale,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter fee amount";
                        }

                        final amount = double.tryParse(value);

                        if (amount == null || amount <= 0) {
                          return "Invalid amount";
                        }

                        return null;
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(width: 16 * scale),

              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const TitleText(
                      title: "Payment",
                      fontColor: AppColors.grey500,
                      fontSize: 12,
                      weight: FontWeight.w400,
                    ),
                    const SizedBox(height: 4),

                    PopupMenuButton<String>(
                      position: PopupMenuPosition.under,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onSelected: onPaymentChanged,
                      itemBuilder: (context) => const [
                        PopupMenuItem(value: "Cash", child: Text("Cash")),
                        PopupMenuItem(value: "Online", child: Text("Online")),
                      ],
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,

                          children: [
                            Text(
                              selectedPayment,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 20,
                              color: AppColors.iconMuted,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 8 * scale),
        ],
      ),
    );
  }
}
