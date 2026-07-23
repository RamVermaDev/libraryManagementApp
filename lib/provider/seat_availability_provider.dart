import 'package:flutter_riverpod/legacy.dart';
import 'package:library_management/models/seat_availability_model.dart';

final seatAvailabilityProvider =
    StateNotifierProvider<
      SeatAvailabilityNotifier,
      List<SeatAvailabilityModel>
    >((ref) {
      return SeatAvailabilityNotifier();
    });

class SeatAvailabilityNotifier
    extends StateNotifier<List<SeatAvailabilityModel>> {
  SeatAvailabilityNotifier() : super([]);

  void setSeats(List<SeatAvailabilityModel> seats) {
    state = seats;
  }

  void clearSeats() {
    state = [];
  }
}

/// Which physical seat the owner tapped. Null is a VALID, deliberate state -
/// it means "no seat chosen", which the backend counts as overbooking on
/// submit, not an error.
final selectedSeatIdProvider = StateProvider<String?>((ref) => null);
