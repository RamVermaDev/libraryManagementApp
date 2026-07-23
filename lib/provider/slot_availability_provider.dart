import 'package:flutter_riverpod/legacy.dart';
import 'package:library_management/models/slot_availability_model.dart';

final slotAvailabilityProvider =
    StateNotifierProvider<
      SlotAvailabilityNotifier,
      List<SlotAvailabilityModel>
    >((ref) {
      return SlotAvailabilityNotifier();
    });

class SlotAvailabilityNotifier
    extends StateNotifier<List<SlotAvailabilityModel>> {
  SlotAvailabilityNotifier() : super([]);

  void setSlots(List<SlotAvailabilityModel> slots) {
    state = slots;
  }

  SlotAvailabilityModel findSlot(String slotId) {
    return state.firstWhere((slot) => slot.slotTemplateId == slotId);
  }

  void clearSlots() {
    state = [];
  }
}

/// Tracks which slot card the owner has tapped on the booking screen.
final selectedSlotIdProvider = StateProvider<String?>((ref) => null);
