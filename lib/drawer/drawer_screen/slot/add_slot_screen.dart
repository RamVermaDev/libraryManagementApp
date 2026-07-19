import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/context_extension.dart';
import 'package:library_management/controllers/slot_controller.dart';
import 'package:library_management/models/slot_model.dart';
import 'package:library_management/provider/current_library_provider.dart';
import 'package:library_management/screens/revenueScreen/section_header.dart';
import 'package:library_management/screens/taskScreen/field/task_text_field.dart';
import 'package:library_management/screens/taskScreen/field/title_text.dart';

class AddSlotScreen extends ConsumerStatefulWidget {
  const AddSlotScreen({super.key, this.slot});

  final SlotModel? slot;

  @override
  ConsumerState<AddSlotScreen> createState() => _AddSlotScreenState();
}

class _AddSlotScreenState extends ConsumerState<AddSlotScreen> {
  final _formKey = GlobalKey<FormState>();
  final _slotName = TextEditingController();
  final _slotPrice = TextEditingController();
  final _startTime = TextEditingController();
  final _endTime = TextEditingController();

  final _slotController = SlotController();

  bool _isLoading = false;

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_initialized) return;
    _initialized = true;

    if (widget.slot != null) {
      _slotName.text = widget.slot!.name;
      _slotPrice.text = widget.slot!.monthlyPrice.toString();
      _startTime.text = _minutesToTime(widget.slot!.startMinute);
      _endTime.text = _minutesToTime(widget.slot!.endMinute);
    }
  }

  String _minutesToTime(int totalMinutes) {
    final hour = totalMinutes ~/ 60;
    final minute = totalMinutes % 60;

    return MaterialLocalizations.of(
      context,
    ).formatTimeOfDay(TimeOfDay(hour: hour, minute: minute));
  }

  int _timeToMinutes(String time) {
    final parts = time.split(':');
    int hour = int.parse(parts[0]);

    final minutePart = parts[1].split(' ');
    int minute = int.parse(minutePart[0]);
    final period = minutePart[1];

    if (period == "PM" && hour != 12) hour += 12;
    if (period == "AM" && hour == 12) hour = 0;

    return hour * 60 + minute;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final libraryId = ref.read(currentLibraryProvider);
    if (libraryId == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.slot == null) {
        await _slotController.createSlot(
          context: context,
          ref: ref,
          libraryId: libraryId,
          name: _slotName.text.trim(),
          monthlyPrice: double.parse(_slotPrice.text.trim()),
          startMinute: _timeToMinutes(_startTime.text.trim()),
          endMinute: _timeToMinutes(_endTime.text.trim()),
        );
      } else {
        await _slotController.editSlot(
          context: context,
          ref: ref,
          slotId: widget.slot!.id!,
          libraryId: libraryId,
          name: _slotName.text.trim(),
          monthlyPrice: double.parse(_slotPrice.text.trim()),
          startMinute: _timeToMinutes(_startTime.text.trim()),
          endMinute: _timeToMinutes(_endTime.text.trim()),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickTime(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 6, minute: 0),
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (!mounted || time == null) return;

    controller.text = MaterialLocalizations.of(
      this.context,
    ).formatTimeOfDay(time);
  }

  @override
  Widget build(BuildContext context) {
    final double scale = context.scale;
    return Container(
      width: double.infinity, // Full width
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 42,
                height: 5,
                margin: const EdgeInsets.only(top: 2, bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFD1D5DB),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),

            _titleHeading(
              title: widget.slot == null ? 'Add New Slot' : 'Edit Slot',
              scale: scale,
              context: context,
            ),
            SizedBox(height: 30),

            _SlotForm(
              buttonText: widget.slot == null ? 'Create Slot' : 'Update Slot',
              slotName: _slotName,
              slotPrice: _slotPrice,
              startTime: _startTime,
              endTime: _endTime,
              isLoading: _isLoading,
              onSubmit: _submit,
              onPickTime: (controller) => _pickTime(context, controller),
            ),

            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

class _SlotForm extends StatelessWidget {
  const _SlotForm({
    required this.slotName,
    required this.slotPrice,
    required this.startTime,
    required this.endTime,
    required this.onSubmit,
    required this.isLoading,
    required this.onPickTime,
    required this.buttonText,
  });

  final TextEditingController slotName;
  final TextEditingController slotPrice;
  final TextEditingController startTime;
  final TextEditingController endTime;

  final VoidCallback onSubmit;
  final Future<void> Function(TextEditingController controller) onPickTime;
  final bool isLoading;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    final double scale = context.scale;
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        TitleText(
          title: 'Slot Name',
          fontSize: 12 * scale,
          weight: FontWeight.w400,
          fontColor: AppColors.formLabel,
        ),
        SizedBox(height: 4 * scale),
        TaskTextField(
          hintText: 'e.g. Morning 6 Hrs',
          controller: slotName,
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Enter slot name';
            } else if (value.length < 4) {
              return 'Length must be  > 3';
            }
            return null;
          },
          fillColor: AppColors.background,
        ),

        SizedBox(height: 15 * scale),

        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleText(
                    title: "Start Time",
                    fontSize: 12 * scale,
                    weight: FontWeight.w400,
                    fontColor: AppColors.formLabel,
                  ),
                  SizedBox(height: 4 * scale),
                  GestureDetector(
                    onTap: () => onPickTime(startTime),
                    child: AbsorbPointer(
                      child: TaskTextField(
                        controller: startTime,
                        hintText: "06:00 AM",
                        fillColor: AppColors.background,
                        suffixIcon: const Icon(Icons.access_time),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: 12 * scale),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleText(
                    title: "End Time",
                    fontSize: 12 * scale,
                    weight: FontWeight.w400,
                    fontColor: AppColors.formLabel,
                  ),
                  SizedBox(height: 4 * scale),
                  GestureDetector(
                    onTap: () => onPickTime(endTime),
                    child: AbsorbPointer(
                      child: TaskTextField(
                        controller: endTime,
                        hintText: "12:00 PM",
                        fillColor: AppColors.background,
                        suffixIcon: const Icon(Icons.access_time),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: 15 * scale),

        TitleText(
          title: 'Price (₹/month)',
          fontSize: 12 * scale,
          weight: FontWeight.w400,
          fontColor: AppColors.formLabel,
        ),
        SizedBox(height: 4 * scale),
        TaskTextField(
          hintText: 'e.g. 500',
          controller: slotPrice,
          textInputAction: TextInputAction.next,
          validator: (value) {
            final text = value?.trim() ?? '';
            if (text.isEmpty) {
              return 'Enter monthly price';
            }
            final price = double.tryParse(text);
            if (price == null) {
              return 'Enter a valid amount';
            }
            if (price <= 0) {
              return 'Price must be greater than 0';
            }
            return null;
          },
          fillColor: AppColors.background,
        ),

        SizedBox(height: 25 * scale),

        SizedBox(
          width: double.infinity,
          height: 52,
          child: FilledButton(
            onPressed: isLoading ? () {} : onSubmit,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: isLoading
                ? SpinKitThreeBounce(color: Colors.white, size: 12)
                : Text(
                    buttonText,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.2,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

Widget _titleHeading({
  required String title,
  String subTitle = '',
  required double scale,
  required BuildContext context,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            SectionHeader(
              title: title,
              fontSize: 15 * scale,
              weight: FontWeight.w700,
              scale: scale,
            ),
            SizedBox(height: 6),
            if (subTitle.isNotEmpty) ...[
              SizedBox(height: 6 * scale),
              Text(
                subTitle,
                style: TextStyle(color: AppColors.body, fontSize: 12 * scale),
              ),
            ],
          ],
        ),
      ),
      InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.close_outlined, size: 18 * scale),
      ),
    ],
  );
}
