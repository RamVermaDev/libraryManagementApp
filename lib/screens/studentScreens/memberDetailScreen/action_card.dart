import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/screens/studentScreens/memberDetailScreen/action_item.dart';
import 'package:library_management/services/external_app_service.dart';

class PendingResolutionResult {
  final String action; // 'paid' or 'discount'
  final double amount;
  final String? paymentMode; // 'Cash' or 'Online'
  final String? note;

  PendingResolutionResult({
    required this.action,
    required this.amount,
    this.paymentMode,
    this.note,
  });
}

class ActionCard extends StatelessWidget {
  const ActionCard({
    super.key,
    required this.scale,
    required this.phone,
    required this.message,
    required this.pending,
    required this.totalPaid,
    required this.expiryDate,
    this.isPaused = false,
    this.isBlacklisted = false,
    this.onPendingAction,
    this.onRefund,
    this.onRenew,
    this.onPause,
    this.onResume,
    this.onBlacklist,
    this.onUnblock,
  });

  final double scale;
  final String phone;
  final String message;
  final double pending;
  final double totalPaid;
  final DateTime expiryDate;
  final bool isPaused;
  final bool isBlacklisted;
  final Future<void> Function(PendingResolutionResult result)? onPendingAction;
  final VoidCallback? onRefund;
  final VoidCallback? onRenew;
  final VoidCallback? onPause;
  final VoidCallback? onResume;
  final VoidCallback? onBlacklist;
  final VoidCallback? onUnblock;

  @override
  Widget build(BuildContext context) {
    final bool isExpired = expiryDate.isBefore(DateTime.now());
    final bool isActive = !isExpired;
    final bool canRenew =
        expiryDate.difference(DateTime.now()).inDays <= 10 && !isBlacklisted;
    return Container(
      height: 90 * scale,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14 * scale),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10 * scale,
            offset: Offset(0, 4 * scale),
            spreadRadius: 0,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SizedBox(
              width: 90 * scale,
              child: ActionItem(
                scale: scale,
                iconImage: 'assets/icons/call.png',
                label: 'Call',
                color: AppColors.primary,
                onTap: () async {
                  await ExternalAppService.makePhoneCall(phone);
                },
              ),
            ),

            _ActionDivider(scale: scale),

            SizedBox(
              width: 90 * scale,
              child: ActionItem(
                scale: scale,
                iconImage: 'assets/icons/whatsapp.png',
                label: 'WhatsApp',
                color: AppColors.whatsapp,
                onTap: () async {
                  await ExternalAppService.openWhatsApp(
                    phoneNumber: phone,
                    message: message,
                  );
                },
              ),
            ),

            _ActionDivider(scale: scale),

            SizedBox(
              width: 90 * scale,
              child: ActionItem(
                scale: scale,
                icon: Icons.forum_outlined,
                label: 'Message',
                color: AppColors.primary,
                onTap: () async {
                  await ExternalAppService.sendSms(
                    phoneNumber: phone,
                    message: message,
                  );
                },
              ),
            ),

            _ActionDivider(scale: scale),

            SizedBox(
              width: 90 * scale,
              child: ActionItem(
                scale: scale,
                iconImage: 'assets/icons/refund.png',
                label: 'Renew',
                color: canRenew ? AppColors.purple : AppColors.grey200,
                labelColor: canRenew ? AppColors.purple : AppColors.grey400,
                onTap: canRenew ? onRenew : null,
              ),
            ),

            _ActionDivider(scale: scale),

            SizedBox(
              width: 90 * scale,
              child: ActionItem(
                scale: scale,
                iconImage: 'assets/icons/pending.png',
                label: 'Pending',
                color: pending > 0 ? AppColors.purple : AppColors.grey200,
                labelColor: pending > 0 ? AppColors.purple : AppColors.grey400,
                onTap: pending > 0
                    ? () async {
                        final result =
                            await showModalBottomSheet<PendingResolutionResult>(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) => PendingResolutionBottomSheet(
                                totalPending: pending,
                                onSubmit: onPendingAction,
                              ),
                            );

                        if (result != null && onPendingAction != null) {
                          await onPendingAction!(result);
                        }
                      }
                    : null,
              ),
            ),

            _ActionDivider(scale: scale),

            SizedBox(
              width: 90 * scale,
              child: ActionItem(
                scale: scale,
                iconImage: 'assets/icons/refund.png',
                label: 'Refund',
                color: totalPaid > 0 ? AppColors.error : AppColors.grey200,
                labelColor: totalPaid > 0 ? AppColors.error : AppColors.grey400,
                onTap: totalPaid > 0 ? onRefund : null,
              ),
            ),

            _ActionDivider(scale: scale),

            SizedBox(
              width: 90 * scale,
              child: ActionItem(
                scale: scale,
                icon: isPaused
                    ? Icons.play_circle_outline_rounded
                    : Icons.pause_circle_outline_rounded,
                label: isPaused ? 'Resume' : 'Pause',
                color: isPaused
                    ? AppColors.success
                    : (isActive ? AppColors.warning : AppColors.grey200),
                labelColor: isPaused
                    ? AppColors.success
                    : (isActive ? AppColors.warning : AppColors.grey400),
                onTap: isPaused ? onResume : (isActive ? onPause : null),
              ),
            ),

