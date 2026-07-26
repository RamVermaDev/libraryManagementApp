import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/context_extension.dart';
import 'package:library_management/controllers/seat_availability_controller.dart';
import 'package:library_management/controllers/slot_availability_controller.dart';
import 'package:library_management/controllers/student_controller.dart';
import 'package:library_management/models/seat_availability_model.dart';
import 'package:library_management/models/slot_availability_model.dart';
import 'package:library_management/models/student_model.dart';
import 'package:library_management/provider/current_library_provider.dart';
import 'package:library_management/provider/seat_availability_provider.dart';
import 'package:library_management/provider/slot_availability_provider.dart';
import 'package:library_management/screens/studentScreens/renewAdmission/renew_confirm_dialog.dart';
import 'package:library_management/screens/studentScreens/renewAdmission/renew_step1_slot_and_seat.dart';
import 'package:library_management/screens/studentScreens/renewAdmission/renew_step2_membership_details.dart';

class RenewAdmissionScreen extends ConsumerStatefulWidget {
  const RenewAdmissionScreen({super.key, required this.member, this.onRenewed});

  final StudentModel member;
  final void Function(StudentModel updatedStudent)? onRenewed;

  @override
  ConsumerState<RenewAdmissionScreen> createState() =>
      _RenewAdmissionScreenState();
}

