import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/context_extension.dart';
import 'package:library_management/controllers/library_controller.dart';
import 'package:library_management/drawer/drawerWidgets/app_bar_widget.dart';
import 'package:library_management/drawer/drawer_screen/library/widgets/build_basic_step.dart';
import 'package:library_management/drawer/drawer_screen/library/widgets/build_bottom_buttons.dart';
import 'package:library_management/drawer/drawer_screen/library/widgets/build_seats_step.dart';
import 'package:library_management/drawer/drawer_screen/library/widgets/build_stepper.dart';
import 'package:library_management/models/library_model.dart';

class LibrarySetupScreen extends ConsumerStatefulWidget {
  const LibrarySetupScreen({super.key, this.library});

  final LibraryModel? library;

  @override
  ConsumerState<LibrarySetupScreen> createState() => _LibrarySetupScreenState();
}

class _LibrarySetupScreenState extends ConsumerState<LibrarySetupScreen>
    with SingleTickerProviderStateMixin {
  //==========================
  // Controllers
  //==========================

  final _libraryController = LibraryController();

  final _pageController = PageController();

  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();

  final TextEditingController libraryNameController = TextEditingController();

  final TextEditingController whatsappController = TextEditingController();

  final TextEditingController cityController = TextEditingController();

  final TextEditingController totalSeatsController = TextEditingController();

  final TextEditingController prefixController = TextEditingController(
    text: "A",
  );

  //==========================
  // Variables
  //==========================

  int currentStep = 0;

  bool autoGenerateSeats = true;

  bool isLoading = false;

  File? logoImage;

  bool get isEditMode => widget.library != null;

  String get submitLabel => isEditMode ? "Update Library" : "Create Library";

  //==========================
  // Dispose
  //==========================

  @override
  void initState() {
    super.initState();

    final library = widget.library;
    if (library == null) return;

    libraryNameController.text = library.libraryName;
    whatsappController.text = library.whatsappNumber;
    cityController.text = library.city;
    totalSeatsController.text = library.totalSeats.toString();
  }

  @override
  void dispose() {
    _pageController.dispose();

    libraryNameController.dispose();
    whatsappController.dispose();
    cityController.dispose();
    totalSeatsController.dispose();
    prefixController.dispose();

    super.dispose();
  }

  //==========================
  // Navigation
  //==========================

  Future<void> nextStep() async {
    if (currentStep == 0) {
      if (!_formKeyStep1.currentState!.validate()) return;

      setState(() {
        currentStep = 1;
      });

      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );

      return;
    }

    if (!_formKeyStep2.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      if (isEditMode) {
        await _libraryController.updateLibrary(
          context: context,
          ref: ref,
          libraryId: widget.library!.id!,
          libraryName: libraryNameController.text.trim(),
          whatsappNumber: whatsappController.text.trim(),
          city: cityController.text.trim(),
          totalSeats: int.tryParse(totalSeatsController.text.trim()) ?? 0,
          tagLine: widget.library!.tagLine,
          state: widget.library!.state,
          pinCode: widget.library!.pinCode,
        );
      } else {
        await _libraryController.createLibrary(
          context: context,
          ref: ref,
          libraryName: libraryNameController.text.trim(),
          whatsappNumber: whatsappController.text.trim(),
          city: cityController.text.trim(),
          totalSeats: int.tryParse(totalSeatsController.text.trim()) ?? 0,

          // Optional fields
          tagLine: "",
          state: "",
          pinCode: "",
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void previousStep() {
    setState(() {
      currentStep = 0;
    });

    _pageController.previousPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  final ImagePicker _picker = ImagePicker();

  Future<void> pickLogo() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Choose Logo",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () async {
                          Navigator.pop(context);

                          final XFile? image = await _picker.pickImage(
                            source: ImageSource.camera,
                            imageQuality: 85,
                          );

                          if (image != null) {
                            setState(() {
                              logoImage = File(image.path);
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 22),
                          decoration: BoxDecoration(
                            color: Colors.indigo.withValues(alpha: .08),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Column(
                            children: [
                              Icon(
                                Icons.photo_camera,
                                size: 34,
                                color: Colors.indigo,
                              ),
                              SizedBox(height: 10),
                              Text("Camera"),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () async {
                          Navigator.pop(context);

                          final XFile? image = await _picker.pickImage(
                            source: ImageSource.gallery,
                            imageQuality: 85,
                          );

                          if (image != null) {
                            setState(() {
                              logoImage = File(image.path);
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 22),
                          decoration: BoxDecoration(
                            color: Colors.indigo.withValues(alpha: .08),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Column(
                            children: [
                              Icon(
                                Icons.photo_library,
                                size: 34,
                                color: Colors.indigo,
                              ),
                              SizedBox(height: 10),
                              Text("Gallery"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  //==========================
  // UI
  //==========================

  @override
  Widget build(BuildContext context) {
    final double scale = context.scale;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget(
        title: widget.library == null ? 'Create Library' : 'Update Library',
      ),

      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20 * scale),

            buildStepper(currentStep),

            SizedBox(height: 24 * scale),

            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                children: [
                  buildBasicStep(
                    formKeyStep1: _formKeyStep1,
                    logoImage: logoImage,
                    libraryNameController: libraryNameController,
                    whatsappController: whatsappController,
                    cityController: cityController,
                    pickLogo: pickLogo,
                  ),
                  buildSeatStep(
                    formKeyStep2: _formKeyStep2,
                    totalSeatsController: totalSeatsController,
                    prefixController: prefixController,
                    autoGenerateSeats: autoGenerateSeats,
                    onAutoGenerateChanged: (value) {
                      setState(() {
                        autoGenerateSeats = value;
                      });
                    },
                    scale: scale,
                  ),
                ],
              ),
            ),

            buildBottomButtons(
              currentStep: currentStep,
              nextStep: nextStep,
              previousStep: previousStep,
              isLoading: isLoading,
              submitLabel: submitLabel,
              scale: scale,
            ),

            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }
}