            _ActionDivider(scale: scale),

            SizedBox(
              width: 90 * scale,
              child: ActionItem(
                scale: scale,
                icon: isBlacklisted
                    ? Icons.lock_open_rounded
                    : Icons.block_rounded,
                label: isBlacklisted ? 'Unblock' : 'Blacklist',
                color: isBlacklisted
                    ? AppColors.success
                    : (isActive ? AppColors.error : AppColors.grey200),
                labelColor: isBlacklisted
                    ? AppColors.success
                    : (isActive ? AppColors.error : AppColors.grey400),
                onTap: isBlacklisted
                    ? onUnblock
                    : (isActive ? onBlacklist : null),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PendingResolutionBottomSheet extends StatefulWidget {
  final double totalPending;
  final Future<void> Function(PendingResolutionResult result)? onSubmit;

  const PendingResolutionBottomSheet({
    super.key,
    required this.totalPending,
    this.onSubmit,
  });

  @override
  State<PendingResolutionBottomSheet> createState() =>
      _PendingResolutionBottomSheetState();
}

class _PendingResolutionBottomSheetState
    extends State<PendingResolutionBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  late TextEditingController _noteController;

  String _selectedAction = 'paid'; // 'paid' or 'discount'
  String _selectedPaymentMode = 'Cash'; // 'Cash' or 'Online'
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.totalPending > 0
          ? (widget.totalPending % 1 == 0
                ? widget.totalPending.toInt().toString()
                : widget.totalPending.toStringAsFixed(0))
          : '0',
    );
    _noteController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _handleConfirm() async {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.tryParse(_amountController.text.trim()) ?? 0;
    if (amount <= 0 || amount > widget.totalPending) return;

    final result = PendingResolutionResult(
      action: _selectedAction,
      amount: amount,
      paymentMode: _selectedAction == 'paid' ? _selectedPaymentMode : null,
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
    );

    if (widget.onSubmit != null) {
      setState(() {
        _isLoading = true;
      });
      try {
        await widget.onSubmit!(result);
        if (mounted) {
          Navigator.pop(context);
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } else {
      Navigator.pop(context, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final isPaid = _selectedAction == 'paid';

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(20, 12, 20, 20 + bottomInset),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle Bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title and Pending Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Resolve Pending Fee",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Text(
                      "Pending: ₹${widget.totalPending % 1 == 0 ? widget.totalPending.toInt() : widget.totalPending.toStringAsFixed(0)}",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.red.shade700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Action Switcher (Paid vs Discount)
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedAction = 'paid';
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: isPaid
                                ? AppColors.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Mark as Paid",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isPaid
                                  ? Colors.white
                                  : Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedAction = 'discount';
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: !isPaid
                                ? Colors.orange.shade700
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Apply Discount",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: !isPaid
                                  ? Colors.white
                                  : Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Payment Mode Selection (Only if Paid)
              if (isPaid) ...[
                const Text(
                  "Payment Mode",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildPaymentModeChip(
                        mode: 'Cash',
                        icon: Icons.payments_outlined,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildPaymentModeChip(
                        mode: 'Online',
                        icon: Icons.account_balance_wallet_outlined,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
              ],

              // Amount Field
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Amount to Clear",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _amountController.text = widget.totalPending % 1 == 0
                            ? widget.totalPending.toInt().toString()
                            : widget.totalPending.toStringAsFixed(0);
                      });
                    },
                    child: Text(
                      "Clear Full (₹${widget.totalPending % 1 == 0 ? widget.totalPending.toInt() : widget.totalPending.toStringAsFixed(0)})",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixText: '₹ ',
                  prefixStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  hintText: 'Enter amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an amount';
                  }
                  final val = double.tryParse(value.trim());
                  if (val == null || val <= 0) {
                    return 'Enter a valid amount';
                  }
                  if (val > widget.totalPending) {
                    return 'Amount cannot exceed total pending (₹${widget.totalPending})';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Note Field
              const Text(
                "Note (Optional)",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _noteController,
                maxLength: 150,
                decoration: InputDecoration(
                  hintText: 'e.g. Paid via PhonePe or Special Discount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  counterText: '',
                ),
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isPaid
                        ? AppColors.primary
                        : Colors.orange.shade700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SpinKitThreeBounce(color: Colors.white, size: 24)
                      : Text(
                          isPaid ? "Confirm Payment" : "Confirm Discount",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentModeChip({required String mode, required IconData icon}) {
    final isSelected = _selectedPaymentMode == mode;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMode = mode;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? AppColors.primary : Colors.grey.shade600,
            ),
            const SizedBox(width: 8),
            Text(
              mode,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppColors.primary : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionDivider extends StatelessWidget {
  final double scale;

  const _ActionDivider({required this.scale});

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 60 * scale, color: AppColors.divider);
  }
}
