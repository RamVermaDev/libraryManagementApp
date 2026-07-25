import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/models/student_model.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Result returned to the caller
// ─────────────────────────────────────────────────────────────────────────────

class RefundResult {
  final double refundAmount;
  final String paymentMode;
  final String? note;

  const RefundResult({
    required this.refundAmount,
    required this.paymentMode,
    this.note,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Public entry point
// ─────────────────────────────────────────────────────────────────────────────

Future<RefundResult?> showRefundBottomSheet({
  required BuildContext context,
  required StudentModel member,
}) {
  return showModalBottomSheet<RefundResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _RefundSheet(member: member),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Internal sheet widget
// ─────────────────────────────────────────────────────────────────────────────

class _RefundSheet extends StatefulWidget {
  const _RefundSheet({required this.member});
  final StudentModel member;

  @override
  State<_RefundSheet> createState() => _RefundSheetState();
}

class _RefundSheetState extends State<_RefundSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  String _paymentMode = 'Cash';

  // ── calculated values ──────────────────────────────────────────────────────
  late final int _planDays;
  late final int _daysUsed;
  late final int _daysLeft;
  late final double _dailyRate;
  late final double _suggestedRefund;
  late final double _maxRefund;
  late final double _pending;

  @override
  void initState() {
    super.initState();
    _compute();
    _amountCtrl.text = _suggestedRefund.toStringAsFixed(0);
  }

  void _compute() {
    final today = DateTime.now();
    final start = widget.member.currentStartDate ?? today;
    _planDays = widget.member.currentPlanDays ?? 0;
    _pending = widget.member.totalPending;
    _maxRefund = widget.member.totalPaid;

    // Days used (capped at plan length so we never go negative on days left)
    _daysUsed = today.difference(start).inDays.clamp(0, _planDays);
    _daysLeft = _planDays - _daysUsed;

    // finalAmount = paid + pending  (what the plan was priced at in total)
    final finalAmount = widget.member.totalPaid + _pending;
    _dailyRate = _planDays > 0 ? finalAmount / _planDays : 0;

    // Suggested refund = value of remaining days, capped by what was paid
    _suggestedRefund =
        (_dailyRate * _daysLeft).clamp(0, _maxRefund).floorToDouble();
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  void _confirm() {
    if (!_formKey.currentState!.validate()) return;
    final amount = double.tryParse(_amountCtrl.text.trim()) ?? 0;
    Navigator.pop(
      context,
      RefundResult(
        refundAmount: amount,
        paymentMode: _paymentMode,
        note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
      ),
    );
  }

  // ── UI helpers ─────────────────────────────────────────────────────────────

  Widget _summaryRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.body,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: valueColor ?? AppColors.heading,
            ),
          ),
        ],
      ),
    );
  }

  Widget _modeChip(String label, IconData icon) {
    final selected = _paymentMode == label;
    return GestureDetector(
      onTap: () => setState(() => _paymentMode = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.grey100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 15,
              color: selected ? Colors.white : AppColors.body,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : AppColors.body,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final noRefundPossible = _maxRefund <= 0;
    final planExpiredOrEmpty = _planDays == 0;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(24, 0, 24, 24 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── drag handle ───────────────────────────────────────────────────
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 20),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // ── title ─────────────────────────────────────────────────────────
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.errorLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.currency_rupee_rounded,
                  color: AppColors.error,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Process Refund',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.heading,
                    ),
                  ),
                  Text(
                    widget.member.name,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.body,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          if (noRefundPossible || planExpiredOrEmpty) ...[
            // ── no refund state ────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.warningLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.warning,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      noRefundPossible
                          ? 'No amount has been paid. Nothing to refund.'
                          : 'No plan data available to calculate refund.',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.warning,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ),
          ] else ...[
            // ── summary card ───────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _summaryRow('Plan Duration', '$_planDays days'),
                  _divider(),
                  _summaryRow('Days Used', '$_daysUsed days'),
                  _summaryRow(
                    'Days Remaining',
                    '$_daysLeft days',
                    valueColor: _daysLeft > 0
                        ? AppColors.success
                        : AppColors.caption,
                  ),
                  _divider(),
                  _summaryRow(
                    'Daily Rate',
                    '₹${_dailyRate.toStringAsFixed(1)}/day',
                  ),
                  _summaryRow(
                    'Suggested Refund',
                    '₹${_suggestedRefund.toStringAsFixed(0)}',
                    valueColor: AppColors.primary,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── refund amount ────────────────────────────────────────
                  _label('Refund Amount'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _amountCtrl,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d{0,2}')),
                    ],
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.heading,
                    ),
                    decoration: InputDecoration(
                      prefixText: '₹  ',
                      prefixStyle: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.body,
                      ),
                      suffixText: 'max ₹${_maxRefund.toStringAsFixed(0)}',
                      suffixStyle: const TextStyle(
                        fontSize: 12,
                        color: AppColors.caption,
                      ),
                      filled: true,
                      fillColor: AppColors.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                            color: AppColors.primary, width: 1.5),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: AppColors.error),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide:
                            const BorderSide(color: AppColors.error, width: 1.5),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                    ),
                    validator: (v) {
                      final val = double.tryParse(v?.trim() ?? '');
                      if (val == null || val <= 0) {
                        return 'Enter a valid amount';
                      }
                      if (val > _maxRefund) {
                        return 'Cannot exceed ₹${_maxRefund.toStringAsFixed(0)} (total paid)';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // ── payment mode ─────────────────────────────────────────
                  _label('Payment Mode'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _modeChip('Cash', Icons.payments_outlined),
                      const SizedBox(width: 10),
                      _modeChip('Online', Icons.phone_android_outlined),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ── note ─────────────────────────────────────────────────
                  _label('Note  (optional)'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _noteCtrl,
                    maxLines: 2,
                    maxLength: 200,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.heading,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Reason for refund...',
                      hintStyle: const TextStyle(color: AppColors.caption),
                      filled: true,
                      fillColor: AppColors.background,
                      counterStyle:
                          const TextStyle(fontSize: 11, color: AppColors.caption),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                            color: AppColors.primary, width: 1.5),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  ),

                  // ── pending waiver banner ─────────────────────────────────
                  if (_pending > 0) ...[
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.warningLight,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: AppColors.warning.withValues(alpha: 0.35)),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline_rounded,
                            color: AppColors.warning,
                            size: 15,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Pending ₹${_pending.toStringAsFixed(0)} will be waived as reservation is cancelled.',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.warning,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // ── confirm button ────────────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _confirm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        disabledBackgroundColor: AppColors.grey200,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Confirm Refund',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _label(String text) => Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.body,
        ),
      );

  Widget _divider() =>
      const Divider(height: 14, thickness: 1, color: AppColors.divider);
}
