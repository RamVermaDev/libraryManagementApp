import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
import 'package:library_management/provider/seat_config_provider.dart';
import 'package:library_management/provider/slot_availability_provider.dart';
import 'package:library_management/screens/seat_box.dart';
import 'package:library_management/screens/studentScreens/add_student_screens/additional_section.dart';
import 'package:library_management/screens/studentScreens/add_student_screens/membership_section.dart';
import 'package:library_management/screens/studentScreens/add_student_screens/slot_card_avalibility.dart';

class RenewAdmissionScreen extends ConsumerStatefulWidget {
  const RenewAdmissionScreen({
    super.key,
    required this.member,
    this.onRenewed,
  });

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

  static const Map<String, int> _planDays = {
    'Monthly': 30,
    'Quarterly': 90,
    'Halfyearly': 180,
    'Yearly': 360,
  };

  @override
  void initState() {
    super.initState();

    // Start = day after current expiry (or today if no expiry)
    final expiry = widget.member.currentExpireDate;
    _startDate = expiry != null
        ? expiry.add(const Duration(days: 1))
        : DateTime.now();
    _selectedPlanDays = 30;
    _planDurationController.text = '30';
    _expireDate = _startDate.add(const Duration(days: 29));

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

  double _roundUpToNext50(double amount) =>
      (amount / 50).ceil() * 50.0;

  void _autoFillAmount() {
    final slot = _selectedSlotModel;
    if (slot == null) return;
    final amount = _roundUpToNext50((slot.monthlyPrice / 30) * _selectedPlanDays);
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
    setState(() => _isLoadingSlots = false);

    // Pre-select the current slot after slots load
    if (_selectedSlotId != null) {
      final slots = ref.read(slotAvailabilityProvider);
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
    ref.read(selectedSlotIdProvider.notifier).state = slot.slotTemplateId;
    ref.read(selectedSeatIdProvider.notifier).state = null;
    ref.read(seatAvailabilityProvider.notifier).clearSeats();

    setState(() {
      _selectedSlotId = slot.slotTemplateId;
      _selectedSlotModel = slot;
      _selectedSeatId = null;
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
    setState(() => _isLoadingSeat = false);

    if (!isPreselect) {
      _scrollToKey(_seatSectionKey, alignment: 0.0);
    }

    // Check if student's old seat is still available in new slot
    final oldSeatId = widget.member.seatId;
    if (oldSeatId != null) {
      final seats = ref.read(seatAvailabilityProvider);
      final oldSeat = seats.where((s) => s.seatId == oldSeatId);
      if (oldSeat.isNotEmpty && !oldSeat.first.isAvailable) {
        setState(() => _seatTakenWarning = true);
      }
    }
  }

  void _onSeatTap(SeatAvailabilityModel seat) {
    if (!seat.isAvailable) return;
    final current = ref.read(selectedSeatIdProvider);
    final isDeselecting = current == seat.seatId;
    ref.read(selectedSeatIdProvider.notifier).state =
        isDeselecting ? null : seat.seatId;
    setState(() {
      _selectedSeatId = isDeselecting ? null : seat.seatId;
      _seatTakenWarning = false;
    });
  }

  // ─── Submit ──────────────────────────────────────────────────────────────────

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedSlotId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a slot')),
      );
      return;
    }

    final amount = double.tryParse(_amountController.text.trim()) ?? 0;
    final discount = double.tryParse(_discountController.text.trim()) ?? 0;
    final pending = double.tryParse(_pendingController.text.trim()) ?? 0;
    final finalAmount = amount - discount;
    final paidAmount = finalAmount - pending;

    // Show confirmation dialog before submitting renewal
    final slotDisplay = _selectedSlotModel?.formattedTime ?? 'Selected Slot';
    final bool? confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text(
          'Confirm Renewal',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ConfirmRow(label: 'Name', value: widget.member.name),
            _ConfirmRow(label: 'Phone', value: widget.member.phone),
            _ConfirmRow(label: 'Slot', value: slotDisplay),
            _ConfirmRow(
              label: 'Amount',
              value: '₹${_amountController.text}',
            ),
            _ConfirmRow(
              label: 'Plan',
              value: '$_selectedPlanDays days',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonPrimary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Renew'),
          ),
        ],
      ),
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
        startDate: DateTime.utc(_startDate.year, _startDate.month, _startDate.day),
        expireDate: DateTime.utc(_expireDate.year, _expireDate.month, _expireDate.day),
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
            ? _buildStep1SlotAndSeat(scale)
            : _buildStep2MembershipAndDetails(scale),
      ),
    );
  }

  // ─── Step 1: Slot & Seat Selection View ─────────────────────────────────────

  Widget _buildStep1SlotAndSeat(double scale) {
    final slots = ref.watch(slotAvailabilityProvider);
    final selectedSlotId = ref.watch(selectedSlotIdProvider);
    final seats = ref.watch(seatAvailabilityProvider);
    final selectedSeatId = ref.watch(selectedSeatIdProvider);

    return SingleChildScrollView(
      controller: _scrollController,
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
          // Student Info Card
          _StudentInfoCard(member: widget.member, scale: scale),

          SizedBox(height: 24 * scale),

          // Slot Selection Section
          _SectionHeader(
            icon: Icons.schedule_rounded,
            title: 'Select Slot',
            scale: scale,
          ),
          SizedBox(height: 12 * scale),

          if (_isLoadingSlots)
            const SizedBox(
              height: 140,
              child: Center(
                child: SpinKitThreeBounce(
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
            )
          else if (slots.isEmpty)
            const _EmptyView(message: 'No slots available')
          else
            Column(
              children: slots
                  .map<Widget>(
                    (slot) => SlotCardAvalibility(
                      scale: scale,
                      time: slot.formattedTime,
                      name: slot.name,
                      price: slot.formattedPrice,
                      availableSeats: slot.availableSeats,
                      isSelected: slot.slotTemplateId == selectedSlotId,
                      onTap: () => _onSlotTap(slot),
                    ),
                  )
                  .toList(),
            ),

          // Slot Full Warning
          if (_slotFullWarning) ...[
            SizedBox(height: 8 * scale),
            _WarningBanner(
              icon: Icons.warning_amber_rounded,
              color: AppColors.warning,
              message:
                  'This slot is full. You can still overbook or choose another slot.',
              scale: scale,
            ),
          ],

          // Seat Selection Section
          if (selectedSlotId != null) ...[
            SizedBox(height: 24 * scale),
            Container(
              key: _seatSectionKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader(
                    icon: Icons.chair_outlined,
                    title: 'Select Seat',
                    scale: scale,
                  ),
                  SizedBox(height: 10 * scale),
                  const SeatLegend(),
                  SizedBox(height: 14 * scale),

                  if (_seatTakenWarning) ...[
                    _WarningBanner(
                      icon: Icons.event_seat_rounded,
                      color: AppColors.error,
                      message:
                          'Previous seat is no longer available. Please choose a new seat.',
                      scale: scale,
                    ),
                    SizedBox(height: 10 * scale),
                  ],

                  if (_isLoadingSeat)
                    const SizedBox(
                      height: 120,
                      child: Center(
                        child: SpinKitThreeBounce(
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                    )
                  else if (seats.isEmpty)
                    const _EmptyView(message: 'No seats found')
                  else
                    _SeatGrid(
                      seats: seats,
                      selectedSeatId: selectedSeatId,
                      onSeatTap: _onSeatTap,
                      ref: ref,
                    ),

                  if (!_isLoadingSeat &&
                      seats.isNotEmpty &&
                      selectedSeatId == null) ...[
                    SizedBox(height: 10 * scale),
                    _WarningBanner(
                      icon: Icons.info_outline_rounded,
                      color: AppColors.primary,
                      message:
                          'No seat selected — admission will be overbooking.',
                      scale: scale,
                    ),
                  ],
                ],
              ),
            ),
          ],

          SizedBox(height: 28 * scale),

          // Continue Button to Step 2
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
              onPressed: _selectedSlotModel == null
                  ? null
                  : () {
                      setState(() => _currentStep = 1);
                    },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15 * scale,
                    ),
                  ),
                  SizedBox(width: 8 * scale),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 18 * scale,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Step 2: Membership & Additional Details View ───────────────────────────

  Widget _buildStep2MembershipAndDetails(double scale) {
    return Form(
      key: _formKey,
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
            // Student Info Card
            _StudentInfoCard(member: widget.member, scale: scale),

            SizedBox(height: 16 * scale),

            // Selected Slot & Seat Summary Card with Change option
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
                          _selectedSlotModel?.formattedTime ?? 'Selected Slot',
                          style: TextStyle(
                            fontSize: 14 * scale,
                            fontWeight: FontWeight.bold,
                            color: AppColors.heading,
                          ),
                        ),
                        SizedBox(height: 2 * scale),
                        Text(
                          _selectedSeatId != null
                              ? 'Assigned Seat'
                              : 'No Seat (Overbooking)',
                          style: TextStyle(
                            fontSize: 12 * scale,
                            color: AppColors.grey600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      setState(() => _currentStep = 0);
                    },
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
            if (_selectedSlotModel != null)
              MembershipSection(
                amountController: _amountController,
                planDuration: _planDurationController,
                onPlanChanged: (value) {
                  setState(() {
                    _selectedPlan = value;
                    _selectedPlanDays = _planDays[value]!;
                    _planDurationController.text =
                        _selectedPlanDays.toString();
                    _calculateExpireDate();
                    _autoFillAmount();
                  });
                },
                onPlanValueChanged: (value) {
                  setState(() {
                    _selectedPlanDays =
                        value.isEmpty ? 0 : (int.tryParse(value) ?? 0);
                    _calculateExpireDate();
                    _autoFillAmount();
                  });
                },
                selectedPlan: _selectedPlan,
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
                    _planDurationController.text =
                        _selectedPlanDays.toString();
                    _autoFillAmount();
                  });
                },
                startDate: _startDate,
                expiryDate: _expireDate,
                slotAvailabilityModel: _selectedSlotModel!,
                selectedPayment: _paymentMode,
                onPaymentChanged: (value) {
                  setState(() => _paymentMode = value);
                },
                scale: scale,
              ),

            SizedBox(height: 20 * scale),

            // Additional Section
            AdditionalSection(
              amountController: _amountController,
              discountController: _discountController,
              pendingController: _pendingController,
              noteController: _noteController,
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
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
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

// ─── Student Info Card ──────────────────────────────────────────────────────────

class _StudentInfoCard extends StatelessWidget {
  const _StudentInfoCard({required this.member, required this.scale});

  final StudentModel member;
  final double scale;

  String _formattedDate(DateTime? date) {
    if (date == null) return '—';
    return '${date.day}-${date.month}-${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isExpired = member.currentExpireDate != null &&
        member.currentExpireDate!.isBefore(DateTime.now());

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
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 28 * scale,
            backgroundColor: AppColors.primary.withValues(alpha: .12),
            backgroundImage: member.profileImage != null &&
                    member.profileImage!.isNotEmpty
                ? NetworkImage(member.profileImage!)
                : null,
            child:
                (member.profileImage == null || member.profileImage!.isEmpty)
                    ? Text(
                        member.name.isNotEmpty
                            ? member.name[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          fontSize: 20 * scale,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      )
                    : null,
          ),

          SizedBox(width: 14 * scale),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name,
                  style: TextStyle(
                    fontSize: 16 * scale,
                    fontWeight: FontWeight.w700,
                    color: AppColors.heading,
                  ),
                ),
                SizedBox(height: 2 * scale),
                Text(
                  member.phone,
                  style: TextStyle(
                    fontSize: 13 * scale,
                    color: AppColors.grey500,
                  ),
                ),
                SizedBox(height: 6 * scale),
                Text(
                  'Expires: ${_formattedDate(member.currentExpireDate)}',
                  style: TextStyle(
                    fontSize: 12 * scale,
                    color: isExpired ? AppColors.error : AppColors.grey500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Status Badge
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10 * scale,
              vertical: 4 * scale,
            ),
            decoration: BoxDecoration(
              color: isExpired
                  ? AppColors.error.withValues(alpha: .1)
                  : AppColors.success.withValues(alpha: .1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isExpired ? 'Expired' : 'Active',
              style: TextStyle(
                fontSize: 12 * scale,
                fontWeight: FontWeight.w600,
                color: isExpired ? AppColors.error : AppColors.success,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Section Header ─────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.scale,
  });

  final IconData icon;
  final String title;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18 * scale, color: AppColors.primary),
        SizedBox(width: 8 * scale),
        Text(
          title,
          style: TextStyle(
            fontSize: 15 * scale,
            fontWeight: FontWeight.w600,
            color: AppColors.heading,
          ),
        ),
      ],
    );
  }
}

