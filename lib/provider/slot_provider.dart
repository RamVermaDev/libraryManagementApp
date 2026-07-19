import 'package:flutter_riverpod/legacy.dart';
import 'package:library_management/models/slot_model.dart';

final slotProvider = StateNotifierProvider<SlotNotifier, List<SlotModel>>((
  ref,
) {
  return SlotNotifier();
});

class SlotNotifier extends StateNotifier<List<SlotModel>> {
  SlotNotifier() : super([]);

  // Set all slots after fetching from backend
  void setSlots(List<SlotModel> slots) {
    state = slots;
  }

  // Add one newly created slot
  void addSlot(SlotModel slot) {
    state = [slot, ...state];
  }

  // Update one slot
  void updateSlot(SlotModel updatedSlot) {
    state = [
      for (final slot in state)
        if (slot.id == updatedSlot.id) updatedSlot else slot,
    ];
  }

  // Delete one slot
  void deleteSlot(String slotId) {
    state = state.where((slot) => slot.id != slotId).toList();
  }

  // Update slot status (Active/Inactive)
  void updateSlotStatus(SlotModel updatedSlot) {
    state = [
      for (final slot in state)
        if (slot.id == updatedSlot.id) updatedSlot else slot,
    ];
  }

  // Clear all slots
  void clearSlots() {
    state = [];
  }
}
