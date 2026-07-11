import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/controllers/student_controller.dart';
import 'package:library_management/drawer/drawerWidgets/app_bar_widget.dart';
import 'package:library_management/screens/studentScreens/field/amount_display_field.dart';
import 'package:library_management/screens/studentScreens/field/end_student_date_field.dart';
import 'package:library_management/screens/studentScreens/field/payement_menu_dropdown.dart';
import 'package:library_management/screens/studentScreens/field/plan_menu_dropdown.dart';
import 'package:library_management/screens/studentScreens/field/program_menu_dropdown.dart';
import 'package:library_management/screens/studentScreens/field/start_student_date_field.dart';
import 'package:library_management/screens/studentScreens/field/student_text_form_field.dart';
import 'package:library_management/screens/studentScreens/sample/plan_data.dart';
import 'package:library_management/screens/studentScreens/sample/plan_data_list.dart';

class AddStudentScreen extends ConsumerStatefulWidget {
  const AddStudentScreen({super.key});

  @override
  ConsumerState<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends ConsumerState<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();

  final _studentController = StudentController();
  final libraryId = '6a422593f2ed24f734e41864';

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _idProofController = TextEditingController();
  final _discountController = TextEditingController();
  final _pendingController = TextEditingController();

  DateTime startDate = DateTime.now();
  DateTime expireDate = DateTime.now();

  String payementMode = 'Cash';

  // this data will fetch form backend
  int selectedProgramDays = 30;

  //plan selected data
  PlanData planSelected = planDataList[0];

  Future<void> _addStudent() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final amount = planSelected.price.toDouble();

    final discount = double.tryParse(_discountController.text.trim()) ?? 0;

    final pending = double.tryParse(_pendingController.text.trim()) ?? 0;

    final finalAmount = amount - discount;
    final paidAmount = finalAmount - pending;
    // We will add your actual library provider here