class _RenewAdmissionScreenState extends ConsumerState<RenewAdmissionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _studentController = StudentController();
  final _slotController = SlotAvailabilityController();
  final _seatController = SeatAvailabilityController();

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _seatSectionKey = GlobalKey();

  // Current Step: 0 = Slot & Seat Selection, 1 = Membership & Financial Details
  int _currentStep = 0;

  // Text controllers
  final _amountController = TextEditingController();
  final _discountController = TextEditingController();
  final _pendingController = TextEditingController();
  final _noteController = TextEditingController();
  final _planDurationController = TextEditingController();

  // Plan state
  int _selectedPlanDays = 30;
  String _selectedPlan = 'Monthly';
  String _paymentMode = 'Cash';

  // Dates — start = day after current expiry for natural renewal
  late DateTime _startDate;
  late DateTime _expireDate;

  // Slot / seat
  String? _selectedSlotId;
  SlotAvailabilityModel? _selectedSlotModel;
  String? _selectedSeatId;

  // Loading flags
  bool _isLoadingSlots = true;
  bool _isLoadingSeat = false;
  bool _isSubmitting = false;

  // Warning banners
  bool _slotFullWarning = false;
  bool _seatTakenWarning = false;

  // Previous slot & seat display state
  String? _previousSlotDisplay;
  String? _previousSeatDisplay;

  static const Map<String, int> _planDays = {
    'Monthly': 30,
    'Quarterly': 90,
    'Halfyearly': 180,
    'Yearly': 360,
  };

  @override
  void initState() {
    super.initState();

    final expiry = widget.member.currentExpireDate;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (expiry != null) {
      final expiryLocal = expiry.toLocal();
      final expiryDateOnly = DateTime(
        expiryLocal.year,
        expiryLocal.month,
        expiryLocal.day,
      );

      final daysSinceExpiry = today.difference(expiryDateOnly).inDays;

      if (daysSinceExpiry > 30) {
        // Expired more than 30 days ago -> start fresh from today
        _startDate = today;
      } else {
        // Active in future OR expired within last 30 days -> start day after expiry
        _startDate = expiryDateOnly.add(const Duration(days: 1));
      }
    } else {
      _startDate = today;
    }

    _selectedPlanDays = 30;
    _planDurationController.text = '30';
    _expireDate = _startDate.add(Duration(days: _selectedPlanDays - 1));

    // Pre-select current slot
    _selectedSlotId = widget.member.slotTemplateId;

    Future.microtask(() async {
      // Clear providers from any previous screen visit
      ref.read(selectedSlotIdProvider.notifier).state = _selectedSlotId;
      ref.read(selectedSeatIdProvider.notifier).state = null;
      ref.read(slotAvailabilityProvider.notifier).clearSlots();
      ref.read(seatAvailabilityProvider.notifier).clearSeats();

      await _loadSlots();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _amountController.dispose();
    _discountController.dispose();
    _pendingController.dispose();
    _noteController.dispose();
    _planDurationController.dispose();
    super.dispose();
  }

  // ─── Helpers ────────────────────────────────────────────────────────────────

  void _calculateExpireDate() {
    setState(() {
      _expireDate = _startDate.add(Duration(days: _selectedPlanDays - 1));
    });
  }

  void _calculateSelectedPlanDays() {
    setState(() {
      _selectedPlanDays = _expireDate.difference(_startDate).inDays + 1;
    });
  }

  double _roundUpToNext50(double amount) => (amount / 50).ceil() * 50.0;

  void _autoFillAmount() {
    final slot = _selectedSlotModel;
    if (slot == null) return;
    final amount = _roundUpToNext50(
      (slot.monthlyPrice / 30) * _selectedPlanDays,
    );
    _amountController.text = amount.toStringAsFixed(0);
  }

  void _scrollToKey(GlobalKey key, {double alignment = 0.0}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = key.currentContext;
      if (ctx == null) return;
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
        alignment: alignment,
      );
    });
  }

  // ─── Data Loading ────────────────────────────────────────────────────────────

  Future<void> _loadSlots() async {
    setState(() => _isLoadingSlots = true);
    final libraryId = ref.read(currentLibraryProvider);
    if (libraryId == null) {
      setState(() => _isLoadingSlots = false);
      return;
    }

    await _slotController.fetchSlotAvailability(
      context: context,
      ref: ref,
      libraryId: libraryId,
    );

    if (!mounted) return;

    final slots = ref.read(slotAvailabilityProvider);
    final oldSlotList = slots.where(
      (s) => s.slotTemplateId == widget.member.slotTemplateId,
    );
    if (oldSlotList.isNotEmpty) {
      final oldSlot = oldSlotList.first;
      _previousSlotDisplay = '${oldSlot.name} (${oldSlot.formattedTime})';
    }

    setState(() => _isLoadingSlots = false);

    // Pre-select the current slot after slots load
    if (_selectedSlotId != null) {
      final preSelected = slots.where(
        (s) => s.slotTemplateId == _selectedSlotId,
      );
      if (preSelected.isNotEmpty) {
        await _onSlotTap(preSelected.first, isPreselect: true);
      }
    }
  }

  Future<void> _onSlotTap(
    SlotAvailabilityModel slot, {
    bool isPreselect = false,
  }) async {
    final initialSeat =
        (isPreselect && slot.slotTemplateId == widget.member.slotTemplateId)
        ? widget.member.seatId
        : null;

    ref.read(selectedSlotIdProvider.notifier).state = slot.slotTemplateId;
    ref.read(selectedSeatIdProvider.notifier).state = initialSeat;
    ref.read(seatAvailabilityProvider.notifier).clearSeats();

    setState(() {
      _selectedSlotId = slot.slotTemplateId;
      _selectedSlotModel = slot;
      _selectedSeatId = initialSeat;
      _slotFullWarning = slot.isFull;
      _seatTakenWarning = false;
      _isLoadingSeat = true;
    });

    _autoFillAmount();

    final libraryId = ref.read(currentLibraryProvider);
    await _seatController.fetchSeatMap(
      context: context,
      ref: ref,
      libraryId: libraryId!,
      slotTemplateId: slot.slotTemplateId,
    );

    if (!mounted) return;

    final String? oldSeatId = widget.member.seatId;
    final bool isSameSlot = slot.slotTemplateId == widget.member.slotTemplateId;

    if (oldSeatId == null) {
      _previousSeatDisplay = 'No seat (Overbooking)';
    } else {
      final seats = ref.read(seatAvailabilityProvider);
      final oldSeatList = seats.where((s) => s.seatId == oldSeatId);
      if (oldSeatList.isNotEmpty) {
        final oldSeat = oldSeatList.first;
        _previousSeatDisplay = 'Seat ${oldSeat.displayLabel}';

        // Pre-select old seat ONLY if free in this slot OR if same slot & occupied by this student!
        if (oldSeat.isAvailable ||
            (isSameSlot && oldSeat.seatId == widget.member.seatId)) {
          ref.read(selectedSeatIdProvider.notifier).state = oldSeatId;
          setState(() {
            _selectedSeatId = oldSeatId;
            _seatTakenWarning = false;
          });
        } else {
          // Old seat taken by someone else in this new slot -> show warning banner
          ref.read(selectedSeatIdProvider.notifier).state = null;
          setState(() {
            _selectedSeatId = null;
            _seatTakenWarning = true;
          });
        }
      }
    }

    setState(() => _isLoadingSeat = false);

    if (!isPreselect) {
      _scrollToKey(_seatSectionKey, alignment: 0.0);
    }
  }

  void _onSeatTap(SeatAvailabilityModel seat) {
    if (!seat.isAvailable && seat.seatId != widget.member.seatId) return;
    final current = ref.read(selectedSeatIdProvider);
    final isDeselecting = current == seat.seatId;
    ref.read(selectedSeatIdProvider.notifier).state = isDeselecting
        ? null
        : seat.seatId;
    setState(() {
      _selectedSeatId = isDeselecting ? null : seat.seatId;
      _seatTakenWarning = false;
    });
  }

  // ─── Submit ──────────────────────────────────────────────────────────────────

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedSlotId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a slot')));
      return;
    }

    final amount = double.tryParse(_amountController.text.trim()) ?? 0;
    final discount = double.tryParse(_discountController.text.trim()) ?? 0;
    final pending = double.tryParse(_pendingController.text.trim()) ?? 0;
    final finalAmount = amount - discount;
    final paidAmount = finalAmount - pending;

    // Show confirmation dialog before submitting renewal
    final slotDisplay = _selectedSlotModel?.formattedTime ?? 'Selected Slot';
    final seats = ref.read(seatAvailabilityProvider);
    final selectedSeatModel = _selectedSeatId != null
        ? seats.where((s) => s.seatId == _selectedSeatId).firstOrNull
        : null;
    final seatDisplay = _selectedSeatId != null
        ? (selectedSeatModel != null
              ? selectedSeatModel.displayLabel
              : 'Seat Selected')
        : 'No Seat (Overbooking)';

    final bool? confirm = await RenewConfirmDialog.show(
      context,
      member: widget.member,
      slotDisplay: slotDisplay,
      seatDisplay: seatDisplay,
      planDays: _selectedPlanDays,
      startDate: _startDate,
      expireDate: _expireDate,
      amountText: _amountController.text,
      discountText: _discountController.text,
      paidAmountText: paidAmount.toStringAsFixed(0),
      pendingText: _pendingController.text,
    );

    if (confirm != true || !mounted) return;

    setState(() => _isSubmitting = true);

    try {
      final libraryId = ref.read(currentLibraryProvider);
      if (libraryId == null) return;

      final updatedStudent = await _studentController.renewStudent(
        context: context,
        ref: ref,
        libraryId: libraryId,
        studentId: widget.member.id!,
        oldStudent: widget.member,
        slotTemplateId: _selectedSlotId!,
        seatId: _selectedSeatId,
        currentPlanDays: _selectedPlanDays,
        startDate: DateTime.utc(
          _startDate.year,
          _startDate.month,
          _startDate.day,
        ),
        expireDate: DateTime.utc(
          _expireDate.year,
          _expireDate.month,
          _expireDate.day,
        ),
        amount: amount,
        discount: discount,
        paidAmount: paidAmount,
        paymentMode: paidAmount > 0 ? _paymentMode : null,
        notes: _noteController.text.trim().isEmpty
            ? null
            : _noteController.text.trim(),
      );

      if (updatedStudent != null && mounted) {
        widget.onRenewed?.call(updatedStudent);
        Navigator.pop(context);
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  // ─── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final double scale = context.scale;

    return PopScope(
      canPop: _currentStep == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_currentStep > 0) {
          setState(() => _currentStep = 0);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _currentStep == 0
                ? 'Renew - Select Slot & Seat'
                : 'Renew - Membership Details',
            style: TextStyle(
              fontSize: 18 * scale,
              fontWeight: FontWeight.bold,
              color: AppColors.heading,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () {
              if (_currentStep > 0) {
                setState(() => _currentStep = 0);
              } else {
                Navigator.pop(context);
              }
            },
          ),
          backgroundColor: Colors.white,
          elevation: 0.5,
        ),
        backgroundColor: AppColors.background,
        body: _currentStep == 0
            ? RenewStep1SlotAndSeat(
                member: widget.member,
                scale: scale,
                scrollController: _scrollController,
                seatSectionKey: _seatSectionKey,
                isLoadingSlots: _isLoadingSlots,
                isLoadingSeat: _isLoadingSeat,
                slotFullWarning: _slotFullWarning,
                seatTakenWarning: _seatTakenWarning,
                selectedSlotModel: _selectedSlotModel,
                onSlotTap: _onSlotTap,
                onSeatTap: _onSeatTap,
                onContinue: () {
                  setState(() => _currentStep = 1);
                },
                ref: ref,
                previousSlotDisplay: _previousSlotDisplay,
                previousSeatDisplay: _previousSeatDisplay,
              )
            : RenewStep2MembershipDetails(
                formKey: _formKey,
                member: widget.member,
                scale: scale,
                selectedSlotModel: _selectedSlotModel,
                selectedSeatId: _selectedSeatId,
                amountController: _amountController,
                discountController: _discountController,
                pendingController: _pendingController,
                noteController: _noteController,
                planDurationController: _planDurationController,
                selectedPlan: _selectedPlan,
                paymentMode: _paymentMode,
                startDate: _startDate,
                expireDate: _expireDate,
                isSubmitting: _isSubmitting,
                previousSlotDisplay: _previousSlotDisplay,
                previousSeatDisplay: _previousSeatDisplay,
                onPlanChanged: (value) {
                  setState(() {
                    _selectedPlan = value;
                    _selectedPlanDays = _planDays[value]!;
                    _planDurationController.text = _selectedPlanDays.toString();
                    _calculateExpireDate();
                    _autoFillAmount();
                  });
                },
                onPlanValueChanged: (value) {
                  setState(() {
                    _selectedPlanDays = value.isEmpty
                        ? 0
                        : (int.tryParse(value) ?? 0);
                    _calculateExpireDate();
                    _autoFillAmount();
                  });
                },
                onStartDateChanged: (value) {
                  setState(() {
                    _startDate = value;
                    _calculateExpireDate();
                  });
                },
                onExpiryDateChanged: (value) {
                  setState(() {
                    _expireDate = value;
                    _calculateSelectedPlanDays();
                    _planDurationController.text = _selectedPlanDays.toString();
                    _autoFillAmount();
                  });
                },
                onPaymentChanged: (value) {
                  setState(() => _paymentMode = value);
                },
                onChangeSlotSeat: () {
                  setState(() => _currentStep = 0);
                },
                onSubmit: _submit,
              ),
      ),
    );
  }
}