// ─── Warning Banner ─────────────────────────────────────────────────────────────

class _WarningBanner extends StatelessWidget {
  const _WarningBanner({
    required this.icon,
    required this.color,
    required this.message,
    required this.scale,
  });

  final IconData icon;
  final Color color;
  final String message;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12 * scale),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: .3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18 * scale),
          SizedBox(width: 10 * scale),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 13 * scale,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Seat Grid ──────────────────────────────────────────────────────────────────

class _SeatGrid extends StatelessWidget {
  const _SeatGrid({
    required this.seats,
    required this.selectedSeatId,
    required this.onSeatTap,
    required this.ref,
  });

  final List<SeatAvailabilityModel> seats;
  final String? selectedSeatId;
  final void Function(SeatAvailabilityModel) onSeatTap;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final seatConfig = ref.watch(seatConfigProvider);
    final columns =
        (seatConfig?.columns != null && seatConfig!.columns > 0)
            ? seatConfig.columns
            : 5;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: seats.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final seat = seats[index];
        return SeatBox(
          seat: seat,
          isSelected: seat.seatId == selectedSeatId,
          onTap: () => onSeatTap(seat),
        );
      },
    );
  }
}

// ─── Empty View ─────────────────────────────────────────────────────────────────

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Center(
        child: Text(
          message,
          style: const TextStyle(color: AppColors.grey500),
        ),
      ),
    );
  }
}

// ─── Confirm Row ─────────────────────────────────────────────────────────────────

class _ConfirmRow extends StatelessWidget {
  const _ConfirmRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.grey500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.heading,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
