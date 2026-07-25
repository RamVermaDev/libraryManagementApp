import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/screens/taskScreen/field/task_text_field.dart';
import 'package:library_management/screens/taskScreen/field/title_text.dart';

class AdditionalSection extends StatefulWidget {
  const AdditionalSection({
    super.key,
    required this.amountController,
    required this.discountController,
    required this.pendingController,
    required this.scale,
    required this.noteController,
  });

  final TextEditingController amountController;
  final TextEditingController discountController;
  final TextEditingController pendingController;
  final TextEditingController noteController;

  final double scale;

  @override
  State<AdditionalSection> createState() => _AdditionalSectionState();
}

class _AdditionalSectionState extends State<AdditionalSection>
    with TickerProviderStateMixin {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final scale = widget.scale;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
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
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Icon(
                    Icons.payments_outlined,
                    color: AppColors.primary,
                    size: 22 * scale,
                  ),

                  SizedBox(width: 12 * scale),

                  const Expanded(
                    child: Text(
                      "Additional Information",
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _isExpanded
                ? Column(
                    children: [
                      const Divider(
                        height: .2,
                        thickness: 1,
                        color: AppColors.grey200,
                      ),
                      SizedBox(height: 22 * scale),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const TitleText(
                                  title: "Discount",
                                  fontColor: AppColors.grey500,
                                  fontSize: 12,
                                  weight: FontWeight.w400,
                                ),

                                const SizedBox(height: 4),

                                TaskTextField(
                                  controller: widget.discountController,
                                  hintText: "₹",
                                  keyboardType: TextInputType.number,
                                  fillColor: AppColors.background,
                                  suffixIcon: Icon(
                                    Icons.local_offer_outlined,
                                    color: AppColors.iconMuted,
                                    size: 20 * scale,
                                  ),
                                  validator: (value) {
                                    if (value != null &&
                                        value.trim().isNotEmpty) {
                                      final val = double.tryParse(value.trim());
                                      if (val == null) return "Invalid number";
                                      if (val < 0) return "Cannot be negative";
                                      final amount = double.tryParse(
                                            widget.amountController.text
                                                .trim(),
                                          ) ??
                                          0;
                                      if (val > amount) {
                                        return "Exceeds fee (₹${amount.toStringAsFixed(0)})";
                                      }
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),

                          SizedBox(width: 16 * scale),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const TitleText(
                                  title: "Pending",
                                  fontColor: AppColors.grey500,
                                  fontSize: 12,
                                  weight: FontWeight.w400,
                                ),

                                const SizedBox(height: 4),

                                TaskTextField(
                                  controller: widget.pendingController,
                                  hintText: "₹",
                                  keyboardType: TextInputType.number,
                                  fillColor: AppColors.background,
                                  suffixIcon: Icon(
                                    Icons.hourglass_bottom_rounded,
                                    color: AppColors.iconMuted,
                                    size: 20 * scale,
                                  ),
                                  validator: (value) {
                                    if (value != null &&
                                        value.trim().isNotEmpty) {
                                      final pending =
                                          double.tryParse(value.trim());
                                      if (pending == null) {
                                        return "Invalid number";
                                      }
                                      if (pending < 0) {
                                        return "Cannot be negative";
                                      }
                                      final amount = double.tryParse(
                                            widget.amountController.text
                                                .trim(),
                                          ) ??
                                          0;
                                      final discount = double.tryParse(
                                            widget.discountController.text
                                                .trim(),
                                          ) ??
                                          0;
                                      final finalFee = amount - discount;
                                      if (pending > finalFee) {
                                        return "Exceeds final fee (₹${finalFee.toStringAsFixed(0)})";
                                      }
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16 * scale),

                      const TitleText(
                        title: "Note",
                        fontColor: AppColors.grey500,
                        fontSize: 12,
                        weight: FontWeight.w400,
                      ),

                      const SizedBox(height: 4),

                      TaskTextField(
                        controller: widget.noteController,
                        hintText: "e.g. anything",
                        keyboardType: TextInputType.name,
                        fillColor: AppColors.background,
                        minLines: 3,
                        maxLines: 4,
                        suffixIcon: Icon(
                          Icons.note_outlined,
                          color: AppColors.iconMuted,
                          size: 20 * scale,
                        ),
                      ),

                      SizedBox(height: 8),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
