import 'package:flutter/material.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/components/app_dropdown_field.dart';
import 'package:library_management/components/app_text_field.dart';
import 'package:library_management/indian_state.dart';
import 'package:library_management/validator/form_validators.dart';

class LibraryProfileScreen extends StatefulWidget {
  const LibraryProfileScreen({super.key});

  @override
  State<LibraryProfileScreen> createState() => _LibraryProfileScreenState();
}

class _LibraryProfileScreenState extends State<LibraryProfileScreen> {
  static const double _fieldGap = 8;

  final _formKey = GlobalKey<FormState>();
  final _libraryName = TextEditingController();
  final _whatsappNumber = TextEditingController();
  final _tagLine = TextEditingController();
  final _city = TextEditingController();
  final _state = TextEditingController();
  final _pinCode = TextEditingController();

  String? selectedState;

  @override
  void dispose() {
    _libraryName.dispose();
    _whatsappNumber.dispose();
    _tagLine.dispose();
    _city.dispose();
    _state.dispose();
    _pinCode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = (constraints.maxWidth * 0.06)
                .clamp(20.0, 32.0)
                .toDouble();

            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                24,
                horizontalPadding,
                24,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 40,
                ),

                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Library Profile',
                        textAlign: TextAlign.center,
                        style: textTheme.headlineMedium?.copyWith(
                          color: AppColors.heading,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 120),
                      _LibraryProfileForm(
                        libraryName: _libraryName,
                        whatsappNumber: _whatsappNumber,
                        tagLine: _tagLine,
                        city: _city,
                        state: _state,
                        pinCode: _pinCode,
                        onSubmit: () {},
                        selectedState: selectedState,
                        onStateChanged: (value) {
                          setState(() {
                            selectedState = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LibraryProfileForm extends StatelessWidget {
  _LibraryProfileForm({
    required this.libraryName,
    required this.whatsappNumber,
    required this.city,
    required this.state,
    required this.pinCode,
    required this.tagLine,
    required this.onSubmit,

    required this.selectedState,
    required this.onStateChanged,
  });
  final TextEditingController libraryName;
  final TextEditingController whatsappNumber;
  final TextEditingController tagLine;
  final TextEditingController city;
  final TextEditingController state;
  final TextEditingController pinCode;
  final VoidCallback onSubmit;

  final String? selectedState;
  final List<String> states = IndianState.indianStates;
  final ValueChanged<String?> onStateChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTextField(
          hintTxt: 'Library Name',
          textEditingController: libraryName,
          textInputAction: TextInputAction.next,
          validator: FormValidators.libraryNameValidator,
        ),
        SizedBox(height: _LibraryProfileScreenState._fieldGap),
        AppTextField(
          hintTxt: 'WhatsApp Number',
          textEditingController: whatsappNumber,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number,
          validator: FormValidators.whatsappValidator,
        ),
        SizedBox(height: _LibraryProfileScreenState._fieldGap),
        AppTextField(
          hintTxt: 'Tag Line',
          textEditingController: tagLine,
          textInputAction: TextInputAction.next,
          validator: FormValidators.tagLineValidator,
        ),
        SizedBox(height: _LibraryProfileScreenState._fieldGap),
        AppTextField(
          hintTxt: 'City',
          textEditingController: city,
          textInputAction: TextInputAction.next,
          validator: FormValidators.cityValidator,
        ),
        SizedBox(height: _LibraryProfileScreenState._fieldGap),
        AppDropdownField(
          hintTxt: "Select State",
          value: selectedState,
          items: states,
          onChanged: onStateChanged,
        ),
        SizedBox(height: _LibraryProfileScreenState._fieldGap),
        AppTextField(
          hintTxt: 'Pincode',
          textEditingController: pinCode,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number,
          validator: FormValidators.pinCodeValidator,
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: onSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              foregroundColor: Colors.white,
              textStyle: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            child: const Text('Save'),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
