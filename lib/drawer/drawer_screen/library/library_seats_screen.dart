import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/context_extension.dart';
import 'package:library_management/controllers/library_controller.dart';
import 'package:library_management/drawer/drawerWidgets/app_bar_widget.dart';
import 'package:library_management/drawer/drawer_screen/library/widgets/build_seats_step.dart';
import 'package:library_management/models/library_model.dart';

class LibrarySeatsScreen extends ConsumerStatefulWidget {
  const LibrarySeatsScreen({
    super.key,
    required this.libraryName,
    required this.whatsappNumber,
    required this.city,
    this.library,
  });

  final String libraryName;
  final String whatsappNumber;
  final String city;
  final LibraryModel? library;

  bool get isEditMode => library != null;

  @override
  ConsumerState<LibrarySeatsScreen> createState() => _LibrarySeatsScreenState();
}

class _LibrarySeatsScreenState extends ConsumerState<LibrarySeatsScreen> {
  final _libraryController = LibraryController();
  final _formKeyStep2 = GlobalKey<FormState>();

  final TextEditingController totalSeatsController = TextEditingController();
  final TextEditingController prefixController = TextEditingController(text: "A");

  bool autoGenerateSeats = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.library != null) {
      totalSeatsController.text = widget.library!.totalSeats.toString();
    }
  }

  @override
  void dispose() {
    totalSeatsController.dispose();
    prefixController.dispose();
    super.dispose();
  }

  Future<void> submitLibrary() async {
    if (!_formKeyStep2.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      if (widget.isEditMode) {
        await _libraryController.updateLibrary(
          context: context,
          ref: ref,
          libraryId: widget.library!.id!,
          libraryName: widget.libraryName,
          whatsappNumber: widget.whatsappNumber,
          city: widget.city,
          totalSeats: int.tryParse(totalSeatsController.text.trim()) ?? 0,
          tagLine: widget.library!.tagLine,
          state: widget.library!.state,
          pinCode: widget.library!.pinCode,
        );
      } else {
        await _libraryController.createLibrary(
          context: context,
          ref: ref,
          libraryName: widget.libraryName,
          whatsappNumber: widget.whatsappNumber,
          city: widget.city,
          totalSeats: int.tryParse(totalSeatsController.text.trim()) ?? 0,
          tagLine: "",
          state: "",
          pinCode: "",
        );
      }

      if (mounted) {
        // Return true to MyLibraryScreen to trigger refresh
        Navigator.pop(context, true);
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double scale = context.scale;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget(
        title: widget.isEditMode ? 'Update Seats' : 'Configure Seats',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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

              const SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 52 * scale,
                  child: FilledButton(
                    onPressed: isLoading ? () {} : submitLibrary,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.buttonPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: isLoading
                        ? SpinKitThreeBounce(
                            color: Colors.white,
                            size: 16 * scale,
                          )
                        : Text(
                            widget.isEditMode ? 'Update Library' : 'Create Library',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15 * scale,
                            ),
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