    await _studentController.addStudent(
      context: context,
      ref: ref,
      libraryId: libraryId,
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      idProof: _idProofController.text.trim().isEmpty
          ? null
          : _idProofController.text.trim(),
      planId: planSelected.name,
      programDays: selectedProgramDays,
      startDate: startDate,
      expireDate: expireDate,
      amount: amount,
      discount: discount,
      paidAmount: paidAmount,
      paymentMode: paidAmount > 0 ? payementMode : null,
    );
  }

  void _calculateExpireDate() {
    expireDate = startDate.add(Duration(days: selectedProgramDays));
  }

  @override
  void initState() {
    super.initState();
    _calculateExpireDate();
  }

  @override
  void dispose() {
    _discountController.dispose();
    _idProofController.dispose();
    _nameController.dispose();
    _pendingController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Add Member'),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.fromLTRB(25, 30, 25, 30),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _StudentForm(
                  nameController: _nameController,
                  phoneController: _phoneController,
                  idProof: _idProofController,
                  discount: _discountController,
                  pending: _pendingController,
                  selectedProgramDays: selectedProgramDays,
                  expireDate: expireDate,
                  onProgramChange: (days) {
                    setState(() {
                      selectedProgramDays = days;
                      _calculateExpireDate();
                    });
                  },
                  onStartDateChanged: (value) {
                    setState(() {
                      startDate = value;
                      _calculateExpireDate();
                    });
                  },
                  onExpireDateChanged: (value) {
                    setState(() {
                      expireDate = value;
                    });
                  },
                  payementMode: payementMode,
                  onPayementChange: (value) {
                    setState(() {
                      payementMode = value;
                    });
                  },
                  planSelected: planSelected,
                  onPlanChange: (value) {
                    setState(() {
                      planSelected = planDataList[value - 1];
                    });
                  },
                ),
                TextButton(
                  onPressed: _addStudent,
                  // onPressed: () {
                  //   final name = _nameController.text;
                  //   final phone = _phoneController.text;
                  //   final discount = _discountController.text;
                  //   final pendimg = _pendingController.text;
                  //   final id = _idProofController.text;
                  //   final amount = planSelected.price;
                  //   print('Student Name: $name');
                  //   print('Student phone: $phone');
                  //   print('Student ID: $id');
                  //   print('Student amount: $amount');
                  //   print('Student discount: $discount');
                  //   print('Student pending: $pendimg');
                  //   print('Start Date: $startDate');
                  //   print('End Date: $expireDate');
                  //   print('Payement: $payementMode');
                  //   print('Plan: ${planSelected.name}');
                  //   print('Program: $selectedProgramDays');
                  // },
                  child: Text('Checking'),
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
    double height = 15,
    required this.idProof,
    required this.discount,
    required this.pending,
    required this.selectedProgramDays,
    required this.onProgramChange,
    required this.onStartDateChanged,
    required this.onExpireDateChanged,
    required this.expireDate,
    required this.onPayementChange,
    required this.payementMode,
    required this.onPlanChange,
    required this.planSelected,
  }) : _height = height;

  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController idProof;
  final TextEditingController discount;
  final TextEditingController pending;

  //this will change after
  final int selectedProgramDays;
  final ValueChanged<int> onProgramChange;

  //for date
  final ValueChanged<DateTime> onStartDateChanged;
  final ValueChanged<DateTime> onExpireDateChanged;
  final DateTime expireDate;

  //payment
  final ValueChanged<String> onPayementChange;
  final String payementMode;

  //PLan
  final ValueChanged<int> onPlanChange;
  final PlanData planSelected;

  final double _height;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StudentTextFormField(
          controller: nameController,
          lable: 'Full Name',
          prefixIcon: Icons.near_me,
          validator: (p0) => null,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: _height),
        StudentTextFormField(
          controller: phoneController,
          lable: 'Phone Number',
          prefixIcon: Icons.call,
          validator: (p0) => null,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          maxLength: 10,
        ),

        SizedBox(height: _height),
        StudentTextFormField(
          controller: idProof,
          lable: 'ID Proof',
          prefixIcon: Icons.perm_identity,
          validator: (p0) => null,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          maxLength: 10,
          isRequired: false,
        ),

        SizedBox(height: _height),
        Divider(),

        Text(
          'Plan Detail',
          style: TextStyle(
            color: AppColors.activeButtonText,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        SizedBox(height: _height),

        //PROGRAM
        //program will be made by user and fetched by opening this page
        ProgramMenuDropdown(
          selectedValue: selectedProgramDays,
          onChange: onProgramChange,
        ),
        SizedBox(height: 12),

        //this is for the the DATE:- Start and End
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Start From', style: TextStyle(fontSize: 10)),
                  SizedBox(height: 2),
                  StartStudentDateField(onDateChanged: onStartDateChanged),
                ],
              ),
            ),

            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Expire At', style: TextStyle(fontSize: 10)),
                  SizedBox(height: 2),
                  EndStudentDateField(
                    initialDate: expireDate,
                    onDateChanged: onExpireDateChanged,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: _height),

        //PLAN
        //plan will fetch from the backend made by user
        PlanMenuDropdown(
          planSelected: planSelected.name,
          onChanged: onPlanChange,
        ),
        SizedBox(height: _height),

        //AMOUNT & PAYEMENT
        //amount will  be fecthed account o plan and program
        //payement mode will be given to parent
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(child: AmountDisplayField(amount: planSelected.price)),
            SizedBox(width: 10),
            PaymentMenuDropdown(
              selectedValue: payementMode,
              onChange: onPayementChange,
            ),
          ],
        ),
        SizedBox(height: 20),

        //this is row for DISCOUNT and PENDING
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: StudentTextFormField(
                controller: discount,
                lable: 'Discount',
                prefixIcon: Icons.discount,
                validator: (p0) => null,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                isRequired: false,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: StudentTextFormField(
                controller: pending,
                lable: 'Pending',
                prefixIcon: Icons.pending,
                validator: (p0) => null,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                isRequired: false,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
