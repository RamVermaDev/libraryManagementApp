import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management/app_colors.dart';
import 'package:library_management/components/create_library_required_dialog.dart';
import 'package:library_management/controllers/slot_controller.dart';
import 'package:library_management/drawer/drawer_screen/slot/add_slot_screen.dart';
import 'package:library_management/drawer/drawer_screen/slot/delete_slot_dialog.dart';
import 'package:library_management/drawer/drawer_screen/slot/slot_card.dart';
import 'package:library_management/models/slot_model.dart';
import 'package:library_management/provider/current_library_provider.dart';
import 'package:library_management/provider/slot_provider.dart';

class SlotSetupScreen extends ConsumerStatefulWidget {
  const SlotSetupScreen({super.key});

  @override
  ConsumerState<SlotSetupScreen> createState() => _SlotSetupScreenState();
}

class _SlotSetupScreenState extends ConsumerState<SlotSetupScreen> {
  bool _loading = true;
  final _slotController = SlotController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadSlots());
  }

  Future<void> _onEditSlot(SlotModel slot) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddSlotScreen(slot: slot),
    );
  }

  Future<void> _onDeleteSlot(SlotModel slot) async {
    final confirm = await showDeleteSlotDialog(context, slotName: slot.name);

    if (confirm != true || !mounted) return;

    await _slotController.deleteSlot(
      context: context,
      ref: ref,
      slotId: slot.id!,
      libraryId: ref.read(currentLibraryProvider)!,
    );
  }

  Future<void> _onChangeSlotStatus(SlotModel slot) async {
    await _slotController.changeSlotStatus(
      context: context,
      ref: ref,
      slotId: slot.id!,
      libraryId: ref.read(currentLibraryProvider)!,
    );
  }

  Future<void> _loadSlots() async {
    final libraryId = ref.read(currentLibraryProvider);

    if (libraryId == null) {
      setState(() => _loading = false);
      return;
    }

    await _slotController.getAllSlots(
      context: context,
      ref: ref,
      libraryId: libraryId,
    );

    if (mounted) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final slots = ref.watch(slotProvider);

    return Scaffold(
      backgroundColor: AppColors.background,

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        icon: const Icon(Icons.add_rounded, size: 18),
        label: const Text(
          'Slot',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        onPressed: () {
          if (ref.read(currentLibraryProvider) == null) {
            showCreateLibraryRequiredDialog(context);
            return;
          }

          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            backgroundColor: Colors.transparent,
            builder: (_) => const AddSlotScreen(),
          );
        },
      ),

      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : slots.isEmpty
          ? const Center(child: Text("No slots available"))
          : RefreshIndicator(
              onRefresh: _loadSlots,
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(12, 30, 12, 100),
                itemCount: slots.length,
                itemBuilder: (context, index) {
                  final slot = slots[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: SlotCard(
                      slotName: slot.name,
                      startMinute: slot.startMinute,
                      endMinute: slot.endMinute,
                      price: "${slot.monthlyPrice}/month",
                      isActive: slot.isActive,
                      onEdit: () => _onEditSlot(slot),
                      onChangeStatus: () => _onChangeSlotStatus(slot),
                      onDelete: () => _onDeleteSlot(slot),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
