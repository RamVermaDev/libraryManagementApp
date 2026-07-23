import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/context_extension.dart';
import 'package:library_management/controllers/student_controller.dart';
import 'package:library_management/drawer/drawerWidgets/app_bar_widget.dart';
import 'package:library_management/models/slot_availability_model.dart';
import 'package:library_management/provider/current_library_provider.dart';
import 'package:library_management/provider/slot_availability_provider.dart';
import 'package:library_management/provider/seat_availability_provider.dart';
import 'package:library_management/screens/studentScreens/add_student_screens/additional_section.dart';
import 'package:library_management/screens/studentScreens/add_student_screens/membership_section.dart';
import 'package:library_management/screens/studentScreens/add_student_screens/personal_detail_section.dart';
import 'package:library_management/screens/studentScreens/add_student_screens/student_added_dialog.dart';

class AddStudentScreen extends ConsumerStatefulWidget {
  const AddStudentScreen({super.key});

  @override
  ConsumerState<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends ConsumerState<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();

  final _studentController = StudentController();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _idController = TextEditingController();
  final _discountController = TextEditingController();
  final _pendingController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  final _planDurationController = TextEditingController();

  DateTime startDate = DateTime.now();
  DateTime expireDate = DateTime.now();

  String payementMode = 'Cash';

  int _selectedPlanDays = 30;
  String selectedPlan = 'Monthly';

  late String selectedSlot;
  late SlotAvailabilityModel slotAvailabilityModel;
  late double price;

  static const Map<String, int> planDays = {
    "Monthly": 30,
    "Quarterly": 90,
    "Halfyearly": 180,
    "Yearly": 360,
  };

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _planDurationController.text = '30';

    final slotId = ref.read(selectedSlotIdProvider);

    if (slotId == null) {
      // Defensive: this screen should never be reachable without a slot
      // already chosen on BookSlotAndSeat. If it somehow is (deep link,
      // stale navigation state), bail out instead of crashing on a
      // null-assertion below.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.pop(context);
      });
      return;
    }

    selectedSlot = slotId;
    slotAvailabilityModel = ref
        .read(slotAvailabilityProvider.notifier)
        .findSlot(selectedSlot);

    price = slotAvailabilityModel.monthlyPrice;
    _amountController.text = price.toString();

    _calculateExpireDate();
  }

  Future<void> _addStudent() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Read the CURRENT amount from the field (it may have been edited by
    // the owner after being auto-filled) - not from any static plan data.
    final amount = double.tryParse(_amountController.text.trim()) ?? 0;
    final discount = double.tryParse(_discountController.text.trim()) ?? 0;
    final pending = double.tryParse(_pendingController.text.trim()) ?? 0;

    final finalAmount = amount - discount;
    final paidAmount = finalAmount - pending;

    final libraryId = ref.read(currentLibraryProvider);
    if (libraryId == null) return;

    // The seat the owner picked on BookSlotAndSeat (or null if they
    // explicitly chose to admit without one - counted as overbooking
    // on the backend).
    final seatId = ref.read(selectedSeatIdProvider);

    setState(() {
      _isLoading = true;
    });

    try {
      await _studentController.addStudent(
        context: context,
        ref: ref,
        libraryId: libraryId,
        slotTemplateId: selectedSlot,
        seatId: seatId,
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        idProof: _idController.text.trim().isEmpty
            ? null
            : _idController.text.trim(),
        currentPlanDays: _selectedPlanDays,
        startDate: startDate,
        expireDate: expireDate,
        amount: amount,
        discount: discount,
        paidAmount: paidAmount,
        paymentMode: paidAmount > 0 ? payementMode : null,
      );
    } finally {
      setState(() {
        _isLoading = false;
        Navigator.popUntil(context, (route) => route.isFirst);
      });
    }
  }

  void _calculateExpireDate() {
    expireDate = startDate.add(Duration(days: _selectedPlanDays - 1));
  }

  void _calculateSelectedPlanDays() {
    _selectedPlanDays = expireDate.difference(startDate).inDays + 1;
  }

  double roundUpToNext50(double amount) {
    return (amount / 50).ceil() * 50.0;
  }

  void finalAmount() {
    final amount = roundUpToNext50((price / 30) * _selectedPlanDays);
    _amountController.text = amount.toStringAsFixed(0);
    //_amountController.text = ((price / 30) * _selectedPlanDays).toString();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _idController.dispose();
    _discountController.dispose();
    _pendingController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    _planDurationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double scale = context.scale;
    return Scaffold(
      appBar: AppBarWidget(title: 'Add Member'),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 18, 14, 30),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _StudentForm(
                  scale: scale,
                  nameController: _nameController,
                  phoneController: _phoneController,
                  idController: _idController,
                  amountController: _amountController,
                  discountController: _discountController,
                  pendingController: _pendingController,
                  noteController: _noteController,
                  selectedPlanDays: _selectedPlanDays,
                  planDuration: _planDurationController,
                  expiryDate: expireDate,
                  startDate: startDate,
                  slotAvailabilityModel: slotAvailabilityModel,
                  onStartDateChanged: (value) {
                    setState(() {
                      startDate = value;
                      _calculateExpireDate();
                    });
                  },
                  onExpiryDateChanged: (value) {
                    setState(() {
                      expireDate = value;
                      _calculateSelectedPlanDays();
                      _planDurationController.text = _selectedPlanDays
                          .toString();
                      finalAmount();
                    });
                  },
                  payementMode: payementMode,
                  onPayementChange: (value) {
                    setState(() {
                      payementMode = value;
                    });
                  },
                  onPlanChange: (value) {
                    setState(() {
                      selectedPlan = value;
                      _selectedPlanDays = planDays[value]!;
                      _planDurationController.text = _selectedPlanDays
                          .toString();
                      _calculateExpireDate();
                      finalAmount();
                    });
                  },
                  onPlanValueChanged: (value) {
                    setState(() {
                      if (value.isEmpty) {
                        _selectedPlanDays = 0;
                      } else {
                        _selectedPlanDays = int.parse(value);
                      }
                      finalAmount();

                      _calculateExpireDate();
                    });
                  },
                  selectedPlan: selectedPlan,
                ),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    //onPressed: _addStudent,
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
                      bool? confirm;
                      try {
                        confirm = await showDialog<bool>(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => StudentAddedDialog(
                            name: _nameController.text,
                            phone: _phoneController.text,
                            timming: slotAvailabilityModel.formattedTime,
                            finalAmount: _amountController.text,
                          ),
                        ); // true or false
                      } finally {
                        print(confirm);
                        if (confirm!) {
                          _addStudent();
                        }
                      }
                    },
                    child: _isLoading
                        ? SpinKitThreeBounce(color: Colors.white, size: 14)
                        : const Text(
                            'Add Member',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StudentForm extends StatelessWidget {
  const _StudentForm({
    required this.nameController,
    required this.phoneController,
    double height = 35,
    required this.selectedPlanDays,
    required this.onStartDateChanged,
    required this.onExpiryDateChanged,
    required this.expiryDate,
    required this.onPayementChange,
    required this.payementMode,
    required this.onPlanChange,
    required this.idController,
    required this.scale,
    required this.discountController,
    required this.pendingController,
    required this.amountController,
    required this.noteController,
    required this.planDuration,
    required this.selectedPlan,
    required this.onPlanValueChanged,
    required this.slotAvailabilityModel,
    required this.startDate,
  }) : _height = height;

  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController idController;
  final TextEditingController discountController;
  final TextEditingController pendingController;
  final TextEditingController amountController;
  final TextEditingController noteController;
  final TextEditingController planDuration;

  final SlotAvailabilityModel slotAvailabilityModel;

  final int selectedPlanDays;

  final ValueChanged<DateTime> onStartDateChanged;
  final ValueChanged<DateTime> onExpiryDateChanged;
  final DateTime expiryDate;
  final DateTime startDate;

  final ValueChanged<String> onPayementChange;
  final String payementMode;

  final ValueChanged<String> onPlanChange;
  final ValueChanged<String> onPlanValueChanged;
  final String selectedPlan;

  final double _height;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PersonalDetailsSection(
          nameController: nameController,
          phoneController: phoneController,
          idController: idController,
          scale: scale,
        ),

        SizedBox(height: _height),

        MembershipSection(
          amountController: amountController,
          planDuration: planDuration,
          onPlanChanged: onPlanChange,
          onPlanValueChanged: onPlanValueChanged,
          selectedPlan: selectedPlan,
          onExpiryDateChanged: onExpiryDateChanged,
          onStartDateChanged: onStartDateChanged,
          slotAvailabilityModel: slotAvailabilityModel,
          expiryDate: expiryDate,
          startDate: startDate,
          selectedPayment: payementMode,
          onPaymentChanged: onPayementChange,

          scale: scale,
        ),

        SizedBox(height: _height),

        AdditionalSection(
          discountController: discountController,
          pendingController: pendingController,
          noteController: noteController,
          scale: scale,
        ),

        SizedBox(height: _height),
      ],
    );
  }
}
